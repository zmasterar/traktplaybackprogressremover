Rails.application.routes.draw do
  root 'trakt#home'
  get 'authorize', to: "trakt#authorize", as: "authorize"
  get 'token', to: "trakt#get_token", as: "get_token"
  delete 'token', to: "trakt#delete_token", as: "delete_token"
  get 'watchlist', to: "trakt#watchlist", as: "watchlist"
  get 'playback', to: "trakt#playback", as: "playback"
  post 'playback', to: "trakt#delete_playback", as: "delete_playback"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
