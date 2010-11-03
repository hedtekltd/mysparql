class V1::QueriesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @query = Query.create!(params[:query])
    render :json => {:uri => v1_query_url(@query)}
  rescue ActiveRecord::RecordInvalid => invalid
    render :json => {:error => invalid.record.errors.full_messages}, :status => 400
  end

  def show
    @query = Query.find(params[:id])
    @results = @query.run
    render :json => @results
  end
end
