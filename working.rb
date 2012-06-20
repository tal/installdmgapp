require 'rubygems'
require 'ps'

dmg = '/Users/tal/Downloads/PwnageTool_5.1.1.dmg'

open = "hdiutil attach '#{dmg}'"
app_dir = '/Applications'

def get_y
  val = gets.chomp
  !!(val =~ /^y(es)?$/i)
end

IO.popen(open) do |p|
  p.each_line do |line|
    if line =~ /^\/dev\/dis/
      if m = line.match(/(\/Volumes\/.+)/)
        $volume = m[1]
      end
    elsif line =~ /^expected\s+CRC32/
    else
      puts line
    end
  end
end

abort("no mounted volume found") unless $volume

puts "Mounted dmg to: #{$volume}\n\n"

Dir[$volume+'/*.app'].each do |app|
  app_name = File.basename(app)
  str = "Copying #{app_name} to #{app_dir}"
  puts "Copying #{app_name} to #{app_dir}", "-"*str.length
  target_path = File.join(app_dir,app_name)
  if File.exist?(target_path)
    print "  #{app_name} already exists, overwrite? (Y/N) "

    next unless get_y

    process_list = PS(Regexp.new('^'<<target_path))

    if proc = process_list.first
      puts "  #{app_name} is running with pid #{proc.pid}"
      print "  Would you like to kill that process and continue overwriting? (Y/N) "

      next unless get_y

      puts "  Sending SIGTERM to pid: #{proc.pid}"
      proc.kill!("TERM")
    end

    puts "rm -rf #{target_path}"
    `rm -rf #{target_path}`
  end

  puts "cp -R #{app} #{target_path}"
  `cp -R #{app} #{target_path}`
end

system("hdiutil detach #{$volume}")