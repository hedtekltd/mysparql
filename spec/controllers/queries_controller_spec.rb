require 'spec_helper'

describe V1::QueriesController do
  context "creating a query" do
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
    
      it 'should give a status of 400 BAD REQUEST' do
        exercise
        response.status.should == 400
      end
    end
  end

  context "running a query" do
    before(:each) do
      Query.stub!(:find).and_return(@query = mock_model(Query))
      @query.stub!(:run).and_return(@results = {"variables" => ["s", "p", "o"], "results" => [{"s" => "blah", "p" => "test", "o" => "object"}]})
    end

    def exercise
      get :show, :id => @query.id
    end

    it "should find the query" do
      Query.should_receive(:find).with(@query.id)
      exercise
    end

    it "should run the query" do
      @query.should_receive(:run)
      exercise
    end

    it "should return the query results in JSON" do
      exercise
      response.body.should == @results.to_json
    end
  end
end
