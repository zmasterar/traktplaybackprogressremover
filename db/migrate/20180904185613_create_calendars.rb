class CreateCalendars < ActiveRecord::Migration[5.0]
  def change
    create_table :calendars do |t|
      t.string :user_slug
      t.string :user_uuid
      t.text :events

      t.timestamps
    end
  end
end
