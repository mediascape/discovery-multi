#!/bin/bash
InstallFoleder=.
Folder=/tmp #Folder=./application-context


##### check name of node.js
nodeCommand=node
if [ -f /usr/bin/nodejs ]; then
	nodeCommand=nodejs
fi
#####

if [ ! -d $Folder/discovery-self ];
then
	echo "Cloning discovery-self repository..."
	git clone https://github.com/mediascape/discovery-self
else
	echo "Checking for discovery-self repository updates..."
	cd $Folder/discovery-self
	git pull
	cd ..
fi

if [ ! -d $Folder/application-context ];
then
	echo "Cloning application-context repository..."
	git clone https://github.com/mediascape/application-context
else
	echo "Checking for application-context repository updates..."
	cd $Folder/application-context
	git pull
	cd ..
fi

if [ ! -d $Folder/discovery-multi ];
then
	echo "Cloning discovery-multi repository..."
	git clone https://github.com/mediascape/discovery-multi
else
	echo "Checking for discovery-multi repository updates..."
	cd $Folder/discovery-multi
	git pull
	cd ..
fi

cd $InstallFoleder

### TODO - maybe keep other old files??
if [ -d $InstallFoleder/deploy/ ]; then
	if [ -d $InstallFoleder/deploy/node_modules/ ]; then
		mkdir $InstallFoleder/temp/
		mkdir $InstallFoleder/temp/node_modules/
		mv $InstallFoleder/deploy/node_modules/* $InstallFoleder/temp/node_modules/
	fi
		rm -r $InstallFoleder/deploy/
fi

mkdir $InstallFoleder/deploy
echo "Copy needed files from repository..."
cp -R $Folder/application-context/Server/* $InstallFoleder/deploy/
cp -R $Folder/application-context/helloworld/* $InstallFoleder/deploy/www/
cp -R $Folder/discovery-multi/helloworld/js/mediascape/* $InstallFoleder/deploy/www/js/mediascape/
rm $InstallFoleder/deploy/www/deploy.sh
mkdir $InstallFoleder/deploy/www/js/
cp -R $Folder/application-context/API/* $InstallFoleder/deploy/www/js/
cp -R $Folder/discovery-self/API/mediascape/* $InstallFoleder/deploy/www/js/mediascape/
cp -R $Folder/discovery-multi/API/mediascape/* $InstallFoleder/deploy/www/js/mediascape/
cp -R $Folder/discovery-self/API/mediascape/lib/* $InstallFoleder/deploy/www/js/mediascape/lib/

if [ -d temp/node_modules/ ]; then
	mkdir $InstallFoleder/deploy/node_modules/
	mv $InstallFoleder/temp/node_modules/* $InstallFoleder/deploy/node_modules/
	rm -r $InstallFoleder/temp/
fi

cd $InstallFoleder/deploy/
echo "Starting setup Script..."
$nodeCommand setup.js
echo "Installing dependencies..."
npm install
echo "Start the Node.js Server..."
$nodeCommand index.js
