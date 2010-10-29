class V1::QueriesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    @query = Query.new(params[:query])
    @query.save!
    render :json => {:uri => v1_query_url(@query)}
  end

  def show

  end
end
