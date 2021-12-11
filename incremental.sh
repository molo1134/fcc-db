#!/bin/sh
# (c) 2021 Chris Ruvolo K2CR.  GPLv3

BASEDIR="basedir"

DATE=$(date "+%Y-%m-%d_%H:%M")
LOGFILE=log/${DATE}.log
mkdir -p log

echo "incremental.sh start" >> "$LOGFILE"

if [ -e $BASEDIR/db.lock ]; then
	echo "db locked, exiting" >> "$LOGFILE"
	exit 1
fi

echo "locking DB..." >> "$LOGFILE"
touch $BASEDIR/db.lock

echo "running uls-fetch..." >> "$LOGFILE"
./uls-fetch.sh -b $(realpath "$BASEDIR") -m >> "$LOGFILE" 2>&1

LASTWL=$BASEDIR/last_weekly_l
LASTWA=$BASEDIR/last_weekly_a

if [ "$BASEDIR/weekly_l.zip" -nt "$LASTWL" -o \
		$BASEDIR/weekly_a.zip -nt "$LASTWA" ]; then
	echo "unlocking DB..."
	rm -f $BASEDIR/db.lock
	echo "execing load.sh..." >> "$LOGFILE"
	exec ./load.sh
fi

LASTL=$(cat $BASEDIR/last_import_l)
LASTA=$(cat $BASEDIR/last_import_a)

# licenses start from sunday
for d in sun mon tue wed thu fri sat ; do 
	DAILYL="$BASEDIR/daily_l_$d.zip"
	if [ "$DAILYL" -nt "$LASTL" ]; then
		echo ./import.pl -c conf-lic.ini "$DAILYL" >> "$LOGFILE"
		./import.pl -c conf-lic.ini "$DAILYL" >> "$LOGFILE" 2>&1
		echo "$DAILYL" > $BASEDIR/last_import_l
	fi
done

# applications start from saturday
for d in sat sun mon tue wed thu fri ; do 
	DAILYA="$BASEDIR/daily_a_$d.zip"
	if [ "$DAILYA" -nt "$LASTA" ]; then
		echo ./import.pl -c conf-app.ini "$DAILYA" >> "$LOGFILE"
		./import.pl -c conf-app.ini "$DAILYA" >> "$LOGFILE" 2>&1
		echo "$DAILYA" > $BASEDIR/last_import_a
	fi
done

echo "removing db lock.." >> "$LOGFILE"
rm -f $BASEDIR/db.lock

echo "incremental.sh done" >> "$LOGFILE"
