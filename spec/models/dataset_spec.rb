require 'spec_helper'

describe 'Dataset' do
  before(:each) do
    Dataset.insert(id: 1, url: 'http://apple.com', referrer: 'http://apple.com', created_at: Date.civil(2013, 1, 1))
    Dataset.insert(id: 2, url: 'https://apple.com', referrer: 'https://apple.com', created_at: Date.civil(2013, 1, 2))
  end

  it 'should return count of a url from the same date' do
    expect(Dataset.count_by_date.all[0][:count]).to eq(1)
    Dataset.insert(url: 'http://apple.com', created_at: Date.civil(2013, 1, 1))
    expect(Dataset.count_by_date.all[0][:count]).to eq(2)
    Dataset.insert(url: 'http://apple.com', created_at: Date.civil(2013, 1, 2))
    expect(Dataset.count_by_date.all[0][:count]).to eq(2)
  end

  it 'should return count of a specified url from the same date' do
    expect(Dataset.count_by_date_for_url('http://apple.com').all[0][:count]).to eq(1)
    Dataset.insert(url: 'http://apple.com', created_at: Date.civil(2013, 1, 1))
    expect(Dataset.count_by_date_for_url('http://apple.com').all[0][:count]).to eq(2)
  end

  it 'should return distinct urls' do
    expect(Dataset.distinct_urls.count).to eq(2)
    Dataset.insert(url: 'http://www.apple.com')
    expect(Dataset.distinct_urls.count).to eq(3)
    Dataset.insert(url: 'http://www.apple.com')
    expect(Dataset.distinct_urls.count).to eq(3)
  end

  it 'should return distinct referrers' do
    expect(Dataset.distinct_referrers.count).to eq(2)
    Dataset.insert(referrer: 'http://developer.apple.com')
    expect(Dataset.distinct_referrers.count).to eq(3)
    Dataset.insert(referrer: 'http://developer.apple.com')
    expect(Dataset.distinct_referrers.count).to eq(3)
  end
end