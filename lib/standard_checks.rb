

# Ensures that a file is not too old.
class Freshness < AbstractCheck
  SECONDS_IN_HOUR = 60 * 60
  HOUR_HASH = {'default' => 24, 
               /^hour/i => 1,
               /^day/i => 24,
               /^week/i => 7*24, 
               /^month/i => 30*24,
               /^year/i => 365*24}

  def check(path_obj,options)
    hours = unit_parse(options,HOUR_HASH)

    old_time = Time.now - (hours * SECONDS_IN_HOUR)
    tomorrow = Time.now + (24 * SECONDS_IN_HOUR)

    unless path_obj.any_sub_node?{|f| f.mtime < tomorrow && f.mtime > old_time}
    #unless path_obj.any_sub_node?{|f| f.mtime > old_time}
      add_error('file is too old')
    end
  end
end

# Ensures that the size of the file is not
# too small.
class MinimumSize < AbstractCheck
  BYTES_HASH = {'default' => 1,
                /^b/i => 1,
                /^kb/i => 1024,
                /^mb/i => 1024**2,
                /^gb/i => 1024**3}

  def check(path_obj,options)
    bytes = unit_parse(options,BYTES_HASH)
    unless path_obj.size >= bytes
      add_error("file is too small")
    end
  end
end
