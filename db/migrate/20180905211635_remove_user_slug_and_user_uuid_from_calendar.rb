class RemoveUserSlugAndUserUuidFromCalendar < ActiveRecord::Migration[5.0]
  def change
    remove_column :calendars, :user_slug, :string
    remove_column :calendars, :user_uuid, :string
  end
end
