# docker-volume-transfer

Transfer Docker data (or named) volumes between different hosts by use of
archives.

DVT packs data found inside a named volume into an archive for you to transfer
to the target host machine. Once an archive is transferred, DVT can populate a
corresponding volume with the data from that archive.

In short, it's a glorified interface to POSIX tar.

## Usage

Keep at hand the list of named volumes you want to transfer and a directory to
hold the archives, then run the `dvs-pack` binary by a monstrous invocation
similar to the following:

```shell
docker run \
  --rm \

  # which user should be the owner of the archives (this example chooses the 
  # current user):
  -e DVS_GID=`id -g` \
  -e DVS_UID=`id -u` \
  
  # the volumes to pack:
  -e DVS_VOLUMES="vol-a,vol-b" \

  # mount a folder from the host machine to store the archives in:
  -v "$PWD/volume-archives":/var/lib/archives \
  
  # mount the volume(s) to pack (read-only will suffice):
  -v vol-a:/var/lib/volumes/vol-a:ro,nocopy \
  -v vol-b:/var/lib/volumes/vol-b:ro,nocopy \
  
  # pack:
  amireh/docker-volume-transfer:latest \
    dvs-pack
```

Now the archives `vol-a.tar` and `vol-b.tar` should be available under
`./volume-archives/` which can be transferred to a different host, or used
on the same host to restore the volumes.

The invocation for unpacking is similar to the one for packing except that the
volumes now need to be mounted in write mode since the archives are going to be
unpacked inside of them. At the same time, the archives volume can be safely
mounted in read-only mode if desired.

```shell
docker run \
  --rm \

  # specify which user should be the owner of the unpacked files (this example 
  # chooses the current user):
  -e DVS_GID=`id -g` \
  -e DVS_UID=`id -u` \
  
  # the volumes to restore:
  -e DVS_VOLUMES="vol-a,vol-b" \

  # mount the folder containing the archives packed previously (this time 
  # around, read-only can be used):
  -v "$PWD/volume-archives":/var/lib/archives:ro \
  
  # mount the volume(s) to restore in __WRITE__ mode:
  -v vol-a:/var/lib/volumes/vol-a:rw,nocopy \
  -v vol-b:/var/lib/volumes/vol-b:rw,nocopy \
  
  # unpack:
  amireh/docker-volume-transfer:latest \
    dvs-unpack
```


## Arguments

Items marked with `!` are required.

### `DVS_ARCHIVE_DIR` _`(Path)`_

When packing, this is the path to the directory (in the container) to use for
storing the archives.

Normally you would want to bind-mount a directory from the host machine so that
you get access to the generated archives after the container is removed:

```shell
$ mkdir ./volume-archives
$ docker run -v "$PWD/volume-archives":/var/lib/archives ... dvs-pack
# ./volume-archives should now contain the archives
```

Conversely, when unpacking this is the path to the directory containing the
archives to restore from.

Defaults to: `/var/lib/archives`

### `DVS_COMPRESS` _`(String)`_

Compression algorithm `tar` should use. Allowed values are:

- `bzip2`
- `gzip`
- `lzma`
- `xz`

`gzip` provides the best trade-off between compression ratio and execution
time, while `lzma` yields the best compression ratios (and is the slowest.)

### `DVS_GID` _`(Number!)`_

Group id of the owner of the archive, when packing, or the unarchived data when
unpacking. This value will be used to `chown` the target.

This must be the numeric value which you can get using `id -g`.


### `DVS_UID` _`(Number!)`_

Like `DVS_GID` but for the user id. You can get the value using `id -u`.

### `DVS_VOLUMES` _`(List!)`_

Name of the volume(s) to operate on separated by commas. 

**Note**: when running the container, the name of the **mount-point** (the
directory) **MUST** match the name of the volume. For example, you shouldn't
mount a volume named `a` at `/var/lib/volumes/b` in the container!

**File selection**

During pack, you can optionally select which files or directories to include
from the volume if you don't want to pack everything (e.g. build artifacts that
are no longer needed.) To do that, the path (or a glob pattern) to those
resources can be specified after the volume name with a slash in between.

For example, the following will archive the entirety of the `lib` folder, all
immediate files under the `bin` folder, and the single file `VERSION`:

    -e DVS_VOLUMES="my-vol/lib/**/*,my-vol/bin/*,my-vol/VERSION"

### `DVS_VOLUME_DIR` _`(Path)`_

Path to the directory (in the container) where the volumes to pack from or
unpack into will be mounted. Naturally, this will correspond to the value
passed to the `-v` flag when running the container.

Defaults to: `/var/lib/volumes`

### `DVS_VERBOSE` _`(Number)`_

Set to `1` to get some useful diagnostics. Set to `2` to also list all the
files in the archives (very noisy!) Set to `0` to get no output at all.

Defaults to: `1`.
