module SampleFile
SAMPLE_CONFIGURATION_FILE = <<SAMPLE
# SAMPLE RECKONER CONFIGURATION FILES
# Reckoner uses a YAML formatted file to define the checks
# that it should preform.  The file has two sections,
# the 'check' section and the 'mail' section.

# The check section contains a list of check blocks, each 
# of which defines one set of checks.
check:

  # Define default settings for all of your check blocks.
  # This default check sets my home directory as a default
  # base path for my checks.
  #
  # The default_check block is not required.
  default_check:
    base_path: /home/geoffk

  # This is the simplest possible check.  It simply ensures
  # that there exists a file named '.bash_history'.  Since this
  # checks doesn't overwrite the default 'base_path' it will
  # check for this file in '/home/geoffk'
  geoff_check:
    files: .bash_history

  # This check block, named 'etc-files', sets it's own base
  # path of '/etc' and then checks that two files,
  # 'redhat-release' and 'inittab', exist there.  Note the
  # use of square brackets and the comma to make a list of files.
  etc-files:
    base_path: /etc
    files: [fake-file, inittab]

  # This check ensures that two files exist and that they be 
  # at least 1kb in size and have been updated in the last
  # three days. 
  desktop-files:
    base_path: /home/geoffk/Desktop
    files: [bookmarks.html, songs.txt]
    freshness: 3 days
    minimum_size: 1 kb

# The mail section is required for email notifications.  The only
# required setting inside the mail section is 'to'. 
mail:
  to: DESTINATION EMAIL ADDRESS
  #from: defaults to current user 
  #subject_prefix: "RECKONER:"
  #always_email: true

SAMPLE
end
