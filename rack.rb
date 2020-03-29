require 'rack'
require_relative 'time_stamp.rb'

class App
  def call(env)
    @env = env

    if valid_path?
      timestamp = TimeStamp.new(request.params["format"])
      response(timestamp)
    else
      rack_response(404, "Страница не найдена")
    end
  end

  private

  def response timestamp
    if timestamp.has_invalid?
      rack_response(400, "Формат веремни не отпределен [#{timestamp.invalid}]")
    else
      rack_response(200, timestamp.format)
    end
  end

  def rack_response status, body
    [
      status,
      {"Content-Type" => "text/html"},
      [body]
    ]
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def valid_path?
    request.path == '/time'
  end
end
