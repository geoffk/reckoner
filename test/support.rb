####
# Offers support for running backup check tests

require 'fileutils'

module BackupCheckSupport
  include FileUtils

  ROOT = '/tmp/file_verifier_tests'

  #Makes a set of files that meet the specified options
  def makef(root,name,options = {})
    mkdir root unless File.exists?(root.to_s)
    if name.is_a? Hash
      name.each do |k,n|
        makef File.join(root,k.to_s),n,options
      end
    elsif name.is_a? Array
      name.each do |n|
        makef(root,n,options)
      end
    elsif name.is_a?(String) || name.is_a?(Symbol)
      path = File.join(root,name.to_s)
      touch path
      File.chmod(options[:chmod],path) if options[:chmod]
      File.utime(options[:atime],options[:atime],path) if options[:atime]
    end
    File.utime(options[:atime],options[:atime],root) if options[:atime]
  end

  def clean_root
    rm_rf(ROOT)
  end

  #Converts days to seconds
  def d2s(days)
    days * 24 * 60 * 60
  end

  #Determines if the object has any errors matching the regular
  #expression.
  def has_error(cmain,reg)
    cmain.errors.any?{|msg| reg.match msg}
  end

end
