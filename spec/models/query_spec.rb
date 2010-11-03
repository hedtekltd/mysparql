require 'spec_helper'
require 'uri'

describe Query do
  it {should validate_presence_of :source}
  it {should validate_presence_of :query}

  context "running a query" do
    before(:each) do
      @query = Query.new(:source => "http://www.example.com/sparql", :query => "SELECT * WHERE { ?s ?p ?o }")

      @xml_string = <<XML
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
  </results>
</sparql>
XML

      stub_request(:any, /^http:\/\/www\.example\.com\/sparql.*$/).to_return(:body => @xml_string)   
    end

    it "should execute the query on the data source" do
      @query.run
      a_request(:any, @query.source).with(:query => {"query" => @query.query}).should have_been_made
    end
  end
end
