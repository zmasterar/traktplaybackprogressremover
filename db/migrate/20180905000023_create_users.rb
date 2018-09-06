class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :user_uuid
      t.string :trakt_token

      t.timestamps
    end
  end
end
