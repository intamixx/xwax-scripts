#!/bin/bash

# source configuration file
export CONFIGFILE="/intamixx/intamixxdj.conf"

[[ -r $CONFIGFILE ]] && source $CONFIGFILE || errorexit "$CONFIGFILE doesn't exist or is not readable by the user."

# Intamixx Config.
. $CONFIGFILE

find_audio_files() {
    # search folder for audio files and stop after first match
    find $1 -follow -iname '*.ogg' -o \
                    -iname '*.aac' -o \
                    -iname '*.cdaudio' -o \
                    -iname '*.mp3' -o \
                    -iname '*.flac' -o \
                    -iname '*.m4a' -o \
                    -iname '*.wav' | grep -m1 -
}

create_cr_string() {
    # create a string from all the crates specified in the CRATE array
    for crate in ${CRATE[@]}
    do
if [[ $CHECK_NONEMPTY = 1 ]]; then
            [[ `find_audio_files $crate | wc -l` != 0 ]] && CRATES+="-l \"$crate\" "
        else
CRATES+="-l \"$crate\" "
        fi
done
}

create_cs_string() {
    # create a string from the sub folders of those crates specified in the CRATEX array
    IFS=$'\n'
    for crate in ${CRATEX[@]}
    do
while read -r scrate
        do
if [[ $CHECK_NONEMPTY = 1 ]]; then
                [[ `find_audio_files $scrate | wc -l` != 0 ]] && CRATES+="-l \"$scrate\" "
            else
CRATES+="-l \"$scrate\" "
            fi
done < <(find $crate -follow -type d)
    done
unset IFS
}

create_pl_string() {
    # create a string from all nonempty playlists found in $PLAYLISTS
    IFS=$'\n'
    LISTARRAY=($(find $PLAYLISTS -type f ! -iname '.current'))
    tLen=${#LISTARRAY[@]}
    unset IFS
    
    for (( i=0; i<${tLen}; i++ ));
    do
        [[ -s ${LISTARRAY[$i]} ]] && LISTS+="-p \"${LISTARRAY[$i]}\" "
    done
}

echo "***************************************************"
echo "*              Xwax Startup Script                *"
echo "***************************************************"

CHECK_NONEMPTY=1

# create strings
#create_cr_string
#create_cs_string
#create_pl_string

# generate command line
#START="$xwax_bin -r $xwax_samplerate -i $xwax_importer -s $xwax_scanner $CRATES -m $xwax_buffer \
#-$xwax_speed -j $xwax_deck1 -j $xwax_deck2"

	#xwax_command="$xwax_bin -$xwax_speed -t $xwax_timecode -r $xwax_samplerate -i $xwax_importer -s $xwax_scanner -m $xwax_buffer -j $xwax_deck1 -j $xwax_deck2 ${x_dir_string[*]}"

#	echo $CRATES
#	echo $START
	#/usr/bin/xterm -fg yellow -bg black -T "Intamixx Xwax" -e "$xwax_command"

# run xwax
#sh <<<"$START"

echo "***************************************************"
echo "*              Xwax Startup Script                *"
echo "***************************************************"

counter=0

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

	echo "Reading in Xwax Media Directories . . ."

	if [ ! -d $xwax_media_dir ]
		then
		echo "$xwax_media_dir not found"
		exit
	else
		cd $xwax_media_dir
	fi

	for fname in $(ls)
		do
			if [[ "$fname" ]]
			then
				dirs[$counter]="$fname"
				counter=$(($counter + 1))
				echo "Found the "$xwax_media_dir/$fname" playlist"
			fi
		done

	echo "Completed Reading in $counter Xwax Media Playlists"

	for dir in ${dirs[*]}
		do
			x_dir_string="$x_dir_string -l \"$xwax_media_dir/$dir\""
		done

	echo
	echo "Compiling Xwax command line . . ."

	echo "Launching Xwax . . ."

	xwax_command="$xwax_bin -g 1300x768/1.2 --phono -k -$xwax_speed -t $xwax_timecode -r $xwax_samplerate -i $xwax_importer -s $xwax_scanner -m $xwax_buffer -j $xwax_deck1 -j $xwax_deck2 ${x_dir_string[*]}"

	#xwax_command="$xwax_bin -g 1300x768/1.2 --phono -k -$xwax_speed -t $xwax_timecode -r $xwax_samplerate -i $xwax_importer -s $xwax_scanner -m $xwax_buffer -j $xwax_deck1 -j $xwax_deck2 ${x_dir_string[*]}"
	#xwax_command="$xwax_bin -$xwax_speed -t $xwax_timecode -r $xwax_samplerate -i $xwax_importer -s $xwax_scanner -m $xwax_buffer -j $xwax_deck1 -j $xwax_deck2 -l /opt/media/MP3"

	echo $xwax_command
	/usr/bin/xterm -fg yellow -bg black -T "Intamixx Xwax" -e "$xwax_command"
