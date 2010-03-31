require 'find'

# The parent class of all checks.  It provides all necessary
# logic except for the check itself.
class AbstractCheck
  attr_reader :errors
  attr_reader :path
  @@classes = []

  def self.inherited(c)
    @@classes << c
  end

  def self.children
    return @@classes
  end

  def self.check_name(name)
    self.class_eval("def self.get_check_name; '#{name}'; end")
  end

  # Returns the name of the check.  By default it un-camel-cases the class 
  # name. (Code taken from the underscore method of Rails' Inflector Module.)
  def self.get_check_name
    self.name.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  # Performs simple unit parsing of strings of the form "[number] [units]".
  #
  # The unit hash contains a hash where the keys are regular expressions
  # that match a unit.  Each value is a factor that will be multiplied against
  # the parsed number.
  #
  # Example converting to inches (12 inches = 1 foot):
  # uhash = { /^inch/ => 1, /^feet/ => 12, /^foot/ => 12, 'default' => 1}
  #
  # * AbstractCheck.unit_parse("1",uhash) #=> 1
  # * AbstractCheck.unit_parse("1 inch",uhash) #=> 1
  # * AbstractCheck.unit_parse("1 foot",uhash) #=> 12
  # * AbstractCheck.unit_parse("2 feet",uhash) #=> 24 inches
  #
  def unit_parse(content,unit_hash)
    m = /(\d*\.?\d+)\s*(.*)/.match content
    raise "Could not parse '#{content}'" unless m
    if m.length == 2
      factor = unit_hash['default'] || 1
    elsif m.length == 3
      key,factor = unit_hash.detect{|key,value| key.match(m[2])}
      raise "Invalid unit in '#{content}'" unless factor
    end
    if /\./.match m[1]
      m[1].to_f * factor
    else
      m[1].to_i * factor
    end
  end

  # Creates the check object, requires a path to check as the argument.
  def initialize(file_path)
    @errors = []
    @path = RFile.new(file_path)
  end

  # Called by the Recokoner class to run the check
  def run_check(options)
    check(@path,options)
  end

  # Adds an error message for this check.  Use this if your check finds that
  # the check is invalid.
  def add_error(msg)
    @errors << "#{self.class.get_check_name.capitalize} found a problem with '#{@path.path}': #{msg}"
  end

  # Override this method to perform your custom check.  Its first argument is
  # a RFile path object, the second argument is any options passed in along with the
  # check in the YAML file.
  def check(path_obj,options)
    raise "Called abstract methd: check"
  end

end
