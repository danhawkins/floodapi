Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  mount API => '/'
  get '/api_docs', to: 'api_docs#index'
  get '/', to: redirect('/api_docs'), as: :root
end
