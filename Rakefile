require "rake"
require "yaml"
require "fileutils"
require "asciidoctor"
require "asciisourcerer"
require 'docopslab/dev'

# ============================================================================
# Git Branch Safety Utilities
# ============================================================================
# These methods provide safe branch switching by checking for:
# - Uncommitted changes (modified tracked files)
# - Untracked files that would conflict with target branch
#
# NOTE: Once stable, these will be moved to docopslab-dev gem
# ============================================================================

# Get the current branch name
def git_current_branch
  `git branch --show-current`.strip
end

# Check if working directory has uncommitted changes
def git_has_uncommitted_changes?
  !`git status --porcelain`.strip.empty?
end

# Get list of untracked files in working directory
def git_untracked_files
  `git ls-files --others --exclude-standard`.strip.split("\n")
end

# Get list of files in target branch
# Returns nil if branch doesn't exist
def git_files_in_branch(branch)
  # Check if branch exists
  result = `git rev-parse --verify #{branch} 2>/dev/null`.strip
  return nil if result.empty?

  # List all files in the branch
  `git ls-tree -r #{branch} --name-only`.strip.split("\n")
end

# Find untracked files that would conflict with target branch
# Returns nil if target branch doesn't exist
def git_conflicting_files(branch)
  branch_files = git_files_in_branch(branch)
  return nil if branch_files.nil?

  untracked = git_untracked_files
  untracked & branch_files # Intersection
end

# Check if it's safe to switch to target branch
def git_safe_to_switch?(branch, verbose: true)
  # Check for uncommitted changes
  if git_has_uncommitted_changes?
    puts '❌ You have uncommitted changes. Please commit or stash them first.' if verbose
    puts "💡 Run 'git status' to see changes." if verbose
    return false
  end

  # Check for conflicting untracked files (only if branch exists)
  conflicts = git_conflicting_files(branch)

  # If branch doesn't exist, that's fine (we might be creating it)
  return true if conflicts.nil?

  unless conflicts.empty?
    if verbose
      puts "❌ Untracked files would conflict with branch '#{branch}':"
      conflicts.each { |f| puts "   - #{f}" }
      puts '💡 Commit these files or remove them before switching branches.'
    end
    return false
  end

  true
end

# Ensure it's safe to switch branches, exit if not
def git_ensure_clean_switch!(branch, verbose: true)
  return if git_safe_to_switch?(branch, verbose: verbose)
  exit 1
end

# ============================================================================
# End Git Branch Safety Utilities
# ============================================================================

desc "Run all demo tests"
task :test do
  puts "🔍 Running ReleaseHx demo tests..."
  
  puts "\n=== CLI Tests ==="
  Rake::Task['test:cli'].invoke

  puts "\n=== README Commands Tests ==="
  Rake::Task['test:readme'].invoke

  puts "\n=== Dynamic Tests ==="
  Rake::Task['test:dynamic'].invoke

  puts "\n=== YAML Validation Tests ==="
  Rake::Task['test:yaml'].invoke

  puts "\n=== Content Quality Validation ==="
  Rake::Task['test:content'].invoke
  
  puts "\n✅ All demo tests passed!"
end

namespace :test do
  desc "Run CLI workflow tests"
  task :cli do
    puts "Testing CLI workflows..."

    # Create output directory
    FileUtils.mkdir_p("__tests/cli")

    # Test basic workflows
    puts "Testing Jira workflow..."
    sh "bundle exec rhx 1.1.0 --api-data _payloads/jira-description-note-1.1.0.json --config _configs/jira-description.yml --mapping _mappings_/description-note/jira.yaml --adoc __tests/cli/test-jira.adoc --force"

    puts "Testing GitHub workflow..."
    sh "bundle exec rhx 1.1.0 --api-data _payloads/github-label-tags-1.1.0.json --config _configs/github-label-tags.yml --adoc __tests/cli/test-github.adoc --force"

    puts "Testing auto-discovery..."
    sh "bundle exec rhx 1.1.0 --api-data _payloads/jira-description-note-1.1.0.json --config _configs/jira-description.yml --adoc __tests/cli/test-auto-discovery.adoc --force"
  end

  desc "Validate YAML files"
  task :yaml do
    puts "Validating YAML configuration files..."
    Dir.glob("_configs/*.yml").each do |file|
      puts "Validating #{file}..."
      begin
        YAML.load_file(file)
        puts "✓ #{file} is valid"
      rescue => e
        puts "✗ #{file} failed: #{e.message}"
        exit 1
      end
    end

    puts "Validating mapping files..."
    Dir.glob("_mappings_/**/*.yaml").each do |file|
      puts "Validating #{file}..."
      begin
        YAML.load_file(file)
        puts "✓ #{file} is valid"
      rescue => e
        puts "✗ #{file} failed: #{e.message}"
        exit 1
      end
    end
  end

  desc 'Test commands in README.adoc'
  task :readme do
    puts 'Executing testable commands from README.adoc'

    # Ensure output directories exist
    FileUtils.mkdir_p("__output/drafts")
    FileUtils.mkdir_p("__output/publish")
    FileUtils.mkdir_p("__tests/readme/drafts")
    FileUtils.mkdir_p("__tests/readme/publish")

    # Execute commands (they output to __output/)
    command_groups = Sourcerer.extract_commands('README.adoc', role: 'testable')
    command_groups.each do |group|
      sh "shopt -s expand_aliases; #{group}" unless group.strip.empty?
    end

    # Copy results to __tests/readme/ for test evidence
    puts "Copying demo outputs to test directory..."
    FileUtils.cp_r(Dir.glob("__output/drafts/*"), "__tests/readme/drafts/", verbose: false) if Dir.exist?("__output/drafts")
    FileUtils.cp_r(Dir.glob("__output/publish/*"), "__tests/readme/publish/", verbose: false) if Dir.exist?("__output/publish")
  end

  desc "Run dynamic tests from files-matrix.yml"
  task :dynamic do
    puts "Testing dynamic combinations from matrix..."
    sh "bundle exec ruby scripts/dynamic-gen.rb --execute --output-dir __tests/dynamic"
  end

  desc "Validate content quality of generated files"
  task :content do
    puts "Validating content quality of generated files..."
    sh "bundle exec ruby scripts/validate-content.rb"
  end
end

desc "Clean generated output files"
task :clean do
  puts "Cleaning generated files..."
  # Clean current output directories
  FileUtils.rm_rf("__output")
  FileUtils.rm_rf("__tests")
  FileUtils.rm_rf("artifacts")
  
  # Clean legacy directories
  FileUtils.rm_rf("drafts")
  FileUtils.rm_rf("__drafts")
  FileUtils.rm_rf("_publish")
  FileUtils.rm_rf("__publish")
  FileUtils.rm_rf("releases")
  
  puts "✓ Cleaned output directories"
end

desc "Setup demo environment"
task :setup do
  puts "Setting up demo environment..."
  puts "Demo environment ready"
end

desc "Run bundle install"
task :install do
  sh "bundle install"
end

namespace :install do
  desc "Ensure we have the latest ReleaseHx build from ../releasehx"
  task :dev do
    if REBUILD_RELEASEHX
      puts "Rebuilding ReleaseHx from ../releasehx..."
      sh "./dev-install.sh"
    else
      puts "Skipping ReleaseHx rebuild (SKIP_REBUILD=true)"
    end
  end
end

# Helper method to get current ReleaseHx version from CLI
def get_releasehx_version
  version = `bundle exec rhx --version 2>/dev/null`.strip
  if version.empty? || !$?.success?
    raise "Unable to determine ReleaseHx version. Is ReleaseHx installed? Try running 'rake setup' first."
  end
  version
end

# Helper method to get expected ReleaseHx version from README.adoc
def get_readme_releasehx_version
  doc = Asciidoctor.load_file('README.adoc')
  readme_version = doc.attributes['releasehx_vrsn']
  if readme_version.nil? || readme_version.empty?
    raise "Unable to find :releasehx_vrsn: attribute in README.adoc"
  end
  readme_version
end

# Helper method to get major.minor version from README.adoc for branch naming
def get_readme_releasehx_majmin
  doc = Asciidoctor.load_file('README.adoc')
  majmin_version = doc.attributes['releasehx_vrsn_majmin']
  if majmin_version.nil? || majmin_version.empty?
    raise "Unable to find :releasehx_vrsn_majmin: attribute in README.adoc"
  end
  majmin_version
end

# Helper method to validate version alignment
def validate_version_alignment
  cli_version = get_releasehx_version
  readme_version = get_readme_releasehx_version
  
  if cli_version != readme_version
    puts "VERSION MISMATCH:"
    puts "   CLI version (rhx --version): #{cli_version}"
    puts "   README.adoc :releasehx_vrsn: #{readme_version}"
    puts "   "
    puts "   To fix this, either:"
    puts "   1. Update :releasehx_vrsn: in README.adoc to #{cli_version}"
    puts "   2. Or rebuild ReleaseHx to match README version #{readme_version}"
    raise "Version alignment validation failed"
  end
  
  puts "Version alignment validated: #{cli_version}"
  cli_version
end

# Helper method to create artifacts-only branch
def create_artifacts_only_branch branch_name, releasehx_version
  puts "Creating artifacts-only branch: #{branch_name}"
  
  current_branch = git_current_branch
  artifact_path = "artifacts"
  
  # Ensure clean working directory before branch operations
  git_ensure_clean_switch!(branch_name)
  
  # Load TemplateGenerator and generate README
  require_relative 'scripts/dynamic-gen'
  template_generator = TemplateGenerator.new
  
  # Generate dynamic README content
  template_path = File.expand_path('scripts/README-generated.asciidoc', __dir__)
  readme_content = template_generator.generate_readme(releasehx_version, template_path)
  
  # Save generated README for use in new branch
  readme_path = File.join(__dir__, 'README-generated.adoc')
  File.write(readme_path, readme_content)
  puts "  Generated README from template with metadata"
  
  # Save files that need to be copied before switching branches
  gitignore_generated_content = File.read('.gitignore-generated') if File.exist?('.gitignore-generated')
  readme_generated_content = File.read(readme_path)
  
  # Check if branch exists and delete it for clean slate
  branch_exists = `git branch --list #{branch_name}`.strip.length > 0
  if branch_exists
    puts "  Deleting existing branch #{branch_name}..."
    sh "git branch -D #{branch_name}"
  end
  
  # Create orphan branch (no history, completely separate)
  puts "  Creating orphan branch #{branch_name}..."
  sh "git checkout --orphan #{branch_name}"
  
  # Remove all files from git index (orphan branch starts with all files staged)
  sh "git rm -rf . 2>/dev/null || true"
  
  # Remove all files from working directory except .git and artifacts
  Dir.glob("*", File::FNM_DOTMATCH).each do |file|
    next if file == "." || file == ".." || file == ".git" || file == "artifacts"
    FileUtils.rm_rf(file)
  end
  
  # Create .gitignore from saved content for artifacts-only branch
  if gitignore_generated_content
    File.write('.gitignore', gitignore_generated_content)
    puts "  Created .gitignore for artifacts-only branch (from .gitignore-generated)"
  end
  
  # Write README from generated content
  if readme_generated_content
    File.write('README.adoc', readme_generated_content)
    puts "  Created README.adoc for artifacts-only branch (dynamically generated)"
  else
    puts "  WARNING: Generated README content not found, skipping README creation"
  end
  
  # Add only the artifacts directory, README, and .gitignore
  sh "git add artifacts/ README.adoc .gitignore"
  
  # Commit the artifacts
  sh "git commit -m 'Generated artifacts for ReleaseHx #{releasehx_version} - #{Time.now.strftime('%Y-%m-%d %H:%M')}'"
  
  puts "✅ Artifacts-only branch #{branch_name} created successfully"
end

namespace :validate do
  desc "Validate ReleaseHx version alignment between CLI and README.adoc"
  task :version do
    validate_version_alignment
  end
end

namespace :generate do
  desc "Generate all demo artifacts on main branch"
  task :artifacts do
    releasehx_version = get_releasehx_version

    puts "Generating artifacts using ReleaseHx #{releasehx_version} on main branch..."

    # Clean first
    Rake::Task[:clean].invoke

    # Use dynamic generation script to generate artifacts in artifacts/ directory
    artifact_dir = "artifacts"
    puts "Running dynamic generation script to generate artifacts to #{artifact_dir}..."
    sh "bundle exec ruby scripts/dynamic-gen.rb --execute --output-dir #{artifact_dir} --flatten"

    puts "\nGenerated all available artifacts using ReleaseHx #{releasehx_version}"
    puts "  Artifacts directory: #{artifact_dir}/"
  end
end

namespace :create do
  desc "Create artifacts-only branch for current ReleaseHx version"
  task :branch do
    releasehx_version = validate_version_alignment
    majmin_version = get_readme_releasehx_majmin
    branch_name = "generated/#{majmin_version}"

    # Safety check BEFORE doing any work
    current_branch = git_current_branch
    unless current_branch == "main"
      puts "❌ Must be on main branch to create version branch"
      exit 1
    end

    git_ensure_clean_switch!(branch_name)

    # Generate artifacts on main branch
    Rake::Task['generate:artifacts'].invoke

    # Create artifacts-only branch
    create_artifacts_only_branch(branch_name, releasehx_version)

    puts "Artifacts-only branch #{branch_name} created successfully"
  end

  desc "Create artifacts-only latest branch"
  task :latest do
    releasehx_version = validate_version_alignment
    branch_name = "generated/latest"

    # Safety check BEFORE doing any work
    current_branch = git_current_branch
    unless current_branch == "main"
      puts "❌ Must be on main branch to create latest branch"
      exit 1
    end

    git_ensure_clean_switch!(branch_name)

    # Generate artifacts on main branch
    Rake::Task['generate:artifacts'].invoke

    # Create artifacts-only branch
    create_artifacts_only_branch(branch_name, releasehx_version)

    puts "Artifacts-only branch #{branch_name} created successfully"
  end
end

namespace :generate do
  desc "Complete artifacts-only workflow for versioned branch"
  task :release do
    releasehx_version = validate_version_alignment
    majmin_version = get_readme_releasehx_majmin

    puts "Complete artifacts-only release generation workflow for ReleaseHx #{releasehx_version}"

    # Ensure we start from a clean main branch
    current_branch = git_current_branch
    unless current_branch == "main"
      puts "Switching to main branch for clean workflow start..."
      sh "git checkout main"
    end

    # Check if main branch is clean
    git_ensure_clean_switch!("generated/#{majmin_version}")

    puts "✅ Starting artifacts-only workflow from clean main branch"

    # Create the artifacts-only branch
    Rake::Task['create:branch'].invoke

    # Return to main branch and clean up artifacts
    sh "git checkout main"
    Rake::Task[:clean].invoke

    puts "🎉 Artifacts-only workflow complete! Check 'generated/#{majmin_version}' branch."
  end

  desc "Complete artifacts-only workflow for latest branch"
  task :latest do
    releasehx_version = validate_version_alignment

    puts "Complete artifacts-only latest release workflow for ReleaseHx #{releasehx_version}"

    # Ensure we start from a clean main branch
    current_branch = git_current_branch
    unless current_branch == "main"
      puts "Switching to main branch for clean workflow start..."
      sh "git checkout main"
    end

    # Check if main branch is clean
    git_ensure_clean_switch!("generated/latest")

    puts "✅ Starting artifacts-only workflow from clean main branch"

    # Create the artifacts-only branch
    Rake::Task['create:latest'].invoke

    # Return to main branch and clean up artifacts
    sh "git checkout main"
    Rake::Task[:clean].invoke

    puts "🎉 Artifacts-only latest workflow complete! Check 'generated/latest' branch."
  end
end

namespace :test do
  desc "Run comprehensive test suite"
  task pr: [:setup, 'test:yaml', :test] do
    puts "All comprehensive tests passed!"
  end
end
