#!/bin/bash

if [ ${#@} -lt 2 ]; then
    echo 'Merge 2 branch in hard way (cherry-pick)'
    echo 'Usage: git-copy-files <source_branch> <target_branch>'
    exit 1
fi

if [ -z "$CHANGE_FILES" ]; then
    echo 'Please specifies change files'
    exit 1
fi

SOURCE_BRANCH=$1
TARGET_BRANCH=$2

git checkout $SOURCE_BRANCH
git pull origin $SOURCE_BRANCH

TMP_DIR="/tmp/gcf-$SOURCE_BRANCH"
mkdir -p $TMP_DIR

# Backup files
echo $'\nBackup files...'
for FILE in $CHANGE_FILES
do
    cp $FILE "$TMP_DIR/"$(basename $FILE)
done

# Copy files
git checkout $TARGET_BRANCH
git pull origin $TARGET_BRANCH
echo $'\nCopy files'
for FILE in $CHANGE_FILES
do
    cat "$TMP_DIR/"$(basename $FILE) >| $FILE
done
