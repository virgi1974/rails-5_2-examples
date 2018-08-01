class CreateHacker < ActiveRecord::Migration[5.2]
  def change
    create_table :hackers do |t|
    	t.string :email
    	t.string :password
    	t.datetime :confirmed_at

    	t.timestamps
    end
  end
end
