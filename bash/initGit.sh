#!/bin/bash

TrgDir="myRepo"

mkdir /home/adam/$TrgDir

cd /home/adam/$TrgDir

git init

touch readme

git add .

git commit -m "init"

cd ../

git clone --bare ./$TrgDir "$TrgDir.git"

touch $TrgDir/git-daemon-export-ok

echo "Done [$TrgDir.git]"
