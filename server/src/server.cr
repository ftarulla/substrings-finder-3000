require "http/server"
require "json"

server = HTTP::Server.new do |context|
  request = context.request
  response = context.response

  # Routing
  case request.path
  when "/"
    response.content_type = "text/plain"
    response.print "Hi!"
  when "/substrings"
    text = request.query_params["text"]?

    if text.nil?
      response.respond_with_status 400 # => 400 Bad Request
    else
      substrings = text.split(' ', remove_empty: true)
      body = JSON.build() do |json|
        json.array do
          substrings.each {|substring| json.string(substring)}
        end
      end

      response.content_type = "application/json; charset=utf-8"
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.print body
    end
  # when "/details"
  #   substring = request.query_params["substring"]?

  #   if substring.nil?
  #     response.respond_with_status 400 # => 400 Bad Request
  #   else
  #     body = JSON.build() do |json|
  #       json.object do
  #         json.field "details" do
  #           json.object do
  #             json.field "firstLetter" do
  #               json.object do
  #                 json.field "name", "Primera Letra"
  #                 json.field "value" do
  #                   json.string substring[0]
  #                 end
  #               end
  #             end
  #             json.field "numberLetters" do
  #               json.object do
  #                 json.field "name", "Cantidad de letras"
  #                 json.field "value" do
  #                   json.number substring
  #                 end
  #               end
  #             end
  #           end
  #         end
  #       end
  #     end

  #     response.content_type = "application/json; charset=utf-8"
  #     response.headers["Access-Control-Allow-Origin"] = "*"
  #     response.print body
  #   end
  when "/firstletter"
    word = request.query_params["word"]?

    if word.nil?
      response.respond_with_status 400 # => 400 Bad Request
    else
      body = JSON.build() do |json|
        json.string word[0]
      end

      response.content_type = "application/json; charset=utf-8"
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.print body
    end
  when "/uppercase"
    word = request.query_params["word"]?

    if word.nil?
      response.respond_with_status 400 # => 400 Bad Request
    else
      body = JSON.build() do |json|
        json.string word.upcase
      end

      response.content_type = "application/json; charset=utf-8"
      response.headers["Access-Control-Allow-Origin"] = "*"
      response.print body
    end
  else
    response.respond_with_status 404 # => 404 Not Found
  end
end

address = server.bind_tcp 8080
puts "Listening on http://#{address}"
server.listen
