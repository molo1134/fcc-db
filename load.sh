#!/bin/sh
# (c) 2021 Chris Ruvolo K2CR.  GPLv3

BASEDIR="basedir"
rm -rf $BASEDIR

rm -f uls-app.sqlite
rm -f uls-lic.sqlite

mkdir -p $BASEDIR

./uls-fetch.sh -b `realpath $BASEDIR` -m

./import.pl -n -c conf-lic.ini $BASEDIR/weekly_l.zip
echo $BASEDIR/weekly_l.zip > $BASEDIR/last_import_l
echo $BASEDIR/weekly_l.zip > $BASEDIR/last_weekly_l

./import.pl -n -c conf-app.ini $BASEDIR/weekly_a.zip
echo $BASEDIR/weekly_a.zip > $BASEDIR/last_import_a
echo $BASEDIR/weekly_a.zip > $BASEDIR/last_weekly_a

# licenses start from sunday
for d in sun mon tue wed thu fri sat ; do 
	DAILYL="$BASEDIR/daily_l_$d.zip"
	if [ $DAILYL -nt $BASEDIR/weekly_l.zip ]; then
		echo ./import.pl -c conf-lic.ini $DAILYL
		./import.pl -c conf-lic.ini $DAILYL
		echo $DAILYL > $BASEDIR/last_import_l
	fi
done

# applications start from saturday
for d in sat sun mon tue wed thu fri ; do 
	DAILYA="$BASEDIR/daily_a_$d.zip"
	if [ $DAILYA -nt $BASEDIR/weekly_a.zip ]; then
		echo ./import.pl -c conf-app.ini $DAILYA
		./import.pl -c conf-app.ini $DAILYA
		echo $DAILYA > $BASEDIR/last_import_a
	fi
done

