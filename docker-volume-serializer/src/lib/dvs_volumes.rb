class DVS
  class Volume
    attr_reader :dir, :name, :files

    def initialize(dir:, name:, files:)
      @dir = dir
      @files = files
      @name = name
    end
  end

  module Volumes
    BASE_DIR = '/var/lib/volumes'.freeze

    def self.from(buffer, base: nil)
      base ||= BASE_DIR
      buffer.split(',').reduce({}) do |volumes, fragment|
        volume, *path = *fragment.split('/')

        volumes[volume] ||= []
        volumes[volume] << path.join('/') unless path.empty?
        volumes
      end.map do |volume, paths|
        volume_dir = "#{base}/#{volume}"

        # mark all files and directories if no paths were specified
        paths = [ '**/*' ] if paths.empty?

        files = paths.reduce([]) do |list, pattern|
          list + Dir.glob("#{pattern}", base: volume_dir)
        end

        Volume.new(
          name: volume,
          dir: volume_dir,
          files: files
        )
      end
    end
  end
end