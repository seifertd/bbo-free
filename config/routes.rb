Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "/tournaments", to: "tournaments#create"
  get "/tournaments/:id", to: "tournaments#show", as: 'tournament'
  get "/entries/:id", to: "entries#show", as: 'entry'
  # Defines the root path route ("/")
  root "tournaments#index"
end
