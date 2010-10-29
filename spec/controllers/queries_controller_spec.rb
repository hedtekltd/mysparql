require 'spec_helper'

describe V1::QueriesController do
  before(:each) do
    Query.stub!(:create!).and_return(@query = mock_model(Query, :save! => true))
    @query_details = {"query" => "SELECT * WHERE {?s ?p ?o}", "source" => "http://test.host/sparql"}
  end

  def exercise
    post :create, :query => @query_details
  end
  
  it 'should create the query' do
    Query.should_receive(:create!)
    exercise
  end
  
  context "Saves successfully" do
    it 'should render the query uri as json' do
      exercise
      response.body.should include("{\"uri\":\"#{v1_query_url(@query)}\"}")
    end
  end
  
  context "Save fails" do
    before(:each) do
      @query.stub!(:errors).and_return(ActiveModel::Errors.new(@query))
      @query.errors.add("source", "is missing")
      Query.stub!(:create!).and_raise(ActiveRecord::RecordInvalid.new(@query))
    end
    it 'should render an error message' do
      exercise
      response.body.should include("{\"error\":[\"Source is missing\"]}")    
    end
  end
end
