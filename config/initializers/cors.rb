Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # Change this to your Expo LAN IP if needed
  
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
  