require 'net/smtp'
require 'rubygems'
require 'yaml'
require 'optparse'
require 'fileutils'

require 'rfile.rb'
require 'abstract_check.rb'
require 'reckoner'
require 'sendmail'
require 'sample'

=begin rdoc
The Main class ties together the core Reckoner functionality
with the command line arguments, configuration file and email.
=end

class Main
  include SampleFile

  DEFAULT_ARGUMENTS = {
    'debug' => false,
    'quiet' => false,
    'extra_checks' => [],
    'sample' => nil,
    'email' => true
  }

  def self.error_out(message)
    STDERR.puts "Aborting Reckoner operations!"
    STDERR.puts message
    exit 1
  end

  def initialize(argv)
    @argv = argv
    @arguments = DEFAULT_ARGUMENTS.dup
    @opt_parser = OptionParser.new do |o|
      o.banner = "Usage: #{$0} [options] [config_file]"
      o.on('-d', '--debug', 'Output debugging information')  do |d|
        @arguments['debug'] = d
      end
      o.on('-q', '--quiet', 'Do not print final report') do |q|
        @arguments['quiet'] = q
      end
      o.on('-e', '--email-off', 'Do not send email, even if configured') do |q|
        @arguments['email'] = !q
      end
      o.on('-c','--checks=FILE', 'Additional checks file') do |c|
        @arguments['extra_checks'] << c
      end
      o.on('-s FILE','--sample-config FILE', 'Create a sample config named FILE') do |sample|
        @arguments['sample'] = sample
      end
    end
    @opt_parser.parse!(@argv)
  end

  def run_reckoner
    if @arguments['sample']
      return(make_sample_file(@arguments['sample']))
    end

    if @argv.length > 1
      Main.error_out "Aborting Reckoner: Too many arguments\n" + @opt_parser.help
    end

    if @argv.empty?
      config_file = STDIN.read
    else
      config_file = File.read(@argv[0])
    end 

    run_config(config_file)
  end

  def run_config(config_file)
    begin
      yaml_tree = YAML::load(config_file)
    rescue ArgumentError => e
      Main.error_out "There was an error parsing the YAML configuration file."
    end

    cm = Reckoner.new(@arguments['extra_checks'],@arguments['debug'])
    cm.check(yaml_tree['check'])

    if yaml_tree['mail'] && @arguments['email']
      send_email( cm, yaml_tree['mail'])
    end

    if @arguments['quiet']
      return nil
    else
      return output_results(cm)
    end
  end

  def send_email(cm,mail_config)
    raise "Mail section must have a 'to' parameter" unless mail_config['to']
    mailobj = Sendmail.new(mail_config['sendmail_path'],
                           mail_config['sendmail_options'])

    from = mail_config['from'] || ENV['USER']
    always_mail = mail_config['always_mail'] || true
    subject = mail_config['subject_prefix'] || 'Reckoner:'
    subject.strip!
    subject << ' '

    if !cm.errors.empty?
      subject << "Found #{cm.errors.length} problem(s)"
      body = cm.errors.join("\n")
      mailobj.send(mail_config['to'],from,subject,body)
    elsif always_mail
      subject << "No problems found"
      body = "No problems found"
      mailobj.send(mail_config['to'],from,subject,body)
    end
  end

  def output_results(cm)
    s = String.new
    if cm.errors.empty?
      s = "No failed checks"
    else
      s = "#{cm.errors.length} problem(s) found!\n"
      cm.errors.each do |err|
        s << err + "\n"
      end
    end
    return s
  end

  def make_sample_file(file_name)
    out = File.open(file_name,'w')
    out.write SAMPLE_CONFIGURATION_FILE
    out.close
    "Generated file #{file_name}"
  end

  
end
