require 'uri'
require 'browsr/httpheaders'



class Browsr
  # Response encapsulates all data the browser gets from the server, that is:
  # * status code
  # * headers
  # * body (if available)
  class Response
    attr_reader :status, :body, :headers

    def initialize(status, headers, body)
      @status   = Integer(status)
      @headers  = HTTPHeaders.new(headers)
      @body     = body
    end

    def [](name)
      @headers[name]
    end

    # credit to Rack, copied several from there TODO: give proper/more
    # prominently credit
    def content_mime_type
      type = headers["content-type"]
      mime = type && MIME::Types[type[/^\S*/]]
      mime && mime.first
    end

    def valid_content_encoding?
      content   = headers["content-type"]
      encoding  = content && content[/;\s*(\S+)$/,1]
      return unless encoding
      begin
        Encoding.find(encoding)
        true
      rescue ArgumentError
        false
      end
    end

    def content_encoding
      content   = @headers["content-type"]
      encoding  = content && content[/;\s*(\S+)$/,1]
      if encoding then
        begin
          Encoding.find(encoding)
        rescue ArgumentError
          nil
        end
      else
        nil
      end
    end

    def content_length
      content_length = @headers["content-length"]
      content_length && content_length.to_i
    end

    def location
      @headers["location"]
    end

    def valid?;         @status.between?(100, 599);            end
    def invalid?;       !valid?;                               end

    def informational?; @status >= 100 && @status < 200;       end
    def successful?;    @status >= 200 && @status < 300;       end
    def redirection?;   @status >= 300 && @status < 400;       end
    def client_error?;  @status >= 400 && @status < 500;       end
    def server_error?;  @status >= 500 && @status < 600;       end

    def ok?;            @status == 200;                        end
    def forbidden?;     @status == 403;                        end
    def not_found?;     @status == 404;                        end

    def redirect?;      [301, 302, 303, 307].include? @status; end
    def empty?;         [201, 204, 304].include?      @status; end
  end
end
