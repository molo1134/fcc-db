#!/bin/sh
# (c) 2021 Chris Ruvolo K2CR.  GPLv3

BASEDIR="basedir"
rm -rf $BASEDIR

DATE=$(date "+%Y-%m-%d_%H:%M")
LOGFILE=log/${DATE}.log
mkdir -p log

echo "load.sh start" >> "$LOGFILE"

echo "Removing old DB files.." >> "$LOGFILE"

rm -f uls-app.sqlite
rm -f uls-lic.sqlite

mkdir -p $BASEDIR
echo "locking DB..." >> "$LOGFILE"
touch $BASEDIR/db.lock

echo "running uls-fetch..." >> "$LOGFILE"
./uls-fetch.sh -b $(realpath $BASEDIR) -m >> "$LOGFILE" 2>&1

echo ./import.pl -n -c conf-lic.ini $BASEDIR/weekly_l.zip >> "$LOGFILE"
./import.pl -n -c conf-lic.ini $BASEDIR/weekly_l.zip >> "$LOGFILE" 2>&1
echo $BASEDIR/weekly_l.zip > $BASEDIR/last_import_l
echo $BASEDIR/weekly_l.zip > $BASEDIR/last_weekly_l

echo ./import.pl -n -c conf-app.ini $BASEDIR/weekly_a.zip >> "$LOGFILE"
./import.pl -n -c conf-app.ini $BASEDIR/weekly_a.zip >> "$LOGFILE" 2>&1
echo $BASEDIR/weekly_a.zip > $BASEDIR/last_import_a
echo $BASEDIR/weekly_a.zip > $BASEDIR/last_weekly_a

# licenses start from sunday
for d in sun mon tue wed thu fri sat ; do 
	DAILYL="$BASEDIR/daily_l_$d.zip"
	if [ $DAILYL -nt $BASEDIR/weekly_l.zip ]; then
		echo ./import.pl -c conf-lic.ini $DAILYL >> "$LOGFILE"
		./import.pl -c conf-lic.ini $DAILYL >> "$LOGFILE" 2>&1
		echo $DAILYL > $BASEDIR/last_import_l
	fi
done

# applications start from saturday
for d in sat sun mon tue wed thu fri ; do 
	DAILYA="$BASEDIR/daily_a_$d.zip"
	if [ $DAILYA -nt $BASEDIR/weekly_a.zip ]; then
		echo ./import.pl -c conf-app.ini $DAILYA >> "$LOGFILE"
		./import.pl -c conf-app.ini $DAILYA >> "$LOGFILE" 2>&1
		echo $DAILYA > $BASEDIR/last_import_a
	fi
done

echo "removing db lock.." >> "$LOGFILE"
rm $BASEDIR/db.lock

echo "load.sh done" >> "$LOGFILE"
