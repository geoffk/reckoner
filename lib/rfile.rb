
# RFile provides a unified and easy way to check various 
# attributes of a specific file or path.  It provides simple
# access to various methods from the core File class.
#
# It also offers several methods that provide simplified
# Find functionality.
class RFile
  attr_reader :path

  %w(<=> atime blksize blockdev? blocks chardev? ctime 
     dev dev_major dev_minor directory? executable? executable_real? 
     file? ftype gid grpowned? ino inspect mode mtime new nlink owned? pipe? 
     pretty_print rdev rdev_major rdev_minor readable? readable_real? 
     setgid? setuid? size size? socket? sticky? symlink? uid writable? 
     writable_real? zero?).each do |m|
    define_method m do |*args|
      stat.send m, *args
    end
  end

  %w(basename dirname expand_path extname lstat ).each do |m|
    define_method m do 
      File.send m, @path
    end
  end

  # Lazy loading of the stat object.
  def stat
    unless instance_variables.include?(:stat)
      @stat = File.stat(@path)
    end
    @stat
  end

  def initialize(path)
    @path = path
  end

  def to_s
    @path
  end

  def sub_nodes(options = {})
    opts = { :directories => true,
             :files => true }.merge(options)
    Find.find(@path) do |path|
       if ((File.file?(path) && opts[:files]) ||
           (File.directory?(path) && opts[:directories]))
         yield RFile.new(path)
       end
    end
  end

  # Loops through all sub-directories and yields to a block
  # for each node, passing in an RFile object for the current path.  
  # Returns true if any yield returns true, otherwise returns false.  
  #
  # Useful for efficiently determining if any
  # sub-directories or their files meet a user-defined criteria.
  def any_sub_node?(options={})
    sub_nodes(options) do |rf|
      return true if yield(rf)
    end
    return false
  end

  # Loops through all sub-directories and yields to a block
  # for each node, passing in an RFile object for the current path.  
  # Returns true if all yields returns true, otherwise returns false.  
  #
  # Useful for efficiently determining if any
  # sub-directories or their files meet a user-defined criteria.
  def all_sub_nodes?(options={})
    sub_nodes(options) do |rf|
      return false unless yield(rf)
    end
    return true
  end

  # Returns an array with an RFile object for every sub-directory
  # and file below the current path.
  def sub_node_array(options={})
    a = Array.new
    sub_nodes(options) do |rf|
      a << rf
    end
    return a
  end

end
