class SendFromTheBridgeNewsletterJob < ApplicationJob
  queue_as :default

  def perform(hackers)
  	hackers.each do |hacker|
  		FromTheBridgeMailer.send_newsletter(hacker).deliver_now
  	end
  end
end
