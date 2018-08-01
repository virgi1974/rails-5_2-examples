namespace :newsletters do
  desc "TODO"
  task from_the_bridge: :environment do
  	SendFromTheBridgeNewsletterJob.perform_later
  end

end
