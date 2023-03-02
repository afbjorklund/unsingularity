#!/bin/sh
# unsingularity: extract or list files from a SIF file
# Written by Anders F Björklund <anders.f.bjorklund@gmail.com>
cat=false
directory="squashfs-root"
mount=false
extract=$(mktemp)
ls=""
noprogress=""
tail="+4"
usage="$0 [-h] [-c] [-d DIRECTORY] [-e EXTRACT] [-l] [-m] [sif]..."

while getopts cd:e:hlm name
do
	case $name in
		c) cat=true;;
		d) directory="$OPTARG";;
		e) echo "$OPTARG" >> $extract;;
		h) echo "Usage: $usage";;
		l) if [ -z "$ls" ]; then ls="-l"; else ls="-ll"; fi;;
		m) mount=true;;
		*) exit 1;;
	esac
	export l
done
shift $((OPTIND - 1))

if $(which siftool >/dev/null 2>&1); then
	siftool=siftool
else
	siftool="apptainer sif"
fi
if unsquashfs -h 2>&1 | grep -- -o >/dev/null; then
	has_offset=true
else
	has_offset=false
fi
if $(which squashfuse >/dev/null 2>&1); then
	squashfuse=squashfuse
else
	squashfuse=$(dirname $(which apptainer))/../libexec/apptainer/bin/squashfuse_ll
fi

for sif in "$@"; do
	if $cat; then directory=$(mktemp -d); rmdir "$directory"; noprogress="-n"; tail="+10"; fi
	if [ $has_offset -a ! $mount ]; then
		offset=$($siftool list "$sif" | grep Squashfs | cut -d'|' -f4 | cut -d'-' -f1)
		unsquashfs $noprogress -o $offset $ls -d $directory -e $extract $sif | tail -n $tail
	elif $mount; then
		offset=$($siftool list "$sif" | grep Squashfs | cut -d'|' -f4 | cut -d'-' -f1)
		mkdir -p $directory
		$squashfuse -o offset=$offset $sif $directory
	else
		layer=$($siftool list "$sif" | grep Squashfs | cut -d'|' -f1)
		$siftool dump $layer "$sif" > "$sif.squashfs"
		unsquashfs $noprogress $ls -d $directory -e $extract $sif.squashfs | tail -n $tail
		rm "$sif.squashfs"
	fi
	if $cat; then xargs -I% cat $directory/% <$extract; rm -rf "$directory"; fi
done
rm $extract || exit 1

exit 0
