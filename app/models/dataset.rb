class Dataset < Sequel::Model
  subset(:recent){created_at > Date.today - 5}
  
  self.dataset_module do
    def count_by_date
      select_group(Sequel.cast(:created_at, :date).as(:date))
      .select_more{count(:created_at).as(:visits)}
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

    def top_urls_on_date(date = '1970-01-01')
      select_group(:url)
      .select_more{count(:url).as(:visits)}
      .where(Sequel.cast(:created_at, :date) => date)
      .reverse_order(:visits)
    end

    def top_referrers_for_url_on_date(url = nil, date = '1970-01-01')
      select_group(:referrer)
      .select_more{count(:url).as(:visits)}
      .where(Sequel.cast(:created_at, :date) => date, url: url)
      .reverse_order(:visits)
    end
  end

  # Generate the payload for the top_urls path
  def self.top_urls(number_of_days = 5)
    iterate_days(number_of_days) {|hash, date|
      Dataset.recent.top_urls_on_date(date).each do |url|
        hash[date] << url.to_hash
      end
    }
  end

  # Generate the payload for the top_referrers path
  def self.top_referrers(number_of_days = 5, number_of_urls = 10, number_of_referrers = 5)
    iterate_days(number_of_days) {|hash, date|
      Dataset.recent.top_urls_on_date(date).limit(number_of_urls).each do |url|
        hash[date] << url.to_hash
        hash[date].last[:referrers] = []
        Dataset.recent.top_referrers_for_url_on_date(url[:url], date).limit(number_of_referrers).each do |referrer|
          # Match the example payload
          hash[date].last[:referrers] << {url: referrer[:referrer], visits: referrer[:visits]}
        end
      end
    }
  end

private
  
  # DRY up #top_urls and #top_referrers
  def self.iterate_days(number_of_days = 5)
    hash = {}
    number_of_days.times do |current_day|
      date = current_day.days.ago.to_date
      hash[date] = []
      yield hash, date if block_given?
    end
    hash
  end
end