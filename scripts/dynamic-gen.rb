# frozen_string_literal: true

require 'English'
require 'erb'
require 'yaml'
require 'fileutils'
require 'liquid'
require 'releasehx' # For SchemaGraphy

MATRIX_FILE = File.expand_path('../specs/data/files-matrix.yml', __dir__)
DEFAULT_FORMATS = %w[yaml md adoc html pdf].freeze

# ==========================================================================
# Shared Utilities
# ==========================================================================

module GeneratorUtils
  # Format bytes into human-readable string
  def self.format_bytes bytes
    return "#{bytes}B" if bytes < 1024

    kb = bytes / 1024.0
    return "#{kb.round}K" if kb < 1024

    "#{(kb / 1024.0).round(1)}M"
  end

  # Infer platform from slug or config path
  def self.infer_platform slug, _config_path = nil
    slug_lower = slug.to_s.downcase
    return 'github' if slug_lower.include?('github')
    return 'gitlab' if slug_lower.include?('gitlab')
    return 'jira' if slug_lower.include?('jira')
    return 'generic' if slug_lower.include?('generic') || slug_lower.include?('kitchen')

    'unknown'
  end

  # Get config base name
  def self.config_base config_path
    File.basename(config_path, '.yml')
  end
end

# ==========================================================================
# CommandGenerator - Artifact generation
# ==========================================================================

class CommandGenerator
  attr_reader :matrix_data

  def initialize matrix_file = MATRIX_FILE, output_dir = nil, flatten: false
    @matrix_data = SchemaGraphy::Loader.load_yaml_with_tags(matrix_file)
    @draft_template = ERB.new(DRAFT_TEMPLATE, trim_mode: '%-')
    @enrich_template = ERB.new(ENRICH_TEMPLATE, trim_mode: '%-')
    @api_template = ERB.new(API_TEMPLATE, trim_mode: '%-')
    @output_dir = output_dir
    @flatten = flatten # For artifacts: flat structure, for tests: subdivided
  end

  # Template for draft generation commands (yaml, md, adoc from API data)
  DRAFT_TEMPLATE = <<~'ERB'
    bundle exec rhx <%= version %> \
      --config <%= config %> \
      --api-data <%= payload %> \<% if mapping %>
      --mapping <%= mapping %> \<% end %><% if output_path %>
      --<%= format %> <%= output_path %> \<% end %>
      --force
  ERB

  # Template for enrichment commands (html, pdf from draft file)
  ENRICH_TEMPLATE = <<~'ERB'
    bundle exec rhx <%= draft_path %> \
      --config <%= config %> \<% if output_path %>
      --<%= format %> <%= output_path %> \<% end %>
      --force
  ERB

  # Template for API usage
  API_TEMPLATE = <<~ERB
    ReleaseHx::Generator.new(
      config: '<%= config %>',<% if mapping %>
      mapping: '<%= mapping %>',<% end %>
      format: '<%= format %>'
    ).process_file(
      '<%= payload %>',
      version: '<%= version %>',
      output: '<%= output_path %>'
    )
  ERB

  def config_base config_path
    GeneratorUtils.config_base(config_path)
  end

  def build_output_path config_base, version, format
    return nil unless @output_dir

    if @flatten
      # Flat structure for artifacts: artifacts/rhx-0.1/github-basic-1.0.0.yaml
      "#{@output_dir}/#{config_base}-#{version}.#{format}"
    else
      # Subdivided structure for tests: __tests/dynamic/github-basic/1.0.0.yaml
      "#{@output_dir}/#{config_base}/#{version}.#{format}"
    end
  end

  def generate_commands combo
    commands = []
    configs = Array(combo['config'] || combo['configs'])
    payloads = Array(combo['payload'] || combo['payloads'])
    formats = combo['formats'] || DEFAULT_FORMATS

    # Separate draft formats from enrichment formats
    draft_formats = formats & %w[yaml md adoc]
    enrich_formats = formats & %w[html pdf]

    configs.each do |config|
      config_name = config_base(config)

      # Match each payload with its version
      payloads.zip(combo['versions']) do |payload, version|
        # Track the YAML draft path for enrichment operations
        yaml_draft_path = nil

        # Generate draft format commands first
        draft_formats.each do |format|
          output_path = build_output_path(config_name, version, format)

          # Ensure subdirectory exists for subdivided structure
          FileUtils.mkdir_p(File.dirname(output_path)) if output_path && !@flatten

          # Track YAML output path for later enrichment
          yaml_draft_path = output_path if format == 'yaml'

          # Generate draft command
          draft_vars = {
            version: version,
            config: config,
            payload: payload,
            mapping: combo['mapping'],
            format: format,
            output_path: output_path
          }
          commands << @draft_template.result_with_hash(draft_vars)

          # Generate API usage example (skip for output_dir mode)
          unless @output_dir
            api_vars = draft_vars.dup
            commands << @api_template.result_with_hash(api_vars)
          end
        end

        # Generate enrichment format commands (only if YAML draft exists)
        if yaml_draft_path
          enrich_formats.each do |format|
            output_path = build_output_path(config_name, version, format)

            # Ensure subdirectory exists for subdivided structure
            FileUtils.mkdir_p(File.dirname(output_path)) if output_path && !@flatten

            # Generate enrichment command using YAML draft as source
            enrich_vars = {
              draft_path: yaml_draft_path,
              config: config,
              format: format,
              output_path: output_path
            }
            commands << @enrich_template.result_with_hash(enrich_vars)
          end
        elsif enrich_formats.any?
          puts "WARN: Skipping #{enrich_formats.join(', ')} for #{config_name} #{version} - no YAML draft specified"
        end
      end
    end
    commands
  end

  def ensure_output_dirs commands
    # No longer needed; directories created in generate_commands
  end

  def execute_all
    passed = 0
    failed = 0
    errors = []

    @matrix_data['combinations'].each do |combo|
      puts "\nExecuting commands for #{combo['slug']}..."
      commands = generate_commands(combo)

      # Only create output dirs for releases/ structure
      ensure_output_dirs(commands) unless @output_dir

      commands.each do |cmd|
        if cmd.start_with?('bundle exec')
          puts "\nRunning CLI command:"
          puts cmd
          success = system(cmd)
          if success
            passed += 1
          else
            failed += 1
            errors << "Failed: #{combo['slug']} - #{cmd.split[4]}" # Extract format
            puts "❌ Command failed with exit code #{$CHILD_STATUS.exitstatus}"
          end
        else
          puts "\nAPI usage example:"
          puts cmd
          # Could eval this if we want to actually run the API version
          # eval(cmd)
        end
      end
    end

    puts "\n#{'='*60}"
    puts 'EXECUTION SUMMARY'
    puts '='*60
    puts "✅ Passed: #{passed}"
    puts "❌ Failed: #{failed}"
    if errors.any?
      puts "\nFailed commands:"
      errors.each { |error| puts "  - #{error}" }
    end
    puts

    # Only verify releases/ output, not artifacts/
    return if @output_dir

    verify_output
    validate_content
  end

  def print_all
    @matrix_data['combinations'].each do |combo|
      puts "\nCommands for #{combo['slug']}:"
      puts "Description: #{combo['desc']}"
      puts '-' * 50

      commands = generate_commands(combo)
      commands.each_with_index do |cmd, i|
        puts "\n#{i.even? ? 'CLI' : 'API'} command:"
        puts cmd
      end
    end
  end

  def verify_output
    puts "\n#{'='*50}"
    puts 'Verifying output...'
    puts '='*50

    empty_dirs = `find releases -type d -empty`.split("\n")
    if empty_dirs.any?
      puts "\nFound empty directories:"
      empty_dirs.each { |d| puts "- #{d}" }
    else
      puts "\nNo empty directories found."
    end

    empty_files = `find releases -type f -empty`.split("\n")
    if empty_files.any?
      puts "\nFound empty files:"
      empty_files.each { |f| puts "- #{f}" }
    else
      puts "\nNo empty files found."
    end
  end

  def validate_content
    puts "\n#{'='*50}"
    puts 'Validating content quality...'
    puts '='*50

    require_relative 'validate-content'
    validator = ContentValidator.new
    exit_code = validator.validate_all

    if exit_code.zero?
      puts "\n✅ All generated content passed validation."
    else
      puts "\n⚠️  Content validation found issues. See details above."
    end
  end
end

# ==========================================================================
# TemplateGenerator - README template rendering
# ==========================================================================

class TemplateGenerator
  attr_reader :matrix_data, :artifacts_dir

  def initialize matrix_file = MATRIX_FILE, artifacts_dir = 'artifacts'
    @matrix_data = SchemaGraphy::Loader.load_yaml_with_tags(matrix_file)
    @artifacts_dir = artifacts_dir
  end

  # Collect metadata from generated artifacts
  def collect_metadata releasehx_version
    metadata = {
      'releasehx_version' => releasehx_version,
      'generation_date' => Time.now.strftime('%Y-%m-%d'),
      'combinations' => [],
      'featured_combinations' => []
    }

    @matrix_data['combinations'].each do |combo|
      combo_data = combo.dup
      combo_data['platform'] = GeneratorUtils.infer_platform(combo['slug'], combo['config'])
      combo_data['artifacts'] = {}
      combo_data['file_order'] = %w[pdf md adoc yaml]

      # Process each config
      configs = Array(combo['config'] || combo['configs'])

      # Use first config as representative for metadata
      config_name = GeneratorUtils.config_base(configs.first)

      combo['versions'].each do |version|
        version_data = {
          'change_count' => 0,
          'note_count' => 0,
          'files' => {}
        }

        # Parse YAML for change/note counts
        yaml_file = File.join(@artifacts_dir, "#{config_name}-#{version}.yaml")
        if File.exist?(yaml_file)
          begin
            yaml_content = SchemaGraphy::Loader.load_yaml_with_tags(yaml_file)
            if yaml_content['releases'] && yaml_content['releases'][0]
              changes = yaml_content['releases'][0]['changes'] || []
              version_data['change_count'] = changes.size
              version_data['note_count'] = changes.count { |c| c['note'] && !c['note'].empty? }
            end
          rescue StandardError => e
            puts "WARN: Could not parse #{yaml_file}: #{e.message}"
          end
        end

        # Gather file sizes for all formats
        %w[yaml md adoc html pdf].each do |format|
          file_path = File.join(@artifacts_dir, "#{config_name}-#{version}.#{format}")
          next unless File.exist?(file_path)

          file_size = File.size(file_path)
          version_data['files'][format] = {
            'path' => file_path,
            'size' => file_size,
            'size_human' => GeneratorUtils.format_bytes(file_size)
          }
        end

        combo_data['artifacts'][version] = version_data
      end

      metadata['combinations'] << combo_data

      # Add to featured if showcase key present
      metadata['featured_combinations'] << combo_data if combo.key?('showcase')
    end

    metadata
  end

  # Render template with metadata
  def render_template template_path, metadata
    template_content = File.read(template_path)
    template = Liquid::Template.parse(template_content)
    template.render(metadata)
  end

  # Generate README from template
  def generate_readme releasehx_version, template_path, output_path = nil
    metadata = collect_metadata(releasehx_version)
    metadata['version'] = releasehx_version
    rendered = render_template(template_path, metadata)

    if output_path
      File.write(output_path, rendered)
      puts "✅ Generated README at #{output_path}"
    end

    rendered
  end
end

# ==========================================================================
# CLI
# ==========================================================================

if __FILE__ == $PROGRAM_NAME
  require 'optparse'

  options = {
    execute: false,
    output_dir: nil,
    flatten: false
  }

  OptionParser.new do |opts|
    opts.banner = 'Usage: dynamic-gen.rb [options]'

    opts.on('--execute', 'Execute the generated commands') do
      options[:execute] = true
    end

    opts.on('--output-dir DIR', 'Output directory (for tests or artifacts)') do |dir|
      options[:output_dir] = dir
    end

    opts.on('--flatten', 'Use flat structure (for artifacts)') do
      options[:flatten] = true
    end

    opts.on('-h', '--help', 'Prints this help') do
      puts opts
      exit
    end
  end.parse!

  generator = CommandGenerator.new(MATRIX_FILE, options[:output_dir], flatten: options[:flatten])

  if options[:execute]
    generator.execute_all
  else
    generator.print_all
  end
end
