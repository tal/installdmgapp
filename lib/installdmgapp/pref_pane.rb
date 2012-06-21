module Installdmgapp
  class PrefPane
    attr_reader :path, :target_path
    def initialize(path)
      @path = File.expand_path(path)
      @target_path = File.expand_path(File.join('~/Library/PreferencePanes',name))
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
      delete if exist?
      `cp -R #{path} #{target_path}` unless exist?
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