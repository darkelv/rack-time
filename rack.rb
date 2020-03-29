require 'rack'
require_relative 'time_stamp.rb'

class App
  def call(env)
    @env = env

    if valid_path?
      timestamp = TimeStamp.new(request.params["format"])

      if timestamp.has_invalid?
        rack_respone(:bad_request, "Формат веремни не отпределен [#{timestamp.invalid}]")
      else
        rack_respone(:ok, timestamp.format)
      end
    else
      rack_respone(:not_found, "Страница не найдена")
    end
  end

  private

  def rack_respone response_msg, body
    [
      Rack::Utils.status_code(response_msg),
      {"Content-Type" => "text/html"},
      [body]
    ]
  end

  def request
    @request = Rack::Request.new(@env)
  end

  def valid_path?
    request.path == '/time'
  end
end
