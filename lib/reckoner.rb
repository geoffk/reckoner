
=begin rdoc
The Reckoner class is intialized with the configuration information, 
loads the checks and performs them.
=end
class Reckoner
 VERSION = '0.4.0'

  attr_accessor :debug
  attr_reader :errors

  # Creates the class.  The first argument is an array of custom check files, 
  # if any. The debug arguments determines whether or not debugging information 
  # will be printed out during execution.
  def initialize(custom_check_files = nil,debug = false)
    @debug = debug
    @errors = []
    @registered_checks = {}
    load_checks(custom_check_files)
  end

  # Loads the checks from the standard_checks file and the 
  def load_checks(custom_check_files)
    #load the standard checks
    require 'standard_checks.rb'

    #load the custom check files from the arguments
    custom_check_files.each{|f| require f } if custom_check_files

    AbstractCheck.children.each do |chk|
      @registered_checks[chk.get_check_name] = chk
    end
  end

  # Goes through the passed in check hash and begins the checking
  # process.  Ensures that the files exist before the other checks 
  # are called.
  def check(check_hash)
    unless check_hash
      raise "No checks to perform - check that your configuration " +
            "file is formatted correctly"
      return
    end

    default_checks = check_hash.delete('default_check') || {}
    puts "Using defaults: #{default_checks.inspect}" if @debug && !default_checks.empty?

    check_hash.each do |block,checks|
      puts "\n'#{block}'" if @debug

      checks = default_checks.merge(checks)
      puts "  checks: #{checks.inspect}" if @debug

      files = checks.delete('files') || checks.delete('file')
      unless files
        raise "No file entries found in block '#{block}'"
      end      

      base_path = checks.delete('base_path')

      files = [files] unless files.is_a? Array

      files.each do |f|
        if base_path
          file_path = File.join(base_path,f.strip)
        else
          file_path = f.strip
        end
        if File.exists?(file_path) && File.readable?(file_path)
          puts "  Checking file '#{file_path}'" if @debug
          run_checks(block,file_path,checks)
        else
          @errors << "Reckoner found a problem with '#{file_path}': file " +
                     "does not exist or is not readable by this user"
        end   
      end
    end
  end

  private

  # Runs a set of checks on a file path
  def run_checks(block,file_path,checks)
    checks.each do |chk|
      puts "  Running check #{chk.inspect} on #{file_path}" if @debug

      check_name = chk[0]
      check_options = chk[1]

      if @registered_checks[check_name]
        check_obj = @registered_checks[check_name].new(file_path)
        check_obj.run_check(check_options.to_s)
        @errors = @errors + check_obj.errors
      else
        raise "Invalid check name: #{check_name},  " + 
              "Known checks: #{@registered_checks.keys.join(', ')}"
      end
    end
  end

end
