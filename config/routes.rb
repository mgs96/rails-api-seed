Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'# , controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, defaults: { format: :json }

  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/failure', to: redirect('/')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :products
    end
  end

  namespace :ionic do
    post 'google_auth', to: 'users#validate_token'
  end
end
