class AddTraktRefreshTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trakt_refresh_token, :string
  end
end
