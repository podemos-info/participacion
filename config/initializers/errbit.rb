Airbrake.configure do |config|
  config.api_key = '15a804bb0ef60a0d7ddd250cdb8967e2'
  config.host    = 'errbit.podemos.info'
  config.port    = 443
  config.secure  = config.port == 443
end
