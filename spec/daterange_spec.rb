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
        expect(record).to be_active
        record.expire
        expect(record).to_not be_active
      end

      it "doesn't commit the update" do
        expect(record).to be_active
        record.expire
        record.reload
        expect(record).to be_active
      end
    end
    describe '.expire!' do
      let(:record) { TestDefaultDaterange.create!(title: 'right now!', start_date: Time.now - 100.day, end_date: Time.now + 100.days) }
      it "commits the expiration" do
        expect(record).to be_active
        record.expire!
        expect(record).to_not be_active
        record.reload
        expect(record).to_not be_active
      end
    end

    context "future daterange" do
      before do 
        TestDefaultDaterange.create!(title: 'future', start_date: Time.now + 1.day, end_date: Time.now + 2.days)
      end
      let(:future_daterange) { TestDefaultDaterange.first }
      it "isn't .active?" do 
        expect(future_daterange).to_not be_active
      end
      it "is #inactive" do
        expect(TestDefaultDaterange.inactive.count).to eq 1
      end
      it "isn't #active" do
        expect(TestDefaultDaterange.active).to be_empty
      end
    end

    context "active daterange" do
      before do
        TestDefaultDaterange.create!(title: 'right now!', start_date: Time.now - 100.day, end_date: Time.now + 100.days)
      end
      let(:active_daterange) { TestDefaultDaterange.first }
      it "is .active?" do 
        expect(active_daterange).to be_active
      end
      it "is #active" do
        expect(TestDefaultDaterange.active.count).to eq 1
      end
      it "isn't #inactive" do
        expect(TestDefaultDaterange.inactive).to be_empty
      end
    end

    context "expired daterange" do
      before do
        TestDefaultDaterange.create!(title: 'old news buddy!', start_date: Time.now - 100.day, end_date: Time.now - 99.days)
      end
      it "is #inactive" do
        expect(TestDefaultDaterange.inactive.count).to eq 1
      end
      it "isn't #active" do
        expect(TestDefaultDaterange.active).to be_empty
      end
    end
  end

  describe 'custom daterange' do
    it 'has active items' do
      TestCustomDaterange.create!(title: "i'm special me", promotion_start: Time.now - 2.day, promotion_expire: Time.now + 9.days)
      expect(TestCustomDaterange.active.count).to eq 1
      expect(TestCustomDaterange.inactive.count).to eq 0
    end
    it 'has inactive items' do
      TestCustomDaterange.create!(title: "i'm special me", promotion_start: Time.now - 12.day, promotion_expire: Time.now - 9.days)
      expect(TestCustomDaterange.active.count).to eq 0
      expect(TestCustomDaterange.inactive.count).to eq 1
    end
    it 'validates daterange' do
      expect { TestCustomDaterange.create!(title: "That Time-Turner, it was driving me mad. I've handed it in", promotion_start: Time.now + 2.day, promotion_expire: Time.now + 1.days) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end


