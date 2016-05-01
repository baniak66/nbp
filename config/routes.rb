Tshtask::Application.routes.draw do
  root :to => "money#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users, except: [:show, :index]
  resources :money, except: [:delete, :edit, :update, :create, :new]
  get '/report', to: 'money#report', as: 'report'
  get '/refresh', to: 'money#refresh_rates', as: 'refresh'
end
