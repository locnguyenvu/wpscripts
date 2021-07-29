#!/usr/bin/env zsh

if [ ${#@} -lt 2 ]; then
    echo 'Merge 2 branch in hard way (cherry-pick)'
    echo 'Usage: git-copy-files <path_to_change_files> <source_branch> <target_branch>'
    exit 1
fi

if [ ! -f "$1" ]; then
    echo 'Please specifies change files'
    exit 1
fi

declare -a CHANGE_FILES
CHANGE_FILES=( $(cat "$1") )

SOURCE_BRANCH=$2
TARGET_BRANCH=$3

git checkout $SOURCE_BRANCH
git pull origin $SOURCE_BRANCH

TMP_DIR="/tmp/gcf-$SOURCE_BRANCH"
mkdir -p $TMP_DIR

# Backup files
echo $'\nBackup files...'
for FILE in $CHANGE_FILES
do
    echo $FILE && cp $FILE "$TMP_DIR/"$(basename $FILE)
done

# Copy files
git checkout $TARGET_BRANCH
git pull origin $TARGET_BRANCH
echo $'\nCopy files'
for FILE in $CHANGE_FILES
do
    if [ ! -f "$FILE" ]; then
        mkdir -p $(dirname $FILE)
        touch "$FILE"
    fi
    cat "$TMP_DIR/"$(basename $FILE) >| $FILE
done
