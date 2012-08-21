# Acts as stdlib Find, but yields the files by access time
class DirectoryRecurser
  def DirectoryRecurser.find(input_path)
    dd = []
    if File.directory?(input_path)
      dd = Dir.new(input_path).entries.map{|f| File.join(input_path,f)}
      dd.delete_if{|path| ['.','..'].include?(File.basename(path))}
      dd.compact!
      dd = dd.sort_by{|f1| File.atime(f1)}.reverse
    end

    dd.each do |path|
      if File.directory?(path)
        DirectoryRecurser.find(path) do |f|
          yield(f)
        end
      else
        yield(path)
      end
    end
    yield(input_path)
  end
end
