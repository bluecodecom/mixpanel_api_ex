use Mix.Config

if Mix.env() == :test do
  config :mixpanel_api_ex, :mixpanel,
    active: true,
    token: "",
    max_idle: 75,
    batch_size: 3,
    max_queue_track: 5,
    max_queue_engage: 5
end
