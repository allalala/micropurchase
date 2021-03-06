require 'rails_helper'

RSpec.describe PlaceBid do
  let(:place_bid) { PlaceBid.new(params, current_user) }
  let(:current_user) { double('bidder', id: 111) }
  let(:amount) { 1005 }
  let(:params) {
    {
      auction_id: auction_id,
      bid: {
        amount: amount
      }
    }
  }
  let(:auction_id) { auction.id }

  context 'when auction cannot be found' do
    let(:auction) { double('auction', id: 1000) }

    it 'should raise a not found' do
      expect {
        place_bid.perform
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the auction has expired' do
    let(:auction) { Auction.create(start_datetime: Time.now - 5.days, end_datetime: Time.now - 3.day) }

    it 'should raise an authorization error (because we have that baked in)' do
      expect {
        place_bid.perform
      }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the auction has not started yet' do
    let(:auction) { Auction.create(start_datetime: Time.now + 5.days, end_datetime: Time.now + 7.days) }

    it 'should raise an authorization error (same as above)' do
      expect {
        place_bid.perform
      }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is in increments small than one dollar' do
    let(:auction) {
      Auction.create({
        start_datetime: Time.now - 3.days,
        end_datetime: Time.now + 7.days
      })
    }
    let(:amount) {1000.99}
    it 'should raise an authorization error' do
      expect {
        place_bid.perform
      }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is too high' do
    let(:auction) {
      Auction.create({
        start_datetime: Time.now - 3.days,
        end_datetime: Time.now + 7.days
      })
    }
    let(:amount) { 3600 }

    it 'should raise an authorization error' do
      expect {
        place_bid.perform
      }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is too low' do
    let(:auction) {
      Auction.create({
        start_datetime: Time.now - 3.days,
        end_datetime: Time.now + 7.days
      })
    }
    let(:amount) { 0 }

    it 'should raise an authorization error' do
      expect {
        place_bid.perform
      }.to raise_error(UnauthorizedError)
    end
  end

  context 'when all the data is great' do
    let(:auction) {
      Auction.create({
        start_datetime: Time.now - 3.days,
        end_datetime: Time.now + 7.days
      })
    }

    let(:bid) { place_bid.bid }

    it 'creates a bid' do
      expect {
        place_bid.perform
      }.to change { Bid.count }.by(1)
      expect(bid.auction_id).to eq(auction.id)
      expect(bid.bidder_id).to eq(current_user.id)
    end

    it 'rounds the amount to two decimal places' do
      place_bid.perform
      bid.reload
      expect(bid.amount).to eq(1005)
    end
  end
end
