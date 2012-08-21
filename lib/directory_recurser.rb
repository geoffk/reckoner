# Acts as stdlib Find, but goes through the directories and files 
# in order of access time
class DirectoryRecurser
  def DirectoryRecurser.find(input_path, sorting = :atime)
    dd = []
    if File.directory?(input_path)
      dd = Dir.new(input_path).entries.map{|f| File.join(input_path,f)}
      dd.delete_if{|path| ['.','..'].include?(File.basename(path))}
      dd.compact!

      if sorting == :alpha
        dd = dd.sort_by{|f1| File.basename(f1)}
      elsif sorting == :atime
        dd = dd.sort_by{|f1| File.atime(f1)}.reverse
      end
    end

    dd.each do |path|
      if File.directory?(path)
        DirectoryRecurser.find(path, sorting) do |f|
          yield(f)
        end
      else
        yield(path)
      end
    end
    yield(input_path)
  end
end
