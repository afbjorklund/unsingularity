# unsingularity

Extract files from a Singularity/Apptainer SIF file.

Requires squashfs-tools to be installed on the host.

## Usage

`unsingularity [-h] [-c] [-d DIRECTORY] [-e EXTRACT] [-l] [sif]...`

* `-c`: cat files after extracting
* `-e`: extract only certain files
* `-d`: directory (default: `squashfs-root`)
* `-l`: list only, don't extract (`-ll` long)
* `-m`: use `squashfuse`, instead of `unsquashfs`

## Mount

If you use the mount flag (`-m`), the filesystem is FUSE mounted.

The .squashfs filesystem is extracted from the .sif file first.

When done with the files, use: `fuserunmount` (`fusermount -u`).

To free up disk space, you can remove the `.sif.squashfs` file.

## Install

`sudo install unsingularity.sh /usr/local/bin/unsingularity`

## Examples

`unsingularity alpine.sif`

`unsingularity -e /etc/os-release -c alpine.sif`

`unsingularity -ll debian.sif`
