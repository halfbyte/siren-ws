require 'rubygems'
require 'sinatra'
require 'haml'
require 'socket'

PORT = 12358
HOST = 'localhorst'

set :views, File.dirname(__FILE__) + '/templates'
set :haml, {:format => :html5 }

get '/' do
  haml :index
end

get '/:color' do |color|
  @color = color
  haml :siren
end

post '/:color' do |color|
  content_type "text/plain"
  send_command(color, params[:style], params[:count])
end

def send_command(color, style='blink', count = 3)
  if count.to_i > 0 && count.to_i <= 10 && ["blink", "alert"].include?(style.downcase) && ["red", "blue"].include?(color.downcase)
    command = "#{style.upcase} #{color.upcase} #{count}"
    socket = TCPSocket.new(HOST, PORT)
      socket.puts command
    return "OK: #{command}"
  else
    raise "Illegal command."
  end
rescue => e
  return "FAIL: #{e}"  
end