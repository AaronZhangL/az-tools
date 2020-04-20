#!/bin/bash

TMPFILE=`/usr/bin/mktemp -d`
/usr/bin/find $1 -name .git -type d | /usr/bin/grep -v $2 > $TMPFILE/git-sync-repo.txt

for i in `/usr/bin/cat $TMPFILE/git-sync-repo.txt`
do

  /usr/bin/echo -en "\n\nRepo - $i\n"
  /usr/bin/git --git-dir=$i --work-tree=$i/.. fetch upstream
  /usr/bin/git --git-dir=$i --work-tree=$i/.. checkout master
  /usr/bin/git --git-dir=$i --work-tree=$i/.. merge upstream/master
  /usr/bin/git --git-dir=$i --work-tree=$i/.. push origin master

done

/usr/bin/rm -rf $TMPFILE
