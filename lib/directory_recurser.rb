# Acts as stdlib Find, but goes through the directories and files 
# in order of access time
class DirectoryRecurser
  def self.find(input_path, sorting = :atime)
    dd = []
    if File.directory?(input_path)
      dd = Dir.new(input_path).entries.map{|f| File.join(input_path,f)}
      dd.delete_if{|path| unwanted?(path)}
      dd.compact!

      if sorting == :alpha
        dd = dd.sort_by{|f1| File.basename(f1)}
      elsif sorting == :mtime
        dd = dd.sort_by{|f1| File.mtime(f1)}.reverse
      elsif sorting == :atime
        dd = dd.sort_by{|f1| File.atime(f1)}.reverse
      else
        raise "Invalid sorting method: #{sorting}"
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

  private
 
  def self.unwanted?(path)
    File.symlink?(path) || ['.','..'].include?(File.basename(path))
  end
end
