Youtube::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "user" }

  root to: "analytics#index"

  devise_scope :user do
	  get '/users/sign_out' => 'devise/sessions#destroy'
	end

end
