#!/bin/sh
#
# Updates the system-wide quiz files adding
# the quizzes from the current directory.
#
# by Fernando Carmona Varo
#

PREFIX=/usr/share/bsdgames/quiz/
INDEX=index

index="$PREFIX$INDEX"
[ -w "$index" ] || {
    echo "Quiz index file not found or no writting permissions (are you not root?)"
    exit 1
}

for file in *.quiz
do
    # get the "quiz:" comment line with the quiz description
    desc=$(grep "$file" -m1 -e "^[ ]*#[ ]*quiz:")
    [ -z "$desc" ] && continue # skip if not found

    # format the description properly
    desc=${desc/*quiz:/$file:}
    echo "Installing: $desc"

    # copy quiz file, removing comments (lines starting with #)
    destfile="${PREFIX}${file#./}"
    destfile="${destfile%.quiz}"
    grep "$file" -ve "^[ ]*#" > "$destfile"

    # update quiz index
    if grep "$index" -qe "^$destfile"; then
	cat "$index" | sed "s%${destfile}:.*%${desc/$file/$destfile}%" | sponge "$index"
    else
	echo "${desc/$file/$destfile}" >> "$index"
    fi

done




