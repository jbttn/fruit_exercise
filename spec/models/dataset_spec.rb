require 'spec_helper'

describe 'Dataset' do
  before(:each) do
    @date = Date.civil(2013, 1, 1)
    Dataset.insert(id: 1, url: 'http://apple.com', referrer: 'http://apple.com', created_at: @date)
    Dataset.insert(id: 2, url: 'https://apple.com', referrer: 'https://apple.com', created_at: @date + 1)
  end

  it 'should return count of a url from the same date' do
    expect(Dataset.count_by_date.all[0][:visits]).to eq(1)
    Dataset.insert(url: 'http://apple.com', created_at: @date)
    expect(Dataset.count_by_date.all[0][:visits]).to eq(2)
    Dataset.insert(url: 'http://apple.com', created_at: @date + 1)
    expect(Dataset.count_by_date.all[0][:visits]).to eq(2)
  end

  it 'should return count of a specified url from the same date' do
    expect(Dataset.count_by_date_for_url('http://apple.com').all[0][:visits]).to eq(1)
    Dataset.insert(url: 'http://apple.com', created_at: @date)
    expect(Dataset.count_by_date_for_url('http://apple.com').all[0][:visits]).to eq(2)
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

  it 'should return top urls for a date' do
    expect(Dataset.top_urls_on_date(@date).all[0][:visits]).to eq(1)
    Dataset.insert(url: 'http://apple.com', created_at: @date)
    expect(Dataset.top_urls_on_date(@date).all[0][:visits]).to eq(2)
    Dataset.insert(url: 'https://apple.com', created_at: @date)
    expect(Dataset.top_urls_on_date(@date).all[1][:visits]).to eq(1)
  end
end