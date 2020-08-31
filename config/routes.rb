require 'sidekiq/web'
require 'sidekiq-scheduler/web'
Rails.application.routes.draw do
  get 'import/do'
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'import', to: 'import#do'
  post 'import', to: 'import#import'
  get 'map', to: 'monuments#map'
  
  get 'monuments', to: 'monuments#index'
  get 'address', to: 'monuments#address'
  get 'show', to: 'monuments#show'
  get 'namesearch', to: 'monuments#namesearch'

  # numerics stat

    get 'nophoto', to: 'numerics#nophoto'
    get 'nophotograph', to: 'numerics#nophotograph'
  
    # concorsi-locali stat
    get 'allregionscount', to: 'numerics#allregionscount'
    get 'allregionsdifference', to: 'numerics#allregionsdifference'

      mount Sidekiq::Web => '/secret-sidekiq'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
