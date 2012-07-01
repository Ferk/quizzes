#!/bin/sh
#
# Updates the system-wide quiz files adding
# the quizzes from the current directory.
#
# by Fernando Carmona Varo
#

PREFIX=/usr/share/bsdgames/quiz/
INDEX=index

destindex="$PREFIX$INDEX"
[ -w "$destindex" ] || {
    echo "Quiz index file not found or no writting permissions (are you not root?)"
    exit 1
}

for line in $(cat "$INDEX")
do
    # skip lines to invalid files
    file=${line%%:*}
    [ -e "$file" ] || continue

    # copy quiz file
    destfile="${PREFIX}${file#./}"
    cp -fv "$file" "$destfile"
    
    # update quiz index
    if grep "$destindex" -qe "$destfile:"; then
	cat "$destindex" | sed "s%${destfile}:.*%${line/$file/$destfile}%" | sponge "$destindex"
    else
	echo "${line/$file/$destfile}" >> "$destindex"
    fi

done




