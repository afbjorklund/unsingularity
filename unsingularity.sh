#!/bin/sh
# unsingularity: extract or list files from a SIF file
# Written by Anders F Björklund <anders.f.bjorklund@gmail.com>
cat=false
directory="squashfs-root"
extract=$(mktemp)
ls=""
noprogress=""
tail="+4"
usage="$0 [-h] [-c] [-d DIRECTORY] [-e EXTRACT] [-l] [sif]..."

while getopts cd:e:hl name
do
	case $name in
		c) cat=true;;
		d) directory="$OPTARG";;
		e) echo "$OPTARG" >> $extract;;
		h) echo "Usage: $usage";;
		l) if [ -z "$ls" ]; then ls="-l"; else ls="-ll"; fi;;
		*) exit 1;;
	esac
	export l
done
shift $((OPTIND - 1))

for sif in "$@"; do
	if $cat; then directory=$(mktemp -d); rmdir "$directory"; noprogress="-n"; tail="+10"; fi
	offset=$(apptainer sif list "$sif" | grep Squashfs | cut -d'|' -f4 | cut -d'-' -f1)
	unsquashfs $noprogress -o $offset $ls -d $directory -e $extract $sif | tail -n $tail
	if $cat; then xargs -I% cat $directory/% <$extract; rm -rf "$directory"; fi
done
rm $extract || exit 1

exit 0
