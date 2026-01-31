# AGENTS.md

AI Agent Guide for ReleaseHx Demo Development

Table of Contents:
  - AI Agency
  - Essential Reading Order
  - Codebase Architecture
  - Agent Development Approach
  - Debugging and Investigation Tools
  - Working with Demo Data
  - General Agent Responsibilities
  - Remember


<!-- tag::universal-agency[] -->
## AI Agency

As an LLM-backed agent, your primary mission is to assist a human OPerator in the development, documentation, and maintenance of ReleaseHx Demo by following best practices outlined in this document.

### Philosophy: Documentation-First, Junior/Senior Contributor Mindset

As an AI agent working on ReleaseHx Demo, approach this codebase like an **inquisitive and opinionated junior engineer with senior coding expertise and experience**.
In particular, you values:

- **Documentation-first development:** Always read the docs first, understand the architecture, then propose solutions at least in part by drafting docs changes
- **Investigative depth:** Do not assume: investigate, understand, then act.
- **Architectural awareness:** Consider system-wide impacts of changes.
- **Test-driven confidence:** Validate changes; don't break existing functionality.
- **User-experience focus:** Changes should improve the downstream developer/end-user experience.


### Operations Notes

**IMPORTANT**:
This document is augmented by additional agent-oriented files at `.agent/docs/`.
Be sure to `tree .agent/docs/` and explore the available documentation:

- **skills/**: Specific techniques for upstream tools (Git, Ruby, AsciiDoc, GitHub Issues, testing, etc.)
- **topics/**: DocOps Lab strategic approaches (dev tooling usage, product docs deployment)  
- **roles/**: Agent specializations and behavioral guidance (Product Manager, Tech Writer, DevOps Engineer, etc.)
- **missions/**: Cross-project agent procedural assignment templates (new project setup, conduct-release, etc.)

**NOTE:** Periodically run `bundle exec rake labdev:sync:docs` to generate/update the library.

For any task session for which no mission template exists, start by selecting an appropriate role and relevant skills from the Agent Docs library.

**Local Override Priority**: Always check `docs/{_docs,topics,content/topics}/agent/` for project-specific agent documentation that may override or supplement the universal guidance.

### Ephemeral/Scratch Directory

There should always be an untracked `.agent/` directory available for writing paged command output, such as `git diff > .agent/tmp/current.diff && cat .agent/tmp/current.diff`.
Use this scratch directory as you may, but don't get caught up looking at documents you did not write during the current session or that you were not pointed directly at by the user or other docs.

Typical subdirectories include:

- `docs/`: Generated agent documentation library (skills, roles, topics, missions)
- `tmp/`: Scratch files for current session
- `logs/`: Persistent logs across sessions (e.g., task run history)
- `reports/`: Persistent reports across sessions (e.g., spellcheck reports)
- `team/`: Shared (Git-tracked) files for multi-agent/multi-operator collaboration

### AsciiDoc, not Markdown

DocOps Lab is an **AsciiDoc** shop.
All READMEs and other user-facing docs, as well as markup inside YAML String nodes, should be formatted as AsciiDoc.

Agents have a frustrating tendency to create `.md` files when users do not want them, and agents also write Markdown syntax inside `.adoc` files.
Stick to the AsciiDoc syntax and styles you find in the `README.adoc` files, and you won't go too far wrong.

ONLY create `.md` files for your own use, unless Operator asks you to.

<!-- end::universal-agency[] -->


## Essential Reading Order (Start Here!)

Before making any changes, **read these documents in order**:

### 1. Core Documentation
- **`./README.adoc`**
- Main project overview, features, and workflow examples:
  - Pay special attention to the Config-Payload Coordination section
  - Study the test command examples and directory standards
- Review `Gemfile` and `dev-install.sh` for dependencies and environment context

### 2. Architecture Understanding
- **`API-CLIENT-TESTING-PLAN.adoc`**
- Test framework and validation patterns:
  - Understand the API client testing strategy
  - See how integration testing works with mock data
  - Note the current test coverage and planned expansions

### 3. Practical Examples
- `_configs/` directory contains various configuration examples
- `_payloads/` directory contains mock API response data

### 4. Development Standards
- Ruby style guidelines (parentheses usage, etc.)
- AsciiDoc for ALL documentation (not Markdown)
- Test-driven development with mock data


## Codebase Architecture

### Core Components

```
.
├── _configs/                   # Sample ReleaseHx configurations
├── _payloads/                # Mock API response JSON files (tracked)
├── _templates_/              # Custom template overrides (inactive)
├── _apis_/                   # Custom API client overrides (inactive)
├── _mappings_/              # Custom API mapping overrides (inactive)
├── __output/                  # Demo output (gitignored)
│   ├── drafts/                # YAML, Markdown, AsciiDoc
│   └── publish/               # HTML, PDF
├── __tests/                   # Test output (gitignored)
│   ├── cli/                   # CLI workflow test results
│   ├── readme/                # README command test results
│   │   ├── drafts/
│   │   └── publish/
│   ├── dynamic/               # Matrix generation test results
│   │   ├── github-basic/
│   │   ├── jira-description/
│   │   └── ...
│   └── validation/            # Content validation results
└── artifacts/                 # Version snapshots (gitignored)
    ├── rhx-0.1/               # ReleaseHx 0.1.x outputs
    └── rhx-latest/            # Current version showcase
```


### Data Flow Understanding

1. **Configuration Loading**
   - User provides config file (`_configs/*.yml`)
   - Config defines types, parts, and tag mappings

2. **API Data Processing**
   - Mock API data from `_payloads/` simulates real responses
   - Mapping files in `_mappings_/` extract relevant fields

3. **Output Generation**
   - Demo files (for users) in `__output/{drafts,publish}/`
   - Test results (for validation) in `__tests/{cli,readme,dynamic,validation}/`
   - Frozen artifacts (for showcase) in `artifacts/rhx-{version}/`

### Configuration System

- **Default values:** Defined in each config file in `_configs/`
- **User overrides:** Via `--config` flag in CLI
- **API mappings:** In `_mappings_/` directory
- **Output paths:** Follow directory standards in README


<!-- tag::universal-approach -->

## Agent Development Approach

**Before starting development work:**

1. **Adopt an Agent Role:** If the Operator has not assigned you a role, review `.agent/docs/roles/` and select the most appropriate role for your task.
2. **Gather Relevant Skills:** Examine `.agent/docs/skills/` for techniques needed:
3. **Understand Strategic Context:** Check `.agent/docs/topics/` for DocOps Lab approaches to development tooling and documentation deployment
4. **Read relevant project documentation** for the area you're changing
5. **For substantial changes, check in with the Operator** - lay out your plan and get approval for risky, innovative, or complex modifications

<!-- end::universal-approach[] -->

### Development Setup Requirements

**IMPORTANT**: Local development requires:

   1. ReleaseHx repository at `../releasehx/` - this is required by `dev-install.sh` for building and installing the latest version
      - If no Git repo at `../releasehx/`, `git clone git@github.com:DocOps/releasehx.git ../releasehx`
   2. Ruby 3.x environment
   3. Running `./dev-install.sh` before any development or testing work

### Development Patterns

#### 1. Configuration Changes
- Study existing configs in `_configs/` directory
- Update corresponding API mappings if needed
- Test with appropriate mock data

#### 2. CLI Changes
- Follow patterns in existing commands
- Use proper output directories:
  - `__output/drafts/` and `__output/publish/` for demos
  - `__tests/{type}/` for test outputs
  - `artifacts/rhx-{version}/` for frozen snapshots
- Include validation steps

#### 3. Testing Changes
- Use mock data from `_payloads/`
- Consider Rake task integration

### Testing Strategy

This repo uses an unusual testing strategy.
Thoroughly review the "Testing Methodology" section in `README.adoc` and `API-CLIENT-TESTING-PLAN.adoc` when performing thorough or modified tests.

### Common Development Scenarios

### Adding a New Config-Payload Pair

1. **Study existing pairs** in `_configs/` and `_payloads/`
2. **Create config file** in `_configs/`
3. **Add mock data** to `_payloads/`
4. **Add mapping** if needed in `_mappings_/`
5. **Test the combination** using standard commands
6. **Document in README** under verified pairs

### Modifying Test Suite

1. **Locate relevant tests** in `Rakefile`
2. **Update or add tests** as needed
3. **Run test suite:** `bundle exec rake test`

### Working with Artifacts

1. **Clean environment:** `bundle exec rake clean`
2. **Generate artifacts:** `bundle exec rake generate_artifacts`
3. **Create version branch:** `bundle exec rake generate_release`
4. **Create latest branch:** `bundle exec rake generate_latest_release`


## Debugging and Investigation Tools

### Understanding Current State

Refer to the Basic Demo Commands section in `README.adoc` for validated example commands.
The README contains explicitly testable commands (marked with `[.testable]`) that are verified
by the test suite.

### Key Files for Understanding
- `README.adoc` - Main documentation and examples
- `Rakefile` - Build and test automation
- `tests/` - Test implementation
- `_configs/` - Configuration examples
- `_payloads/` - Mock API data


## Working with Demo Data

The repository uses mock API data in `_payloads/` to demonstrate and test ReleaseHx functionality:

1. **GitHub Issues:** `github-*.json`
   - Basic issue data
   - Label-based categorization
   - Type and component examples

2. **Jira Issues:** `jira-*.json`
   - Custom field examples
   - Component-based organization
   - Description field parsing

3. **GitLab Issues:** `gitlab-*.json`
   - Label-based organization
   - Milestone integration
   - State transitions


<!-- tag::universal-responsibilities[] -->

## General Agent Responsibilities

1. **Question Requirements:** Ask clarifying questions about specifications.
2. **Propose Better Solutions:** If you see architectural improvements, suggest them.  
3. **Consider Edge Cases:** Think about error conditions and unusual inputs.
4. **Maintain Backward Compatibility:** Don't break existing workflows.
5. **Improve Documentation:** Update docs when adding features.
6. **Test Thoroughly:** Use both unit tests and demo validation.
7. **DO NOT assume you know the solution** to anything big.

### Cross-role Advisories

During planning stages, be opinionated about:

- Code architecture and separation of concerns
- User experience, especially:
   - CLI ergonomics
   - Error handling and messaging
   - Configuration usability
   - Logging and debug output
- Documentation quality and completeness
- Test coverage and quality

When troubleshooting or planning, be inquisitive about:

- Why existing patterns were chosen
- Future proofing and scalability
- What the user experience implications are
- How changes affect different API platforms
- Whether configuration is flexible enough
- What edge cases might exist

<!-- end::universal-responsibilities[] -->


## Remember

ReleaseHx Demo serves as both a testing suite and demonstration environment for the ReleaseHx tool. Its purpose is to help users understand and validate ReleaseHx functionality while providing a comprehensive test environment for development.

<!-- tag::universal-remember[] -->

Your primary mission is to improve ReleaseHx Demo while maintaining operational standards:

1. **Reliability:** Don't break existing functionality
2. **Usability:** Make interfaces intuitive and helpful
3. **Flexibility:** Support diverse team workflows and preferences  
4. **Performance:** Respect system limits and optimize intelligently
5. **Documentation:** Keep the docs current and comprehensive

**Most importantly**: Read the documentation first, understand the system, then propose thoughtful solutions that improve the overall architecture and user experience.

<!-- end::universal-remember[] -->
