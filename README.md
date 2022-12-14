# unsingularity

Extract files from a Singularity/Apptainer SIF file.

Requires squashfs-tools to be installed on the host.

## Usage

`unsingularity [-h] [-c] [-d DIRECTORY] [-e EXTRACT] [-l] [sif]...`

`-c`: cat files after extracting
`-e`: extract only certain files
`-d`: directory (default: `squashfs-root`)
`-l`: list only, don't extract (`-ll` long)

## Install

`sudo install unsingularity.sh /usr/local/bin/unsingularity`

## Examples

`unsingularity alpine.sif`

`unsingularity -e /etc/os-release -c alpine.sif`

`unsingularity -ll debian.sif`
