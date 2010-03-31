
class Extension < AbstractCheck

  def check(path_obj,options)
    unless path_obj.extname == options.strip
      add_error 'is not a txt file'
    end
  end
end

