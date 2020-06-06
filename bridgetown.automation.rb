# frozen_string_literal: true

# Add this here due to a testing issue
require 'fileutils'
require 'shellwords'

# Dynamically determined due to having to load from the tempdir
@current_dir = File.expand_path(__dir__)

# If its a remote file, the branch is appended to the end, so go up a level
# IE: https://blah-blah-blah/bridgetown-plugin-tailwindcss/master
ROOT_PATH = if __FILE__ =~ %r{\Ahttps?://}
              File.expand_path('../', __dir__)
            else
              File.expand_path(__dir__)
            end

DIR_NAME = File.basename(ROOT_PATH)

GITHUB_PATH = "https://github.com/ParamagicDev/#{DIR_NAME}.git"

def determine_template_dir(current_dir = @current_dir)
  File.join(current_dir, 'templates')
end

def require_files(tmpdir = nil)
  files = Dir.glob('lib/**/*')

  return if files.empty?

  return files.each { |file| require File.expand_path(file) } if tmpdir.nil?

  files.each { |file| require File.join(tmpdir, File.expand_path(file)) }
end

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'

    source_paths.unshift(tempdir = Dir.mktmpdir(DIR_NAME + '-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    run("git clone --quiet #{GITHUB_PATH.shellescape} #{tempdir.shellescape}")

    if (branch = __FILE__[%r{#{DIR_NAME}/(.+)/bridgetown.automation.rb}, 1])
      Dir.chdir(tempdir) { system("git checkout #{branch}") }
      require_files(tempdir)
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(DIR_NAME)
    require_files
  end
end

def add_yarn_packages
  packages = 'cypress start-server-and-test'
  say "Adding the following yarn packages: #{packages}", :green
  system("yarn add -D #{packages}")
end

def read_template_file(filename)
  File.read(File.join(determine_template_dir, filename))
end

def add_cypress_json
  cypress_json = 'cypress.json'
  create_file(cypress_json, read_template_file(cypress_json))
end

def add_cypress_scripts
  cypress_scripts = read_template_file('cypress_scripts')
  package_json = 'package.json'

  script_regex = /"scripts": {(\s+".*,?)*/

  inject_into_file(package_json, ",\n" + cypress_scripts, after: script_regex)
end

add_template_repository_to_source_path
add_cypress_scripts
add_yarn_packages
