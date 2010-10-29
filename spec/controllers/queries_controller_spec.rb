require 'spec_helper'

describe V1::QueriesController do
  before(:each) do
    Query.stub(:new).and_return(@query = mock_model(Query, :save! => true))
    @query_details = {"query" => "SELECT * WHERE {?s ?p ?o}", "source" => "http://test.host/sparql"}
  end

  def exercise
    post :create, :query => @query_details
  end

  it 'should create a new query with the query details' do
    Query.should_receive(:new).with(@query_details)
    exercise
  end

  it 'should render the query uri as json' do
    exercise
    response.body.should include("{\"uri\":\"#{v1_query_url(@query)}\"}")
  end

  it 'should save the query' do
    @query.should_receive(:save!)
    exercise
  end
end
