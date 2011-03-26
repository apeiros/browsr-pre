def find_file_in_load_path(load_path, file)
  load_path.each do |path|
    file = File.expand_path(file, path)
    return file if File.file?(file)
  end
  nil
end

def js_include(path, include, indent)
  content         = File.read(path)
  trimmed         = content.sub(/\n*\z/m, "\n")
  without_comment = trimmed.sub(%r{\A(?:^//.*?\n)+\n*}, '')
  reindented      = without_comment.gsub(/^/, indent)
  cleaned_code    = reindented

  "#{indent}// From: #{include}\n#{cleaned_code}\n\n\n"
end

namespace :browsr do
  task :compile do
    load_path   = %w[lib/browsr/browsers/safari5/javascript]
    target      = 'lib/browsr/browsers/safari5/script_core.js'
    script_core = File.read('lib/browsr/browsers/safari5/javascript/script_core_template.js')
    script_core = script_core.gsub(%r{( *)// INCLUDE (.*)\n}) {
      indent  = $1
      include = $2
      path    = find_file_in_load_path(load_path, include)

      js_include(path, include, indent)
    }
    File.open(target, 'wb') do |fh|
      fh.write(script_core)
    end
  end
end

task :default => 'browsr:compile'