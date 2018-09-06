class AddUserIdToCalendars < ActiveRecord::Migration[5.0]
  def change
    add_column :calendars, :user_id, :integer
  end
end
