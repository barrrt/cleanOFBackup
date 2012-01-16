#!/usr/bin/env ruby
# Copyright (c) 2011-2012 Bartlomiej Cichosz
# bartcichosz.com
# @barrrt
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom
# the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in 
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


require 'fileutils'

OF_BACKUP_FOLDER_NAME = File.expand_path '~/Documents/OmniFocus Backups/'
LAUNCH_AGENT_FOLDER_NAME = File.expand_path '~/Library/LaunchAgents'
LAUNCH_AGENT_FILE_NAME ='com.bartcichosz.cleanOFBackup.plist'

# ########################################
def delete_backups


  if not File.exist? OF_BACKUP_FOLDER_NAME
    puts "Error: #{OF_BACKUP_FOLDER_NAME} does not exist.\n"
    exit 0
  end

  if not File.directory? OF_BACKUP_FOLDER_NAME
    puts "Error: #{OF_BACKUP_FOLDER_NAME} is not a directory.\n"
    exit 0
  end

  # add files/folders that end with ".ofocus-backup" to files array
  files = []
  Dir.foreach(OF_BACKUP_FOLDER_NAME) { |f| files << f if f.end_with?(".ofocus-backup")}

  # append path before each file name
  files.map! {|f| "#{OF_BACKUP_FOLDER_NAME}/#{f}"}

  # delete each backup file
  files.each do |f|
    begin
      puts f
      FileUtils.rm_rf f
    rescue
      # do nothing if error occurs, file will be deleted next time
    end

  end

end # delete_backups

# ########################################
def turn_on
  # make sure the launch agent is stop if running, so turn off first
  turn_off

  # get the launch agent content from the end of this script
  agent = DATA.read

  # substitute variables in the launch agent script
  script_path = File.expand_path(File.dirname(__FILE__)) + "/"
  script_name = File.basename(__FILE__)
  script_path_and_name = script_path + script_name
  agent.gsub!(/SCRIPT_LOCATION_AND_NAME/, script_path_and_name)
  agent.gsub!(/SCRIPT_NAME/,script_name)
  agent.gsub!(/OF_BACKUP_FOLDER_NAME/,OF_BACKUP_FOLDER_NAME)

  # write the launch agent script to its folder
  agent_path_and_name = LAUNCH_AGENT_FOLDER_NAME + "/" + LAUNCH_AGENT_FILE_NAME
  if File.exist?(LAUNCH_AGENT_FOLDER_NAME) && File.directory?(LAUNCH_AGENT_FOLDER_NAME)
    begin
      f = File.open(agent_path_and_name,"w")
      f << agent
      f.close
    rescue
      f.close if f
      puts "Could not create the launch agent file at #{agent_path_and_name}. Could not turn on the script."
      return
    end
  else
    puts "Folder #{LAUNCH_AGENT_FOLDER_NAME} does not exist. Could not turn on the script."
    return
  end

  # tell launchctl to load the script   # launchctl load ~/Library/LaunchAgents/...
  exec("launchctl load #{agent_path_and_name}")

  # execute script immediately
  delete_backups

  puts "Turned on."

end # turn_on

# ########################################
def turn_off
  agent_path_and_name = LAUNCH_AGENT_FOLDER_NAME + "/" + LAUNCH_AGENT_FILE_NAME

  # verify that launch agent file exists
  if not File.exist? agent_path_and_name
     return
  end
  # stop this launch agent
  %x[launchctl unload #{agent_path_and_name}]

  # delete the launch agent file
  begin
    File.unlink agent_path_and_name
  rescue
    puts "Could not delete #{agent_path_and_name}"
  end

end # turn_off

# ########################################
def print_usage_info
  msg = <<XXXX

Ruby version #{RUBY_VERSION}
Usage:

  #{__FILE__}
  #{__FILE__} on
  #{__FILE__} off

  First case removes backups.
  Second case turns on automatic watching of #{OF_BACKUP_FOLDER_NAME} folder.
  Third case turns off the automatic backup deletion.


XXXX

  puts msg

end # print_usage_info


# ########################################
#
# script begins here
#
# ########################################

if ARGV.length == 0
  delete_backups
elsif ARGV.length == 1
  if ARGV[0].downcase == "on"
    turn_on
  elsif ARGV[0].downcase == "off"
    turn_off
  else
    print_usage_info
  end
else
  print_usage_info
end


# end of script. Everything after __END__ will be read when the script is run with on switch
# the content below will be augments with script name etc., then saved to the LaunchAgents folder

__END__
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<dict>
        <key>Label</key>
        <string>com.bartcichosz.cleanOFBackup</string>

        <key>LowPriorityIO</key>
        <true/>

        <key>Program</key>
        <string>SCRIPT_LOCATION_AND_NAME</string>

        <key>ProgramArguments</key>
        <array>
          <string>SCRIPT_NAME</string>
        </array>

        <key>WatchPaths</key>
        <array>
          <string>OF_BACKUP_FOLDER_NAME</string>
        </array>
</dict>
</plist>