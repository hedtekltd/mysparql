Given /^there are no queries$/ do
  Query.delete_all
end

Given /^I have created a MySparql query of "([^"]*)" for data source "([^"]*)"$/ do |query, source|
  @query_response_xml = <<XML
<?xml version="1.0"?>
<sparql xmlns="http://www.w3.org/2005/sparql-results#">
  <head>
    <variable name="s"/>
    <variable name="p"/>
    <variable name="o"/>
  </head>
  <results>
    <result>
      <binding name="s"><uri>http://lod.fishbase.org/#FAMILIES/563</uri></binding>
      <binding name="p"><uri>http://192.168.1.6:8000/vocab/resource/FAMILIES_NorthSouthN</uri></binding>
      <binding name="o"><literal>n</literal></binding>
    </result>
  </results
</sparql>
XML

  @query_response_json = <<JSON
{"variables":["s","p","o"],"results":[{"s":"http://lod.fishbase.org/#FAMILIES/563","p":"http://192.168.1.6:8000/vocab/resource/FAMILIES_NorthSouthN","o":"n"}]}
JSON

  When "I POST the query \"#{query}\" and source \"#{source}\""
  stub_request(:any, /^http:\/\/www\.example\.com\/sparql.*$/).to_return(:body => @query_response_xml)
end

When /^I visit the latest MySparql query$/ do
  get v1_query_path(Query.last)
end

When /^I POST the query "([^"]*)" and source "([^"]*)"$/ do |query, source|
  post "/v1/queries", :query => {:query => query, :source => source}
end

When /^I POST the query "([^"]*)" with no source$/ do |query|
  post "/v1/queries", :query => {:query => query}
end

Then /^I should get a MySparql JSON encoded URI as a response$/ do
  response.should be_success
  response.content_type.should == "application/json"
  response.body.should match(/^{"uri":"http:\/\/www.example.com\/v1\/queries\/[0-9a-z]*"}$/)
end

Then /^I should get a JSON error "([^"]*)"$/ do |error|
  response.should_not be_success
  response.content_type.should == "application/json"
  response.body.should match(/^{"error":\["#{error}"\]}$/)
end

Then /^I should get the query results in JSON$/ do
  response.should be_success
  response.content_type.should == "application/json"
  response.body.should match(@query_response_json)
end
