#!/bin/sh
#mdf by lighta : 2015/04/01
# add group requirement (lock) and path permission check
# add java library path requirement to start jar

USER=$(whoami)
REQ_GROUP=lock
DIR=/run/lock #fedora21 path

if groups $USER | grep &>/dev/null "\b$REQ_GROUP\b"; then
	echo "Member of $REQ_GROUP chk pass"
else
	echo "You must be member of group $REQ_GROUP"
	sudo echo
	isSudo=$?
	if [[ "$isSudo" -ne 0 ]]; then
		  echo "This script must be run by root or a sudo'er"
		  exit 1
	fi
	echo "DEBUG adding yourself to group lock"
	sudo usermod -a -G $REQ_GROUP $USER
fi

touch $DIR/test >/dev/null 2>&1 ||  { echo "You need permission to writte into $DIR"; exit 1; }
rm $DIR/test
#should we change permission for him ?
#chown lock:lock $DIR -R

java -Djava.library.path=./ -jar Oscilloscope.jar
