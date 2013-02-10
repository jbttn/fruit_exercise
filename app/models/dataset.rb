class Dataset < Sequel::Model
  subset(:recent){created_at > Date.today - 5}
  
  self.dataset_module do
    def count_by_date
      select_group(Sequel.cast(:created_at, :date).as(:date))
      .select_more{count(:created_at).as(:count)}
    end

    def count_by_date_for_url(url = nil)
      count_by_date.where(url: url)
    end

    def count_by_date_for_referrer(referrer = nil)
      count_by_date.where(url: url)
    end

    def distinct_urls
      select(:url).distinct(:url)
    end

    def distinct_referrers
      select(:referrer).distinct(:referrer)
    end
  end
end