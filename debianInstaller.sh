#!/bin/bash
#List of all varibles
TEMPFOLDER="/tmp/lockedFirefox"
OVERWRITE=""
REMOVE=""
FIRETAR="firefox.bz2"
SPACER="==================="
AUTOCONFIG=""
FIREFOXCFG=""
WHICH="which firefox"

#Desktop Entry
DESKTOP="[Desktop Entry]
Version=1.0
Name=Firefox
GenericName=Firefox
Comment=Firefox
Exec=/usr/bin/firefox
Terminal=false
Icon=/opt/firefox/browser/chrome/icons/default/default48.png
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;"

#Set config file names
read -p "Specify the location of autoconfig.js (Enter for default)" AUTOCONFIG
echo "autoconfig.js has been set as "$AUTOCONFIG""
read -p "Specify the location of firefox.cfg (Enter for default)" FIREFOXCFG
echo "firefox.cfg has been set as "$FIREFOXCFG""
echo "$SPACER"

#Remove firefox
read -p "Do you want to remove Firefox? (y)/n/stop: " REMOVE
case "$REMOVE" in
[yY] | [yY][eE][sS])
	echo "Removing Firefox..."
	sleep 1
	#sudo apt remove firefox
	#sudo rm "$WHICH"
	if [ -e ~/.local/share/applications/firefox.desktop ]
	then
		#rm ~/.local/share/applications/firefox.desktop
	fi
	;;
[nN] | [nN][oO])
	echo "WARNING: continuing without removing Firefox may cause problems"
	echo "Waiting 5 seconds..."
	sleep 5
	;;
[sS] | [sS][tT][oO][pP])
	echo "Stopping script"
	exit 1
	;;
*)
	echo "Removing Firefox..."
	sleep 1
	#sudo apt remove firefox
	;;
esac

#Make temp folder
if [ -d "$TEMPFOLDER" ]
then
	# echo "Temp folder exists"
	read -p "The temp folder already exist. Do you want to overwrite it? y/(n): " OVERWRITE
	case "$OVERWRITE"  in
	[yY] | [yY][eE][sS])
		echo "Overwriting old folder..."
		rm -Rf "$TEMPFOLDER"
		mkdir "$TEMPFOLDER"
		;;
	[nN] | [nN][oO])
		echo "Stopping script..."
		exit 1
		;;
	*)
		echo "Stopping script..."
		exit 1
		;;
	esac
else 
	# echo "Temp folder does NOT exist"
	mkdir "$TEMPFOLDER"
fi
OVERWRITE=""

#download firefox
echo "$SPACER"
echo "Downloading Firefox..."
echo "$SPACER"
wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" --trust-server-names -O "$TEMPFOLDER"/"$FIRETAR"

#Decompress Firefox
echo "$SPACER"
echo "Decompressing download..."
echo "$SPACER"
tar xvfj "$TEMPFOLDER"/"$FIRETAR" -C "$TEMPFOLDER"

#Configuring Firefox
if [ -z "$AUTOCONFIG" ]
	echo "$SPACER"
	echo "The autoconfig.js file has not been set. Skipping..."
	echo "$SPACER"
else
	echo "$SPACER"
	echo "Copying autoconfig.js..."
	echo "$SPACER"
	cp "$AUTOCONFIG" "$TEMPFOLDER"/firefox/defaults/pref/	
fi
if [ -z "FIREFOXCFG" ]
	echo "$SPACER"
	echo "The firefox.cfg file has not been set. Skipping..."
	echo "$SPACER"
else
	echo "$SPACER"
	echo "Copying autoconfig.js..."
	echo "$SPACER"
	cp "FIREFOXCFG" "$TEMPFOLDER"/firefox/	
fi

#Copy to /opt and install
if [ -d /opt/firefox ]
then
	read -p "A copy of Firefox already exists in your /opt folder. Do you want to overwrite it? y/(n):" OVERWRITE
	case "$OVERWRITE"  in
	[yY] | [yY][eE][sS])
		echo "Overwriting old folder..."
		#sudo rm -Rf /opt/firefox
		#mkdir "$TEMPFOLDER"
		;;
	[nN] | [nN][oO])
		echo "$SPACER"
		echo "Stopping script..."
		echo "$SPACER"
		exit 1
		;;
	*)
		echo "$SPACER"
		echo "Stopping script..."
		echo "$SPACER"
		exit 1
		;;
	esac
else
	echo "$SPACER"
	echo "Copying to /opt folder and making link..."
	echo "$SPACER"
	sudo mv "$TEMPFOLDER"/firefox /opt
	ln -s /opt/firefox/firefox /usr/bin/firefox
	touch ~/.local/share/applications/firefox.desktop
	echo "$DESKTOP" >> ~/.local/share/applications/firefox.desktop	
fi

#Cleaning up
echo "$SPACER"
echo "Cleaning up..."
echo "$SPACER"
rm -Rf "$TEMPFOLDER"

#Completed
echo "$SPACER"
echo "Firefox has been installed"
echo "$SPACER"