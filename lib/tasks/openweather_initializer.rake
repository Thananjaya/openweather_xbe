namespace :openweather do
  desc 'Initializing application via rake database booting script'
  task initialize: [
  	'db:drop',
  	'db:create',
  	'db:migrate'
  ]
end