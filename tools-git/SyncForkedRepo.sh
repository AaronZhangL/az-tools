#!/bin/bash

TMPFILE=`/usr/bin/mktemp -d`

while read row; do
  currentRepo=`echo ${row} | cut -d , -f 1`
  fromRepo=`echo ${row} | cut -d , -f 2`
  localDir=`echo ${row} | cut -d , -f 3`

  cd $TMPFILE
  echo "======================================================================="
  echo "currentRepo = [${currentRepo}]"
  echo "fromRepo = [${fromRepo}]"
  echo "localDir = [${localDir}]"
  echo "======================================================================="

  echo "Start to Sync forked repo => " + ${currentRepo}
  git clone ${currentRepo}

  cd ${localDir}

  # フォーク用に現在構成されたリモートリポジトリを一覧表示します。
  git remote -v

  # フォークと同期する、新しいリモート上流リポジトリを指定します。
  git remote add upstream ${fromRepo}

  # フォーク用に指定した新しい上流リポジトリを検証します。
  git remote -v

  # 上流リポジトリから、ブランチと各ブランチのコミットをフェッチします。
  # master へのコミットは、ローカルブランチ upstream/master に保管されます。
  git fetch upstream

  # フォークのローカル master ブランチをチェックアウトします。
  git checkout master

  # upstream/master からローカル master ブランチに変更をマージします。
  git merge upstream/master

  git push

done < sample.csv

echo "======================================================================="
echo "list all repos on temp direcotry"
echo "======================================================================="
ls -al $TMPFILE

echo "======================================================================="
echo "Delete temp directory"
echo "======================================================================="
rm -rf $TMPFILE
