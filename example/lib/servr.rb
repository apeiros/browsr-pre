require 'mime/types'
require 'pp'

HTMLMime = MIME::Types['text/html'].first

class Servr
  def initialize(webroot)
    @public = File.expand_path(webroot)
    #puts "Starting with pid #{$$} and public: #{@public.inspect}"
  end

  def call(env)
    path_info = env["PATH_INFO"]

    return server_info(env) if path_info == "/server_info"

    file_path = File.join(@public, path_info.delete("\n\r").sub(%r{(?:^|(?<=/))../}, ''))
    exists    = File.file?(file_path)
    #puts "Requested #{exists ? 'file' : 'unexisting'} #{file_path}"

    if exists then
      mime_type = MIME::Types.type_for(File.extname(file_path)).first
      if mime_type == HTMLMime then
        mime_type = "#{mime_type}; utf-8"
      else
        mime_type = mime_type.to_s
      end
      [
        200,
        {'Content-Type' => mime_type},
        File.open(file_path, 'r:binary')
      ]
    else
      [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
    end
  end

  def server_info(env)
      [
        200,
        {'Content-Type' => "text/plain; encoding: utf-8"},
        [env.pretty_inspect]
      ]
  end
end
