class SendFromTheBridgeNewsletterJob < ApplicationJob
  queue_as :default

  def perform(hackers)
  	hackers.each do |hacker|
  		# Delivers all emails enqueing only one queue 
  		# FromTheBridgeMailer.send_newsletter(hacker).deliver_now

  		# Delivers all emails enqueing one queue for each user 
  		FromTheBridgeMailer.send_newsletter(hacker).deliver_later
  	end
  end
end
