require 'rails_helper'

RSpec.describe SendFromTheBridgeNewsletterJob, type: :job do

 #  before do
 #    ActionMailer::Base.deliveries.clear
 #  end

 #  after do
 #    ActionMailer::Base.deliveries.clear
 #  end

 # context "with small number of users better only one queue for all users-emails" do
 #    it "sends newsletters to all hackers (aka users)" do
 #      hackers = FactoryBot.create_list(:hacker, 5)
 #      SendFromTheBridgeNewsletterJob.perform_now(hackers)
 # Works only if perform action uses deliver_now
 #      expect(ActionMailer::Base.deliveries.count).to eq(5)
 #    end
 #  end

 context "with big number of users better one queue by user-email pair " do
  before do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

 context "with small number of users" do
      it "sends newsletters to all hackers (aka users)" do
        hackers = FactoryBot.create_list(:hacker, 5)
        SendFromTheBridgeNewsletterJob.perform_now(hackers)
        # Works only if perform action uses deliver_later 
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq(5)
      end
    end
  end

end