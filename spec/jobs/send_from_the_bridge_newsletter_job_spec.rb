require 'rails_helper'

RSpec.describe SendFromTheBridgeNewsletterJob, type: :job do

	before do
		ActionMailer::Base.deliveries.clear
	end

	after do
		ActionMailer::Base.deliveries.clear
	end

	context "with small number of users" do
		it "sends newsletters to all hackers (aka users)" do
			hackers = FactoryBot.create_list(:hacker, 5)
			SendFromTheBridgeNewsletterJob.perform_now(hackers)
			expect(ActionMailer::Base.deliveries.count).to eq(5)
		end
	end

end