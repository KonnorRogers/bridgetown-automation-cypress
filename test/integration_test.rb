# frozen_string_literal: true

require 'test_helper'
require 'bundler'
require 'active_support'

CURRENT_BRIDGETOWN_VERSION = '~> 0.15.0.beta3'
BRANCH = `git branch --show-current`.freeze

class IntegrationTest < Minitest::Test
  def setup
    Rake.rm_rf(TEST_APP)
    Rake.mkdir_p(TEST_APP)
  end

  def read_test_file(filename)
    File.read(File.join(TEST_APP, filename))
  end

  def read_template_file(filename)
    File.read(File.join(TEMPLATES_DIR, filename))
  end

  def run_assertions
    cypress_json = 'cypress.json'
    test_cypress_json = read_test_file(cypress_json)
    template_cypress_json = read_template_file(cypress_json)

    assert_equal(test_cypress_json, template_cypress_json)

    package_json = 'package.json'
    test_package_json = read_test_file(package_json)

    cypress_scripts = 'cypress_scripts'
    template_cypress_scripts = read_template_file(cypress_scripts)

    assert(test_package_json.include?(template_cypress_scripts))
  end

  def test_it_works_with_local_automation
    Rake.cd TEST_APP

    Rake.sh("bridgetown new . --force --apply='../bridgetown.automation.rb'")

    run_assertions
  end

  # Have to push to github first, and wait for github to update
  def test_it_works_with_remote_automation
    Rake.cd TEST_APP
    Rake.sh('bridgetown new . --force')

    github_url = 'https://raw.githubusercontent.com'
    user_and_reponame = 'ParamagicDev/bridgetown-plugin-tailwindcss/tree/#{BRANCH}'

    file = 'bridgetown.automation.rb'

    url = "#{github_url}/#{user_and_reponame}/#{file}"

    Rake.sh("bridgetown apply #{url}")

    run_assertions
  end
end
