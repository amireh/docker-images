require 'tempfile'
require 'fileutils'
require_relative './dvs_tar'
require_relative './dvs_volumes'

class DVS
  def pack(
    archive_dir:,
    compression: nil,
    owner_gid:,
    owner_uid:,
    verbosity: 0,
    volumes:
  )
    verbose = verbosity > 0
    volumes.each do |volume|
      volume_archive = "#{archive_dir}/#{volume.name}.tar#{compression ? compression[:ext] : ''}"

      input_file = Tempfile.new("#{volume.name}.in")
      input_file.write(volume.files.join("\n"))
      input_file.close

      puts "Packing volume \"#{volume.name}\"" if verbose
      puts '-' * 72 if verbose
      puts "Source: #{volume.dir}" if verbose
      puts "Archive: #{volume_archive}" if verbose
      puts "Archive files: #{volume.files.count}" if verbose

      fail "Unable to create archive." unless Tar.pack(
        base: volume.dir,
        compression: compression,
        dest: volume_archive,
        src: input_file.path,
        verbose: verbosity > 1,
      )

      FileUtils.chown_R(owner_uid, owner_gid, volume_archive)

      puts "Archive size: #{Tar.archive_size(volume_archive)}" if verbose
      puts "Archive owner: #{owner_uid}:#{owner_gid}" if verbose
    end
  end

  def unpack(
    archive_dir:,
    compression: nil,
    owner_gid:,
    owner_uid:,
    verbosity: 0,
    volumes:
  )
    verbose = verbosity > 0
    volumes.each do |volume|
      volume_archive = "#{archive_dir}/#{volume.name}.tar#{compression ? compression[:ext] : ''}"

      puts "Unpacking volume \"#{volume.name}\"" if verbose
      puts '-' * 72 if verbose
      puts "Archive: \"#{volume_archive}\"" if verbose
      puts "Destination: \"#{volume.dir}\"" if verbose
      puts "Destination owner: #{owner_uid}:#{owner_gid}" if verbose

      fail "Unable to extract archive." unless Tar.unpack(
        compression: compression,
        base: volume.dir,
        src: volume_archive,
        verbose: verbosity > 1
      )

      FileUtils.chown_R(owner_uid, owner_gid, volume.dir)
    end
  end
end
