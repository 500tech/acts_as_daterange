require 'spec_helper'
describe Daterange do
    before do 
      setup
    end

  describe 'default daterange' do
    it 'validates daterange' do
      expect { TestDefaultDaterange.create!(title: "That Time-Turner, it was driving me mad. I've handed it in", start_date: Time.now + 2.day, end_date: Time.now + 1.days) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    describe '.expire' do
      let(:record) { TestDefaultDaterange.create!(title: 'right now!', start_date: Time.now - 100.day, end_date: Time.now + 100.days) }
      it "expires record" do
        expect(record).to be_active_now
        record.expire
        expect(record).to_not be_active_now
      end

      it "doesn't commit the update" do
        expect(record).to be_active_now
        record.expire
        record.reload
        expect(record).to be_active_now
      end
    end
    describe '.expire!' do
      let(:record) { TestDefaultDaterange.create!(title: 'right now!', start_date: Time.now - 100.day, end_date: Time.now + 100.days) }
      it "commits the expiration" do
        expect(record).to be_active_now
        record.expire!
        expect(record).to_not be_active_now
        record.reload
        expect(record).to_not be_active_now
      end
    end

    context "future daterange" do
      before do 
        TestDefaultDaterange.create!(title: 'future', start_date: Time.now + 1.day, end_date: Time.now + 2.days)
      end
      let(:future_daterange) { TestDefaultDaterange.first }
      it "isn't .active_now?" do 
        expect(future_daterange).to_not be_active_now
      end
      it "is #inactive_now" do
        expect(TestDefaultDaterange.inactive_now.count).to eq 1
      end
      it "isn't #active_now" do
        expect(TestDefaultDaterange.active_now).to be_empty
      end
      it "isn't #inactive_at tomorrow" do
        expect(TestDefaultDaterange.inactive_at(Time.now + 1.day)).to be_empty
      end
      it "is #active_at tomorrow" do
        expect(TestDefaultDaterange.active_at(Time.now + 1.day).count).to eq 1
      end
    end

    context "active daterange" do
      before do
        TestDefaultDaterange.create!(title: 'right now!', start_date: Time.now - 100.day, end_date: Time.now + 100.days)
      end
      let(:active_daterange) { TestDefaultDaterange.first }
      it "is .active_now?" do 
        expect(active_daterange).to be_active_now
      end
      it "is #active_now" do
        expect(TestDefaultDaterange.active_now.count).to eq 1
      end
      it "isn't #inactive_now" do
        expect(TestDefaultDaterange.inactive_now).to be_empty
      end
      it "is #inactive_at tomorrow" do
        expect(TestDefaultDaterange.inactive_at(Time.now + 200.day).count).to eq 1
      end
      it "isn't #active_at tomorrow" do
        expect(TestDefaultDaterange.active_at(Time.now + 200.day)).to be_empty
      end
    end

    context "expired daterange" do
      before do
        TestDefaultDaterange.create!(title: 'old news buddy!', start_date: Time.now - 100.day, end_date: Time.now - 99.days)
      end
      it "is #inactive_now" do
        expect(TestDefaultDaterange.inactive_now.count).to eq 1
      end
      it "isn't #active_now" do
        expect(TestDefaultDaterange.active_now).to be_empty
      end
    end
  end

  describe 'custom daterange' do
    it 'has active items' do
      TestCustomDaterange.create!(title: "i'm special me", promotion_start: Time.now - 2.day, promotion_expire: Time.now + 9.days)
      expect(TestCustomDaterange.active_now.count).to eq 1
      expect(TestCustomDaterange.inactive_now.count).to eq 0
    end
    it 'has inactive items' do
      TestCustomDaterange.create!(title: "i'm special me", promotion_start: Time.now - 12.day, promotion_expire: Time.now - 9.days)
      expect(TestCustomDaterange.active_now.count).to eq 0
      expect(TestCustomDaterange.inactive_now.count).to eq 1
    end
    it 'validates daterange' do
      expect { TestCustomDaterange.create!(title: "That Time-Turner, it was driving me mad. I've handed it in", promotion_start: Time.now + 2.day, promotion_expire: Time.now + 1.days) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end


