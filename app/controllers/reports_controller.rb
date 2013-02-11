class ReportsController < ApplicationController
  def top_urls
    @urls = Dataset.top_urls
    render json: JSON.pretty_generate(@urls)
  end

  def top_referrers
    @referrers = Dataset.top_referrers
    render json: JSON.pretty_generate(@referrers)
  end
end
