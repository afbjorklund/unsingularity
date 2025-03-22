# unsingularity

Extract files from a Singularity/Apptainer SIF file.

Requires squashfs-tools to be installed on the host.

Also requires either of `siftool` or `apptainer`.

<https://github.com/sylabs/sif>

## Usage

`unsingularity [-h] [-c] [-d DIRECTORY] [-e EXTRACT] [-l] [sif]...`

* `-c`: cat files after extracting
* `-e`: extract only certain files
* `-d`: directory (default: `squashfs-root`)
* `-i`: inspect metadata, don't extract
* `-l`: list only, don't extract (`-ll` long)
* `-m`: use `squashfuse`, instead of `unsquashfs`
* `-n`: use `squashnfs`, instead of `squashfuse`

## Mount

If you use the mount flag (`-m`), the filesystem is FUSE mounted.

When done with the files, use: `fuserunmount` (`fusermount -u`).

If you use the nfs mount flag (`-n`), it is instead NFS mounted.

When done with the files, use: `squashnfs -u` (or unmount it).

## Install

`sudo install unsingularity.sh /usr/local/bin/unsingularity`

## Examples

`unsingularity alpine.sif`

`unsingularity -e /usr/lib/os-release -c alpine.sif`

`unsingularity -ll debian.sif`
