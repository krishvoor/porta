# frozen_string_literal: true

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'uri'
require 'cgi'

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given "(I )am on {link_to_page}" do |page_name|
  # TODO: move this into transformer
  path = PathsHelper::PathFinder.new(@provider).path_to(page_name)
  visit path
end

When "(I )go to {link_to_page}" do |page_name|
  # TODO: move this into transformer
  path = PathsHelper::PathFinder.new(@provider).path_to(page_name)
  visit path
end

Then /^(.*) within "([^"]*)"$/ do |action, selector|
  with_scope selector do
    step action
  end
end

When "(I )press {string}" do |button|
  click_button(button, visible: true)
end

When "(I )press invisible {string}" do |button|
  click_button(button, visible: false)
end

When "(I )follow invisible {string}" do |link|
  click_link(link, exact: true, visible: false)
end

When "(I )follow {string}" do |link|
  click_link(link, exact: true, visible: true)
end

When "(I )fill in {string} with {string}" do |field, value|
  fill_in(field, with: value, visible: true)
end

When "I fill in {string} with:" do |field, text|
  fill_in(field, with: text, visible: true)
end

When "(I )fill in {string} for {string}" do |value, field, selector|
  fill_in(field, with: value, visible: true)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select og option
# based on naming conventions.
#
When "(I )fill in the following:" do |fields|
  fields.rows_hash.each do |name, value|
    step %(I fill in "#{name}" with "#{value}")
  end
end

When "(I )select {string} from {string}" do |value, field|
  if page.has_css?('.pf-c-form__label', text: field)
    select = find('.pf-c-form__label', text: field).sibling('.pf-c-select')
    within select do
      find('.pf-c-select__toggle-button').click unless select['class'].include?('pf-m-expanded')
      click_on(value)
    end
  else
    # DEPRECATED: remove when all selects have been replaced for PF4
    ThreeScale::Deprecation.warn "[cucumber] Detected a form not using PF4 css"
    find_field(field).find(:option, value).select_option
  end
end

When "(I )select {string} from {string} within {string}" do |value, field, selector|
  with_scope(selector) do
    step %(I select "#{value}" from "#{field}")
  end
end

When "(I ){check} {string}" do |check, field|
  check ? check(field) : uncheck(field)
end

When "(I )attach the file {string} to {string}" do |path, field|
  attach_file(field, File.join(Rails.root,path))
end

Then "(I )should see JSON:" do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  assert_equal expected, actual
end

Then "(I )should see {string}" do |text|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  if page.respond_to? :should
    page.should have_content(:all, regex)
  else
    assert page.has_content?(:all, regex)
  end
end

Then "(I )should not see {string}" do |text|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  refute_text :visible, regex
end

Then "(I )should see {regexp}" do |regexp, selector|
  if page.respond_to? :should
    page.should have_xpath('//*', text: regexp)
  else
    assert page.has_xpath?('//*', text: regexp)
  end
end

Then "(I )should not see {regexp}" do |regexp|
  if page.respond_to? :should
    page.should have_no_xpath('//*', text: regexp)
  else
    assert page.has_no_xpath?('//*', text: regexp)
  end
end

Then "(I )should see {string} and {string}" do |text1, text2|
  steps %(
    And I should see "#{text1}"
    And I should see "#{text2}"
  )
end

Then "the {string} field within {string} should contain {string}" do |field, selector, value|
  step %(the "#{field}" field should contain "#{value}" within "#{selector}")
end

Then "the {string} field should contain {string}" do |field, value|
  field = find_field(field)
  field_value = field['value'] || field.native.attribute('value').to_s
  if field_value.respond_to? :should
    field_value.should =~ /#{value}/
  else
    assert_match(/#{value}/, field_value)
  end
end

Then "the {string} field within {string} should not contain {string}" do |field, selector, value|
  step %(the "#{field}" field should not contain "#{value}" within "#{selector}")
end

Then "the {string} checkbox within {string} {should} be checked" do |label, should, selector|
  step %(the "#{field}" checkbox should be #{should ? 'checked' : 'unchecked'} within "#{selector}")
end

Then "the {string} checkbox {should} be {checked}" do |label, should, checked|
  field_checked = find_field(label)['checked']
  expect(field_checked).to(should == checked ? be_truthy : be_falsy)
end

Then "(I )should be on {link_to_page}" do |page_name|
  # TODO: move this into transformer
  path = PathsHelper::PathFinder.new(@provider).path_to(page_name)
  assert_equal path, page.current_path
end

Then "(I )should have the following query string:" do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair {|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

When "(I )choose {string}" do |field|
  choose(field)
end

Then "show me the page" do
  save_and_open_page
end
