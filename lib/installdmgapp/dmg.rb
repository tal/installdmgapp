module Installdmgapp
  class Dmg
    attr_accessor :target

    def initialize(path, options={})
      @path = File.expand_path(path)

      options.each do |k,v|
        instance_variable_set "@#{k}", v
      end

      @target ||= '/Applications'
    end

    def mount

      IO.popen("hdiutil attach '#{@path}'") do |p|
        p.each_line do |line|

          if line =~ /^\/dev\/dis/
            if m = line.match(/(\/Volumes\/.+)/)
              @volume = m[1]
            end
          elsif line =~ /^expected\s+CRC32/
          else
            puts line
          end

        end
      end

      @volume
    end

    def unmount
      if system("hdiutil detach #{@path}")
        @volume = nil
      end
    end

    def volume
      @volume || mount
    end

    def app_files
      Dir[File.join(volume,'/*.app')]
    end

    def apps
      @apps ||= app_files.collect {|a| App.new(a,target)}
    end

    def install
      apps.each do |app|
        puts "Installing #{app.name}"
        app.copy
      end
    end

  private

    def get_y
      val = gets.chomp
      !!(val =~ /^y(es)?$/i)
    end
  end
end