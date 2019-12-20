#!/usr/bin/ruby

require "webrick"

server = WEBrick::HTTPServer.new({
    :DocumentRoot => "./",
    :BindAddress => "127.0.0.1",
    :Port => "80"
})
trap("INT"){server.shutdown}
server.start