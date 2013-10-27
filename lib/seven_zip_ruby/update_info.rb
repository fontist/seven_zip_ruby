module SevenZipRuby
  class UpdateInfo
    class << self
      def buffer(name, data)
        new(:buffer, { name: name, data: data })
      end

      def dir(name)
        new(:dir, { name: name })
      end

      def file(name, filepath, szw)
        new(:file, { name: name, filepath: filepath, szw: szw })
      end
    end

    def initialize(type, param)
      @type = type
      case(type)
      when :buffer
        initialize_buffer(param[:name], param[:data])
      when :dir
        initialize_dir(param[:name])
      when :file
        initialize_file(param[:name], param[:filepath], param[:szw])
      end
    end

    def initialize_buffer(name, data)
      @index_in_archive = nil
      @new_data = true
      @new_properties = true
      @anti = false

      @path = name
      @dir = false
      @data = data
      @size = data.size
      @attrib = 0x20
      @posix_attrib = 0x00
      @ctime = @atime = @mtime = Time.now
      @user = @group = nil
    end

    def initialize_dir(name)
      @index_in_archive = nil
      @new_data = true
      @new_properties = true
      @anti = false

      @path = name
      @dir = true
      @data = nil
      @size = 0
      @attrib = 0x10
      @posix_attrib = 0x00
      @ctime = @atime = @mtime = Time.now
      @user = @group = nil
    end

    def initialize_file(name, filepath, szw)
      @index_in_archive = nil
      @new_data = true
      @new_properties = true
      @anti = false

      @path = name.to_s
      @dir = false
      filepath = Pathname(filepath).expand_path
      @data = filepath.to_s
      @size = filepath.size
      @attrib = szw.get_file_attribute(filepath.to_s)
      @posix_attrib = 0x00
      @ctime = filepath.ctime
      @atime = filepath.atime
      @mtime = filepath.mtime
      @user = @group = nil
    end


    attr_reader :index_in_archive, :path, :data, :size, :attrib, :ctime, :atime, :mtime, :posix_attrib, :user, :group

    def buffer?
      return (@type == :buffer)
    end

    def directory?
      return @dir
    end

    def file?
      return !(@dir)
    end

    def new_data?
      return @new_data
    end

    def new_properties?
      return @new_properties
    end

    def anti?
      return @anti
    end
  end
end