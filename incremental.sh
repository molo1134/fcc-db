#!/bin/sh
# (c) 2021 Chris Ruvolo K2CR.  GPLv3

BASEDIR="basedir"

./uls-fetch.sh -b `realpath $BASEDIR` -m

LASTWL=$(cat $BASEDIR/last_weekly_l)
LASTWA=$(cat $BASEDIR/last_weekly_a)

if [ $BASEDIR/weekly_l.zip -nt $LASTWL -o \
		$BASEDIR/weekly_a.zip -nt $LASTWA ]; then
	exec load.sh
fi

LASTL=$(cat $BASEDIR/last_import_l)
LASTA=$(cat $BASEDIR/last_import_a)

# licenses start from sunday
for d in sun mon tue wed thu fri sat ; do 
	DAILYL="$BASEDIR/daily_l_$d.zip"
	if [ $DAILYL -nt $LASTL ]; then
		echo ./import.pl -c conf-lic.ini $DAILYL
		./import.pl -c conf-lic.ini $DAILYL
		echo $DAILYL > $BASEDIR/last_import_l
	fi
done

# applications start from saturday
for d in sat sun mon tue wed thu fri ; do 
	DAILYA="$BASEDIR/daily_a_$d.zip"
	if [ $DAILYA -nt $LASTA ]; then
		echo ./import.pl -c conf-app.ini $DAILYA
		./import.pl -c conf-app.ini $DAILYA
		echo $DAILYA > $BASEDIR/last_import_a
	fi
done

