require "net/http"
require "uri"

if Rails.env.production?
  Thread.new do
    loop do
      sleep 10.minutes
      begin
        # Pega a URL do ambiente ou usa a URL fixa do Render
        host_url = ENV.fetch("HOST_URL", "https://resgateeadote.onrender.com")
        uri = URI("#{host_url}/ping")
        Net::HTTP.get_response(uri)
        Rails.logger.info "Ping interno executado com sucesso para evitar hibernação."
      rescue => e
        Rails.logger.error "Erro no ping interno: #{e.message}"
      end
    end
  end
end
