When /^I POST the query "([^"]*)" and source "([^"]*)"$/ do |query, source|
  post "/v1/queries", :query => {:query => query, :source => source}
end

Then /^I should get a MySparql JSON encoded URI as a response$/ do
  response.should be_success
  response.content_type.should == "application/json"
  response.body.should match(/^{"uri":"http:\/\/www.example.com\/v1\/queries\/[0-9a-z]*"}$/)
end

When /^I POST the query "([^"]*)" with no source$/ do |query|
  post "/v1/queries", :query => {:query => query}
end

Then /^I should get a JSON error "([^"]*)"$/ do |error|
  response.should_not be_success
  response.content_type.should == "application/json"
  response.body.should match(/^{"error":"#{error}"}$/)
end
