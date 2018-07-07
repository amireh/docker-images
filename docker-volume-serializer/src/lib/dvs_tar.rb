class DVS
  module Tar
    NIL = Object.new.freeze
    COMPRESSION = {
      'bzip2' => { flag: '-j', ext: '.bz2' },
      'gzip'  => { flag: '-z', ext: '.gz'  },
      'lzma'  => { flag: '-a', ext: '.lz'  },
      'xz'    => { flag: '-J', ext: '.xz'  },
    }.freeze

    def self.pack(base:, dest:, src:, compression: nil, verbose: false)
      safe_exec([
        'tar',
        verbose ? '-v' : NIL,
        '-C', base,
        '-f', dest,
        compression ? compression[:flag] : NIL,
        '-T', src,
        '-c',
      ].reject { |x| x == NIL })
    end

    def self.unpack(base:, src:, compression: nil, verbose: false)
      safe_exec([
        'tar',
        verbose ? '-v' : NIL,
        '-C', base,
        '-f', src,
        compression ? compression[:flag] : NIL,
        '-x',
      ].reject { |x| x == NIL })
    end

    def self.archive_size(archive)
      human_filesize_of(File.size(archive))
    end

    protected

    def self.safe_exec(command)
      IO.popen(command) do |io|
        STDERR.write io.read
        io.close
        $?.to_i == 0
      end
    end

    # credit: SO https://stackoverflow.com/a/47486815
    def self.human_filesize_of(size)
      units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB']

      return '0.0 B' if size == 0
      exp = (Math.log(size) / Math.log(1024)).to_i
      exp = 6 if exp > 6

      '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
    end
  end
end