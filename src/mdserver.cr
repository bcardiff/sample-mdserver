require "live_reload"
require "markd"
require "fswatch"

class MarkdownHandler
  include HTTP::Handler

  def initialize(@dir : Path)
  end

  def call(context)
    md_file = source(context.request.resource)

    if File.exists?(md_file)
      context.response.content_type = "text/html; charset=utf-8"
      context.response << %(<!DOCTYPE html><html><link rel="stylesheet" href="/styles.css"><body>)
      context.response << Markd.to_html(File.read(md_file))
      context.response << LiveReload::SCRIPT
      context.response << %(</body></html>)
    else
      call_next(context)
    end
  end

  def source(resource)
    return @dir / "index.md" if resource == "/"
    return @dir / "#{resource[1..]}.md"
  end
end

data = Path[ARGV[0]? || Dir.current]

live_reload = LiveReload::Server.new
FSWatch.watch data.to_s do |event|
  live_reload.send_reload(path: event.path, liveCSS: event.path.ends_with?(".css"))
end

server = HTTP::Server.new [
  MarkdownHandler.new(data),
  HTTP::StaticFileHandler.new(data.to_s),
]
address = server.bind_tcp 3000

puts "Using data at #{data.expand}"
puts "Listening on http://#{address}"
puts "LiveReload on http://#{live_reload.address}"

spawn do
  live_reload.listen
end

server.listen
