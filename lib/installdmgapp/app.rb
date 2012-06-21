module Installdmgapp
  class App
    attr_reader :path, :target_path
    def initialize(path,target_dir)
      @path = File.expand_path(path)
      @target_path = File.expand_path(File.join(target_dir,name))
    end

    def process
      @process ||= PS(Regexp.new('^'<<target_path)).first
    end

    def running?
      process && process.alive?
    end

    def kill
      puts "  #{name} is running with pid #{process.pid}"
      print "    Would you like to kill that process and continue overwriting? (Y/N) "

      if get_y
        ret = process.kill!("TERM")
        @process = nil
        ret
      end
    end

    def name
      File.basename(@path)
    end

    def exist?
      File.exist?(target_path)
    end

    def delete
      print "  #{name} already exists, overwrite? (Y/N) "

      if get_y
        `rm -rf #{target_path}`
      end
    end

    def copy
      kill if running?
      delete if exist?
      `cp -R #{path} #{target_path}` unless exist? || running?
    end
    alias install copy

  private

    def l msg
      puts(l) if @verbose
    end

    def get_y
      val = gets.chomp
      !!(val =~ /^y(es)?$/i)
    end
  end
end