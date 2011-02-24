require 'mime/types'

class Servr
  def initialize
    @public = File.expand_path('webroot')
    #puts "Starting with pid #{$$} and public: #{@public.inspect}"
  end

  def call(env)
    path_info = env["PATH_INFO"]
    file_path = File.join(@public, path_info.delete("\n\r").sub(%r{(?:^|(?<=/))../}, ''))
    exists    = File.file?(file_path)
    #puts "Requested #{exists ? 'file' : 'unexisting'} #{file_path}"

    if exists then
      mime_type = MIME::Types.type_for(File.extname(file_path)).first.to_s
      [
        200,
        {'Content-Type' => mime_type},
        File.open(file_path, 'r:binary')
      ]
    else
      [404, {'Content-Type' => 'text/plain'}, ["Not found"]]
    end
  end
end
