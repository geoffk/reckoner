
# Provides sendmail functionality for the reckoner script.
class Sendmail

  # Creates the class with a path to the binary (if any is
  # given) and options.
  def initialize(path,options)
    @path = path
    @options = options
  end

  #Sends the email. 
  def send(to,from,subject,message)
    path = @path || 'sendmail'
    options = @options || '-i -t'

    cmd = %|#{path} #{options}|

    body = "To: #{to}\n"
    body << "From: #{from}\n"
    body << "Subject: #{subject}\n"
    body << "\n#{message}"

    io = IO.popen(cmd,'w')
    io.puts body 
    io.close
  end
end
