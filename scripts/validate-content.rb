#!/usr/bin/env ruby

require 'yaml'
require 'json'

class ContentValidator
  def initialize(base_path = 'artifacts/rhx-*')
    @base_path = base_path
    @failures = []
    @successes = []
  end

  def validate_all
    puts "Validating content in generated files..."
    puts "Base path: #{@base_path}"
    puts "=" * 50
    
    validate_yaml_files
    validate_markdown_files  
    validate_asciidoc_files
    validate_html_files
    
    print_summary
    
    @failures.empty? ? 0 : 1
  end

  private

  def validate_yaml_files
    puts "\n=== Validating YAML files ==="
    
    Dir.glob("#{@base_path}/*.yaml").each do |file|
      content = File.read(file)
      
      # Basic structure check
      unless content.include?('code:') && content.include?('date:') && content.include?('changes:')
        record_failure(file, "Missing basic YAML structure (code/date/changes)")
        next
      end
      
      # Content check; should have at least one change with chid
      if content.include?('- chid:')
        # Has actual changes
        record_success(file, "Contains change entries")
        
        # More detailed validation
        if content.include?('summ:') && content.include?('tick:')
          record_success(file, "Has detailed issue information")
        end
      else
        # Check if this is intentionally empty (like jira-customfield-changelog)
        if file.include?('jira-customfield-changelog')
          record_success(file, "Empty as expected (excluded by tag filters)")
        else
          record_failure(file, "No change entries found (missing 'chid:')")
        end
      end
    end
  end

  def validate_markdown_files
    puts "\n=== Validating Markdown files ==="
    
    Dir.glob("#{@base_path}/*.md").each do |file|
      content = File.read(file)
      lines = content.lines.count
      
      # Very short files are likely empty/broken
      if lines < 10
        record_failure(file, "Too short (#{lines} lines) - likely empty")
        next
      end
      
      # Should have proper headers
      unless content.match(/^# /) || content.match(/^## /)
        record_failure(file, "No markdown headers found")
        next
      end
      
      # Should not have unprocessed template variables
      if content.include?('{{ ') && content.include?(' }}')
        record_failure(file, "Contains unprocessed template variables")
        next
      end
      
      # Check for actual content patterns
      content_indicators = [
        content.match(/Test Valid Type Bug/),          # GitHub test content
        content.match(/PROJ-\d+/),                     # Jira issue keys
        content.match(/collaboration features/),       # GitLab content
        content.match(/HOTFIX-\d+|SEC-\d+|FEAT-\d+/),  # Kitchen sink content
        content.match(/inline editing|dashboard/),     # Common Jira content
        content.match(/dark mode toggle/),             # GitHub label tags content
        content.match(/\[NOTE\]|\(\d+\)/),             # Issue references
        content.match(/### \w+|#### \w+/),             # Content sections with actual entries
        content.match(/\[.+\]\(.+\)/)                  # Markdown links (issue links)
      ].compact
      
      if content_indicators.any?
        record_success(file, "Contains expected issue content")
      else
        record_failure(file, "No recognizable issue content found")
      end
    end
  end

  def validate_asciidoc_files
    puts "\n=== Validating AsciiDoc files ==="
    
    Dir.glob("#{@base_path}/*.adoc").each do |file|
      content = File.read(file)
      lines = content.lines.count
      
      # Very short files are likely empty/broken
      if lines < 15
        record_failure(file, "Too short (#{lines} lines) - likely empty")
        next  
      end
      
      # Should have proper AsciiDoc headers
      unless content.match(/^= /) || content.match(/^== /)
        record_failure(file, "No AsciiDoc headers found")
        next
      end
      
      # Should not have unprocessed template variables
      if content.include?('{{ ') && content.include?(' }}')
        record_failure(file, "Contains unprocessed template variables")
        next
      end
      
      # Should have AsciiDoc-specific formatting
      asciidoc_indicators = [
        content.include?(':icons: font'),
        content.include?('icon:'),
        content.match(/\[.*\]/),  # AsciiDoc attributes
        content.match(/\|===/)    # Tables
      ]
      
      if asciidoc_indicators.any?
        record_success(file, "Contains proper AsciiDoc formatting")
      else
        record_failure(file, "Missing AsciiDoc-specific formatting")
      end
    end
  end

  def validate_html_files
    puts "\n=== Validating HTML files ==="
    
    Dir.glob("#{@base_path}/*.html").each do |file|
      content = File.read(file)
      
      # Should have basic HTML structure
      unless content.include?('<div') || content.include?('<h1') || content.include?('<h2')
        record_failure(file, "No HTML structure found")
        next
      end
      
      # Check for meaningful content vs empty templates
      # Empty files often have just template structure without actual issue data
      content_indicators = [
        content.match(/Test Valid Type Bug/),
        content.match(/PROJ-\d+/),
        content.match(/collaboration features/),
        content.match(/HOTFIX-\d+|SEC-\d+|FEAT-\d+/),
        content.match(/inline editing|dashboard/),
        content.match(/dark mode toggle/)
      ].compact
      
      if content_indicators.any?
        record_success(file, "Contains actual issue content")
      else
        # Check if HTML just has template structure (suggests wrong source YAML)
        if content.include?('<div class="sect1">') && content.length > 1000
          record_failure(file, "Has template structure but no actual content (wrong source?)")
        else
          record_failure(file, "No recognizable content")
        end
      end
    end
  end

  def record_success(file, message)
    @successes << { file: file, message: message }
    puts "✅ #{File.basename(file)}: #{message}"
  end

  def record_failure(file, message)
    @failures << { file: file, message: message }
    puts "❌ #{File.basename(file)}: #{message}"
  end

  def print_summary
    puts "\n" + "=" * 60
    puts "VALIDATION SUMMARY"
    puts "=" * 60
    puts "✅ Passed: #{@successes.count}"
    puts "❌ Failed: #{@failures.count}"
    
    if @failures.any?
      puts "\nFailed files:"
      @failures.each do |failure|
        puts "  - #{failure[:file]}: #{failure[:message]}"
      end
    end
    
    # Group failures by type for analysis
    failure_types = @failures.group_by { |f| f[:message] }
    if failure_types.any?
      puts "\nFailure patterns:"
      failure_types.each do |message, failures|
        puts "  - #{message}: #{failures.count} files"
      end
    end
  end
end

if __FILE__ == $0
  validator = ContentValidator.new
  exit validator.validate_all
end