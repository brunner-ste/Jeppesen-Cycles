mode 90,20
title Obstacle und AirNav Konvertiertool EuroAvionics GmbH
:: ###########################################################################################
:: BR, 29.12.2016
:: Rev.002
:: Geeignet für Konvertierung der Standard Obstacle Daten, Polen, Schweiz und Jeppesen AirNav
:: Obstacles_AA, EA, EUR, NA, SA und WW für 36er und 40er DB Versionen sowie WW für EN7
:: Konvertieren und ablegen der Obstalce Polen Daten
:: Konvertieren und ablegen der Jeppesen AirNav Daten 
:: Konvertieren und ablegen der SWISSTOPO Obstacle Daten, EN5 alt und neu sowie EN7
:: ###########################################################################################
:: BR, 04.01.2018
:: Rev.003
:: Cycle Updates new und en7 inkl. Standard appMatrizen für die separaten NG Vector Maps
:: U:\en5data\jeppesen\_ww\_appMatrix
:: ###########################################################################################
:: BR, 19.01.2018
:: Rev.004
:: Reporting Point appMatrix Unterscheidung EN5/EN7
:: ###########################################################################################
:: BR, 26.01.2018
:: Rev.005
:: Letzte Anpassungen NG App Matrix, EN7 wieder ohne
:: ###########################################################################################
:: BR, 16.07.2018
:: Rev.006
:: Job Checks, Reporting Point Vorab Check, SQLScripts Automatisierung, Versiontracker
:: --> Vollautomatisierung der Jeppesen und Obstacle Cycle Updates  
:: ###########################################################################################

@echo off
cls

G:
echo.
echo                   ###################################################
echo                   # Vor Start der Konvertierung alle Jobs anpassen! #
echo                   ###################################################
echo.
echo AIRAC Cycle festlegen
set /p CYCLE=AIRAC Cycle (z.B. 1610):
echo.
echo Daten fuer *.toc und Versiontracker
set /p VALID_FROM_TOC=Valid from (YYYY-MM-DD e.g. 2016-09-15):
set /p VALID_TO_TOC=Valid to (YYYY-MM-DD e.g. 2016-09-15):
set /p REMOVE_ON_TOC=Remove on (+3 Month after Validitiy!  YYYY-MM-DD e.g. 2016-12-15):

cls

echo.
echo UNIX Timestamps fuer Versiontracker eingeben:
start https://www.unixtimestamp.com/index.php
echo.
set /p UNIX_VALID_FROM=Valid from: %VALID_FROM_TOC% (00:00:00 Uhr):
echo.
set /p UNIX_VALID_TO=Valid to: %VALID_TO_TOC% (23:59:59 Uhr):
echo.
set /p UNIX_REMOVE_ON=Remove on: %REMOVE_ON_TOC% (00:00:00 Uhr):

cls

echo.
echo Sind die Daten korrekt?
echo.
echo Cycle = %Cycle%
echo.
echo Valid from = %VALID_FROM_TOC%
echo Valid from = %UNIX_VALID_FROM%
echo.
echo Valid to = %VALID_TO_TOC%
echo Valid to = %UNIX_VALID_TO%
echo. 
echo Remove on = %REMOVE_ON_TOC%
echo Remove on = %UNIX_REMOVE_ON%
echo.
echo Weiter mit "j" oder Abbruch mit "n" und [ENTER] ...
set /p AUSWAHL=
for %%A in (J N) Do if /i '%AUSWAHL%'=='%%A' goto :Wahl%%A
goto ENDE 
:WahlN
goto ENDE
:WahlJ

cls

:: Pfad zu den lokalen Datenbanken
set DB_OLD=G:\Jeppesen\1.39.36\db
set DB_NEW=G:\Jeppesen\1.39.40\db
set DB_EN7=G:\Jeppesen\2.00.29\db

:: Arbeitspfad
set WORK_PATH=G:\jeppesen

:: Pfad zum Vektor Server
set VECTOR_SERVER=U:\en5data

:: Pfad zum Kunden Server
set KUNDEN_SERVER=Z:\en5customer

:: Pfad zum DTM
set DTM_PATH=G:\jeppesen\DTM7_1.02.02\
set DTM_PATH_LIB=libraries\msys\bin

:: Pfad zu 7Zip Command Line Tool
set ZIP_PATH=G:\jeppesen\

:: Pfad zu Dos2UNIX Zeilenende Tool
set LINE_PATH=G:\jeppesen\

:: Pfad zu Map2Pack
set PACK_PATH=G:\jeppesen\

:: Pfad zum DB Tool
set DBTOOL_PATH=G:\jeppesen\DBTOOL

:: Pfad zur MapConversion
set CONV_PATH=G:\jeppesen\MCS7_1.02.02\

:: Pfad zur Rep Points MCS
set CONV_REP=G:\jeppesen\MCS5_1.04.06\

:: Pfad zu den Konvertierjobs
set JOB_PATH=G:\jeppesen\tools\

::Pfad zu den Kartendaten fuer das tar.gz Archiv
set DATA_PATH=G:\jeppesen\1.39.40\db\vector

::-----------------------------------------------::
:: Konvertierung der Obstacle Daten ::
::-----------------------------------------------::

mode 180,30

:: Obstacles OLD Database Version
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_AA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_EA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_EUR_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_NA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_SA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_WW_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\ODB_POL_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\old\che_hindernissdaten.xml

:: Obstacles NEW Database Version
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_AA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_EA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_EUR_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_NA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_SA_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\ODB_WW_toEN5.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\che_hindernissdaten.xml

:: Jeppesen AirNav Database EN 5
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\new\A424_V15.xml

:: VFRReporting Points für EN5 und EN7
%CONV_REP%\MapPrepare.exe --autolog %JOB_PATH%\new\VFRREPPTS_toEN5.xml

:: EN 7 Konvertierungen Obstacles WW, Swisstopo
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\en7\che_hindernissdaten_EN7.xml
%CONV_PATH%\MapPrepare.exe --autolog %JOB_PATH%\en7\ODB_WW_toEN7.xml

::-------------------------------------------------------------------------------::
:: Job Checker, sucht nach exit codes, leitet diese um zum checken.
::-------------------------------------------------------------------------------::

findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_AA_toEN5.xml.log >%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_EA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_EUR_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_NA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_SA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_WW_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\ODB_POL_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\old\che_hindernissdaten.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt

findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_AA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_EA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_EUR_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_NA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_SA_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\ODB_WW_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\new\che_hindernissdaten.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt

findstr /i /g:checktools.txt %JOB_PATH%\new\A424_V15.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt

findstr /i /g:checktools.txt %JOB_PATH%\new\VFRREPPTS_toEN5.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt

findstr /i /g:checktools.txt %JOB_PATH%\en7\che_hindernissdaten_EN7.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
echo. >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt
findstr /i /g:checktools.txt %JOB_PATH%\en7\ODB_WW_toEN7.xml.log >>%JOB_PATH%\Job_Check_Cycle_%Cycle%.txt

mode 90,20

::----------------------------::
:: Alte tmp Ordner entfernen
::----------------------------::

echo.
echo Temporaere Ordner entfernen...
rd /s /q %DB_NEW%\tmp\
rd /s /q %DB_OLD%\tmp\
rd /s /q %DB_EN7%\tmp\

::----------------------------::
::----------------------------::
:: Ab hier Versionsspezifisch ::
::----------------------------::
::----------------------------::

::----------------------------------------------------::
:: Asia Australia NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\aa_new\db\SQL\
mkdir %DB_NEW%\tmp\aa_new\db\vector\obstacle_aa

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_aa %DB_NEW%\tmp\aa_new\db\vector\obstacle_aa /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_AA* %DB_NEW%\tmp\aa_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\aa_new\db\vector\obstacle_aa

cd %DB_NEW%\tmp\aa_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_aa1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_aa1
ren e_aa1.gz e_aa1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\aa_new\e_aa1.toc echo obstacle_aa
>> %DB_NEW%\tmp\aa_new\e_aa1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\aa_new\e_aa1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\aa_new\e_aa1.toc echo Update AtStart
>> %DB_NEW%\tmp\aa_new\e_aa1.toc echo e_aa1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\aa_new\e_aa1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_AA_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\aa_new\e_aa1.dat %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\aa_new\e_aa1.toc %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_aa.create.sql %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_aa.data.sql %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_aa

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_aa.tar.gz %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\

::----------------------------------------------------::
:: Asia Australia ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\aa_old\db\SQL\
mkdir %DB_OLD%\tmp\aa_old\db\vector\obstacle_aa

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_aa %DB_OLD%\tmp\aa_old\db\vector\obstacle_aa /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_AA* %DB_OLD%\tmp\aa_old\db\SQL\ /e

cd %DB_OLD%\tmp\aa_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_aa1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_aa1
ren e_aa1.gz e_aa1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\aa_old\e_aa1.toc echo obstacle_aa
>> %DB_OLD%\tmp\aa_old\e_aa1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\aa_old\e_aa1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\aa_old\e_aa1.toc echo Update AtStart
>> %DB_OLD%\tmp\aa_old\e_aa1.toc echo e_aa1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\aa_old\e_aa1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_AA_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\aa_old\e_aa1.dat %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\aa_old\e_aa1.toc %VECTOR_SERVER%\asiaaustr\all\obstacles\20%CYCLE%00\%CYCLE%_cyc


::----------------------------------------------------::
:: Europa Afrika NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\ea_new\db\SQL\
mkdir %DB_NEW%\tmp\ea_new\db\vector\obstacle_ea

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_ea %DB_NEW%\tmp\ea_new\db\vector\obstacle_ea /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_EA* %DB_NEW%\tmp\ea_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\ea_new\db\vector\obstacle_ea

cd %DB_NEW%\tmp\ea_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_ea1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_ea1
ren e_ea1.gz e_ea1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\ea_new\e_ea1.toc echo obstacle_ea
>> %DB_NEW%\tmp\ea_new\e_ea1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\ea_new\e_ea1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\ea_new\e_ea1.toc echo Update AtStart
>> %DB_NEW%\tmp\ea_new\e_ea1.toc echo e_ea1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\ea_new\e_ea1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_EA_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\ea_new\e_ea1.dat %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\ea_new\e_ea1.toc %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_ea.create.sql %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_ea.data.sql %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_ea

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_ea.tar.gz %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\


::----------------------------------------------------::
:: Europa Afrika ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\ea_old\db\SQL\
mkdir %DB_OLD%\tmp\ea_old\db\vector\obstacle_ea

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_ea %DB_OLD%\tmp\ea_old\db\vector\obstacle_ea /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_EA* %DB_OLD%\tmp\ea_old\db\SQL\ /e

cd %DB_OLD%\tmp\ea_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_ea1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_ea1
ren e_ea1.gz e_ea1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\ea_old\e_ea1.toc echo obstacle_ea
>> %DB_OLD%\tmp\ea_old\e_ea1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\ea_old\e_ea1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\ea_old\e_ea1.toc echo Update AtStart
>> %DB_OLD%\tmp\ea_old\e_ea1.toc echo e_ea1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\ea_old\e_ea1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_EA_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\ea_old\e_ea1.dat %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\ea_old\e_ea1.toc %VECTOR_SERVER%\eurafrme\all\obstacle\20%CYCLE%00\%CYCLE%_cyc


::----------------------------------------------------::
:: Europa NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\eur_new\db\SQL\
mkdir %DB_NEW%\tmp\eur_new\db\vector\obstacle_eur

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_eur %DB_NEW%\tmp\eur_new\db\vector\obstacle_eur /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_EUR* %DB_NEW%\tmp\eur_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\eur_new\db\vector\obstacle_eur

cd %DB_NEW%\tmp\eur_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar _eur1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz _eur1
ren _eur1.gz _eur1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\eur_new\_eur1.toc echo obstacle_eur
>> %DB_NEW%\tmp\eur_new\_eur1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\eur_new\_eur1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\eur_new\_eur1.toc echo Update AtStart
>> %DB_NEW%\tmp\eur_new\_eur1.toc echo _eur1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\eur_new\_eur1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_EUR_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\eur_new\_eur1.dat %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\eur_new\_eur1.toc %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_eur.create.sql %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_eur.data.sql %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_eur

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_eur.tar.gz %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\


::----------------------------------------------------::
:: Europa ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\eur_old\db\SQL\
mkdir %DB_OLD%\tmp\eur_old\db\vector\obstacle_eur

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_eur %DB_OLD%\tmp\eur_old\db\vector\obstacle_eur /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_EUR* %DB_OLD%\tmp\eur_old\db\SQL\ /e

cd %DB_OLD%\tmp\eur_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar _eur1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz _eur1
ren _eur1.gz _eur1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\eur_old\_eur1.toc echo obstacle_eur
>> %DB_OLD%\tmp\eur_old\_eur1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\eur_old\_eur1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\eur_old\_eur1.toc echo Update AtStart
>> %DB_OLD%\tmp\eur_old\_eur1.toc echo _eur1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\eur_old\_eur1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_EUR_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\eur_old\_eur1.dat %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\eur_old\_eur1.toc %VECTOR_SERVER%\europe\all\jepp_odb\20%CYCLE%00\%CYCLE%_cyc


::----------------------------------------------------::
:: Nord Amerika NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\na_new\db\SQL\
mkdir %DB_NEW%\tmp\na_new\db\vector\obstacle_na

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_na %DB_NEW%\tmp\na_new\db\vector\obstacle_na /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_NA* %DB_NEW%\tmp\na_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\na_new\db\vector\obstacle_na

cd %DB_NEW%\tmp\na_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_na1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_na1
ren e_na1.gz e_na1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\na_new\e_na1.toc echo obstacle_na
>> %DB_NEW%\tmp\na_new\e_na1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\na_new\e_na1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\na_new\e_na1.toc echo Update AtStart
>> %DB_NEW%\tmp\na_new\e_na1.toc echo e_na1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\na_new\e_na1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_NA_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\na_new\e_na1.dat %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\na_new\e_na1.toc %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_na.create.sql %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_na.data.sql %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_na

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_na.tar.gz %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\


::----------------------------------------------------::
:: Nord Amerika ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\na_old\db\SQL\
mkdir %DB_OLD%\tmp\na_old\db\vector\obstacle_na

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_na %DB_OLD%\tmp\na_old\db\vector\obstacle_na /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_NA* %DB_OLD%\tmp\na_old\db\SQL\ /e

cd %DB_OLD%\tmp\na_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_na1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_na1
ren e_na1.gz e_na1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\na_old\e_na1.toc echo obstacle_na
>> %DB_OLD%\tmp\na_old\e_na1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\na_old\e_na1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\na_old\e_na1.toc echo Update AtStart
>> %DB_OLD%\tmp\na_old\e_na1.toc echo e_na1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\na_old\e_na1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_NA_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\na_old\e_na1.dat %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\na_old\e_na1.toc %VECTOR_SERVER%\namerika\all\obstacle\20%CYCLE%00\%CYCLE%_cyc


::----------------------------------------------------::
:: Sued Amerika NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\sa_new\db\SQL\
mkdir %DB_NEW%\tmp\sa_new\db\vector\obstacle_sa

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_sa %DB_NEW%\tmp\sa_new\db\vector\obstacle_sa /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_SA* %DB_NEW%\tmp\sa_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\sa_new\db\vector\obstacle_sa

cd %DB_NEW%\tmp\sa_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_sa1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_sa1
ren e_sa1.gz e_sa1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\sa_new\e_sa1.toc echo obstacle_sa
>> %DB_NEW%\tmp\sa_new\e_sa1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\sa_new\e_sa1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\sa_new\e_sa1.toc echo Update AtStart
>> %DB_NEW%\tmp\sa_new\e_sa1.toc echo e_sa1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\sa_new\e_sa1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_SA_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\sa_new\e_sa1.dat %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\sa_new\e_sa1.toc %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_sa.create.sql %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_sa.data.sql %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_sa

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_sa.tar.gz %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\


::----------------------------------------------------::
:: Sued Amerika ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\sa_old\db\SQL\
mkdir %DB_OLD%\tmp\sa_old\db\vector\obstacle_sa

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_sa %DB_OLD%\tmp\sa_old\db\vector\obstacle_sa /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_SA* %DB_OLD%\tmp\sa_old\db\SQL\ /e

cd %DB_OLD%\tmp\sa_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_sa1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_sa1
ren e_sa1.gz e_sa1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\sa_old\e_sa1.toc echo obstacle_sa
>> %DB_OLD%\tmp\sa_old\e_sa1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\sa_old\e_sa1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\sa_old\e_sa1.toc echo Update AtStart
>> %DB_OLD%\tmp\sa_old\e_sa1.toc echo e_sa1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\sa_old\e_sa1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_SA_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\sa_old\e_sa1.dat %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\sa_old\e_sa1.toc %VECTOR_SERVER%\samerika\all\obstacles\20%CYCLE%00\%CYCLE%_cyc


::----------------------------------------------------::
:: Welt NEUE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\ww_new\db\SQL\
mkdir %DB_NEW%\tmp\ww_new\db\vector\obstacle_ww

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obstacle_ww %DB_NEW%\tmp\ww_new\db\vector\obstacle_ww /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_WW* %DB_NEW%\tmp\ww_new\db\SQL\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\obstacles\appMatrix.json %DB_NEW%\tmp\ww_new\db\vector\obstacle_ww

cd %DB_NEW%\tmp\ww_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_ww1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_ww1
ren e_ww1.gz e_ww1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\ww_new\e_ww1.toc echo obstacle_ww
>> %DB_NEW%\tmp\ww_new\e_ww1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\ww_new\e_ww1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\ww_new\e_ww1.toc echo Update AtStart
>> %DB_NEW%\tmp\ww_new\e_ww1.toc echo e_ww1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\ww_new\e_ww1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_WW_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\ww_new\e_ww1.dat %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\ww_new\e_ww1.toc %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obstacle_ww.create.sql %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obstacle_ww.data.sql %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obstacle_ww

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obstacle_ww.tar.gz %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\


::----------------------------------------------------::
:: Welt ALTE Datenbank Version ::
::----------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\ww_old\db\SQL\
mkdir %DB_OLD%\tmp\ww_old\db\vector\obstacle_ww

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obstacle_ww %DB_OLD%\tmp\ww_old\db\vector\obstacle_ww /e
xcopy %DB_OLD%\SQL\LABELS_OBSTACLE_WW* %DB_OLD%\tmp\ww_old\db\SQL\ /e

cd %DB_OLD%\tmp\ww_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_ww1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz e_ww1
ren e_ww1.gz e_ww1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\ww_old\e_ww1.toc echo obstacle_ww
>> %DB_OLD%\tmp\ww_old\e_ww1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\ww_old\e_ww1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\ww_old\e_ww1.toc echo Update AtStart
>> %DB_OLD%\tmp\ww_old\e_ww1.toc echo e_ww1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\ww_old\e_ww1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_WW_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\ww_old\e_ww1.dat %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\ww_old\e_ww1.toc %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc


::---------------------------::
:: Welt EN7 Version ::
::---------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\en7
mkdir %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\en7\obstacle_ww

mkdir %DB_EN7%\tmp\ww_en7\db\data\SQL\
mkdir %DB_EN7%\tmp\ww_en7\db\data\vector\obstacle_ww

:: Daten zum packen zusammenkopieren :: ACHTUNG DB_NEW für SQL verwenden!!!
xcopy %DB_EN7%\data\vector\obstacle_ww %DB_EN7%\tmp\ww_en7\db\data\vector\obstacle_ww /e
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_WW* %DB_EN7%\tmp\ww_en7\db\data\SQL\ /e

cd %DB_EN7%\tmp\ww_en7
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar e_ww1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_EN7%\tmp\ww_en7\e_ww1.toc echo obstacle_ww
>> %DB_EN7%\tmp\ww_en7\e_ww1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_EN7%\tmp\ww_en7\e_ww1.toc echo %REMOVE_ON_TOC%
>> %DB_EN7%\tmp\ww_en7\e_ww1.toc echo Update AtStart
>> %DB_EN7%\tmp\ww_en7\e_ww1.toc echo e_ww1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_EN7%\tmp\ww_en7\e_ww1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_WW_%CYCLE%_EN7.zip @list.txt
move *.zip %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_EN7%\tmp\ww_en7\e_ww1.dat %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7
move %DB_EN7%\tmp\ww_en7\e_ww1.toc %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7

:: MapPack und auf Server ablegen
xcopy %DB_EN7%\tmp\ww_en7\db\data\vector\obstacle_ww %VECTOR_SERVER%\world\obstacles\20%CYCLE%00\en7\obstacle_ww /s


::-------------------------------------------------::
:: Swisstopo NEUE Datenbank Version ::
::-------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\sqlscripts

mkdir %DB_NEW%\tmp\swiss_new\db\SQL\
mkdir %DB_NEW%\tmp\swiss_new\db\vector\obst_swisst

:: Daten zum packen zusammenkopieren
xcopy %DB_NEW%\vector\obst_swisst %DB_NEW%\tmp\swiss_new\db\vector\obst_swisst /e
xcopy %DB_NEW%\SQL\LABELS_OBST_SWISST* %DB_NEW%\tmp\swiss_new\db\SQL\ /e

cd %DB_NEW%\tmp\swiss_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar isst1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz isst1
ren isst1.gz isst1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_NEW%\tmp\swiss_new\isst1.toc echo obst_swisst
>> %DB_NEW%\tmp\swiss_new\isst1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_NEW%\tmp\swiss_new\isst1.toc echo %REMOVE_ON_TOC%
>> %DB_NEW%\tmp\swiss_new\isst1.toc echo Update AtStart
>> %DB_NEW%\tmp\swiss_new\isst1.toc echo isst1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_NEW%\tmp\swiss_new\isst1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_CHE_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_NEW%\tmp\swiss_new\isst1.dat %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new
move %DB_NEW%\tmp\swiss_new\isst1.toc %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_new

:: Scripte aus der 40er Konvertierung ablegen
echo sqlscripts auf dem Server ablegen
xcopy %DB_NEW%\vector\labels_obst_swisst.create.sql %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\sqlscripts
xcopy %DB_NEW%\vector\labels_obst_swisst.data.sql %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\sqlscripts

:: Dieser Schritt ist nur für die 40er Version notwendig! Nicht bei den 36er anwenden!!
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=obst_swisst

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\obst_swisst.tar.gz %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\


::-------------------------------------------------::
:: Swisstopo ALTE Datenbank Version ::
::-------------------------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc

mkdir %DB_OLD%\tmp\swiss_old\db\SQL\
mkdir %DB_OLD%\tmp\swiss_old\db\vector\obst_swisst

:: Daten zum packen zusammenkopieren
xcopy %DB_OLD%\vector\obst_swisst %DB_OLD%\tmp\swiss_old\db\vector\obst_swisst /e
xcopy %DB_OLD%\SQL\LABELS_OBST_SWISST* %DB_OLD%\tmp\swiss_old\db\SQL\ /e

cd %DB_OLD%\tmp\swiss_old
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar isst1
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz isst1
ren isst1.gz isst1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_OLD%\tmp\swiss_old\isst1.toc echo obst_swisst
>> %DB_OLD%\tmp\swiss_old\isst1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_OLD%\tmp\swiss_old\isst1.toc echo %REMOVE_ON_TOC%
>> %DB_OLD%\tmp\swiss_old\isst1.toc echo Update AtStart
>> %DB_OLD%\tmp\swiss_old\isst1.toc echo isst1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_OLD%\tmp\swiss_old\isst1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_CHE_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_OLD%\tmp\swiss_old\isst1.dat %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc
move %DB_OLD%\tmp\swiss_old\isst1.toc %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc


::----------------------::
:: Swisstopo EN7 ::
::----------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\en7
mkdir %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\en7\obst_swisst

mkdir %DB_EN7%\tmp\swiss_en7\db\data\SQL\
mkdir %DB_EN7%\tmp\swiss_en7\db\data\vector\obst_swisst

:: Daten zum packen zusammenkopieren :: ACHTUNG DB_NEW für SQL verwenden!!!
xcopy %DB_EN7%\data\vector\obst_swisst %DB_EN7%\tmp\swiss_en7\db\data\vector\obst_swisst /e
xcopy %DB_NEW%\SQL\LABELS_OBST_SWISST* %DB_EN7%\tmp\swiss_en7\db\data\SQL\ /e

cd %DB_EN7%\tmp\swiss_en7
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar isst1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

echo TOC Erstellung:
> %DB_EN7%\tmp\swiss_en7\isst1.toc echo obst_swisst
>> %DB_EN7%\tmp\swiss_en7\isst1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_EN7%\tmp\swiss_en7\isst1.toc echo %REMOVE_ON_TOC%
>> %DB_EN7%\tmp\swiss_en7\isst1.toc echo Update AtStart
>> %DB_EN7%\tmp\swiss_en7\isst1.toc echo isst1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_EN7%\tmp\swiss_en7\isst1.toc

:: Fertige Daten abschließend packen und auf Server laden
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Obstacles_CHE_%CYCLE%_EN7.zip @list.txt
move *.zip %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\

:: DAT und TOC auf Server kopieren
move %DB_EN7%\tmp\swiss_en7\isst1.dat %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7
move %DB_EN7%\tmp\swiss_en7\isst1.toc %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\%CYCLE%_cyc_en7

:: MapPack und auf Server ablegen
xcopy %DB_EN7%\tmp\swiss_en7\db\data\vector\obst_swisst %VECTOR_SERVER%\europe\schweiz\all\obstacles\20%CYCLE%00\en7\obst_swisst /e


::---------------------------------::
:: Obstacle Ablage Polen ::
::---------------------------------::

:: Ordner anlegen
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\vector\obstacle_pol
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\SQL
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\vector\jeppesen
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\vector\vfrreppts
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\SQL
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\upd\db\vector\obstacle_pol
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\upd\db\SQL\scripts
mkdir %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\sqlscripts

:: Vektor Daten ablegen fuer DTM_old und LPR Update --> DTM_new mit MapPacks werden später abgelegt
xcopy %DB_OLD%\vector\obstacle_pol %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\vector\obstacle_pol /e
xcopy %DB_OLD%\vector\obstacle_pol %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\upd\db\vector\obstacle_pol /e

:: Scripte aus der Konvertierung ablegen
xcopy %DB_OLD%\vector\labels_obstacle_pol.create.sql %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\sqlscripts
xcopy %DB_OLD%\vector\labels_obstacle_pol.data.sql %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\sqlscripts

:: Create Scripte in SQL Ordner ablegen
:: xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\lpr\scripts\* %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\upd\db\SQL\scripts

::---------------------------------::
:: Jeppesen Air Nav Database ::
::---------------------------------::

:: Ordner anlegen
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\jeppesen
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\vfrreppts
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\SQL
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\jeppesen
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\vfrreppts
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\SQL
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\vector\jeppesen
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\vector\vfrreppts
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\SQL
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\en7\vfrreppts
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\vector\jeppesen
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\new
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\old
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts
mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\en7

:: Aufraeumen
rd /s /q %DB_OLD%\vector\jeppesen
rd /s /q %DB_NEW%\vector\jeppesen
rd /s /q %DB_EN7%\tmp\jepp
mkdir %DB_NEW%\vector\jeppesen
mkdir %DB_OLD%\vector\jeppesen
mkdir %DB_EN7%\tmp\jepp

:: Jeppesen sqlscripts zusammenkopieren
move %WORK_PATH%\%CYCLE%\AirNav\1_39_40\A424_V15\jeppesen\labels_jeppesen* %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts
xcopy %WORK_PATH%\%CYCLE%\AirNav\1_39_40\A424_V15\TableData\AirInfo\Jepp* %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts

:: Versiontracker sqlscript erzeugen
echo INSERT INTO VersionTracker (NAME, UPDATE, UPDATEMODE, DESCRIPTON, VALIDFROM, VALIDTO, REMOVEON, VERSION) VALUES ('jeppesen', FALSE, 2, '', %UNIX_VALID_FROM%, %UNIX_VALID_TO%, %UNIX_REMOVE_ON%, 0); >%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts\version_jeppesen.data.sql
%LINE_PATH%\dos2unix.exe %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts\version_jeppesen.data.sql

:: Jeppesen Daten zusammenkopieren
xcopy %WORK_PATH%\%CYCLE%\AirNav\1_39_40\A424_V15\jeppesen %DB_NEW%\vector\jeppesen\ /e

:: Karten Daten hochkopieren für Jeppesen Update
xcopy %DB_NEW%\vector\jeppesen %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\vector\jeppesen\ /e

:: Karten Daten hochkopieren für Cycle Old und New inkl. App Matrix für NG Maps
xcopy %DB_NEW%\vector\jeppesen %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\jeppesen\ /e
xcopy %DB_NEW%\vector\jeppesen %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\jeppesen\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\jeppesen\appMatrix.json %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\jeppesen\

:: MapPacks erzeugen für Cycle EN7
%PACK_PATH%\map2pack.exe %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\jeppesen %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\vector\jeppesen

:: MapPacks en7 Extra ablegen
xcopy %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\vector\jeppesen %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\en7\jeppesen\ /e

:: Karten Daten hochkopieren für LPR DTM Update
xcopy %DB_NEW%\vector\jeppesen %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\vector\jeppesen\ /e

echo TOC Erstellung:
> %DB_EN7%\tmp\jepp\esen1.toc echo jeppesen
>> %DB_EN7%\tmp\jepp\esen1.toc echo %VALID_FROM_TOC% %VALID_TO_TOC%
>> %DB_EN7%\tmp\jepp\esen1.toc echo %REMOVE_ON_TOC%
>> %DB_EN7%\tmp\jepp\esen1.toc echo Update Force
>> %DB_EN7%\tmp\jepp\esen1.toc echo esen1.dat

::UNIX Zeilenende erzeugen
%LINE_PATH%\dos2unix.exe %DB_EN7%\tmp\jepp\esen1.toc

:: TOC Dateien auf Server kopieren
xcopy %DB_EN7%\tmp\jepp\esen1.toc %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc
xcopy %DB_EN7%\tmp\jepp\esen1.toc %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new
xcopy %DB_EN7%\tmp\jepp\esen1.toc %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7

:: Daten packen und auf Server hochladen
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=jeppesen

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\jeppesen.tar.gz %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\

::----------------------::
:: Reporting Points ::
::----------------------::

rd /s /q %DB_NEW%\vector\vfrreppts
mkdir %DB_NEW%\vector\vfrreppts

:: Ordner anlegen
mkdir %DB_NEW%\tmp\vfr_sql\sqlscripts
mkdir %DB_OLD%\tmp\vfr_sql\sqlscripts

mkdir %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\sqlscripts

:: sqlscripts zusammenkopieren
del   %WORK_PATH%\%CYCLE%\Rep\VFRREPPTS_toEN5\vfrreppts\labels_vfrreppts.create*
move  %WORK_PATH%\%CYCLE%\Rep\VFRREPPTS_toEN5\vfrreppts\labels_vfrreppts.data* %DB_NEW%\tmp\vfr_sql\sqlscripts
xcopy %WORK_PATH%\%CYCLE%\Rep\VFRREPPTS_toEN5\TableData\reporting* %DB_NEW%\tmp\vfr_sql\sqlscripts
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\labels_vfrreppts.create.sql %DB_NEW%\tmp\vfr_sql\sqlscripts
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\create_sql_new\* %DB_NEW%\tmp\vfr_sql\sqlscripts

xcopy %DB_NEW%\tmp\vfr_sql\sqlscripts\labels_vfrreppts.data* %DB_OLD%\tmp\vfr_sql\sqlscripts
xcopy %WORK_PATH%\%CYCLE%\Rep\VFRREPPTS_toEN5\TableData\reporting* %DB_OLD%\tmp\vfr_sql\sqlscripts
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\labels_vfrreppts.create.sql %DB_OLD%\tmp\vfr_sql\sqlscripts
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\create_sql_old\* %DB_OLD%\tmp\vfr_sql\sqlscripts

:: Data Scripts VFR Reporting Points anpassen alte und neue DB Version, neue Version wird auf Server abgelegt

cd %DB_NEW%\tmp\vfr_sql\sqlscripts

ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints_country.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints_country.data.sql
Ren tmpfile.txt reportingPoints_country.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints_country.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints1.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints1.data.sql
Ren tmpfile.txt reportingPoints1.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints1.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints_type.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints_type.data.sql
Ren tmpfile.txt reportingPoints_type.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints_type.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Labels VFR Reporting Points NEW
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
more +2 labels_vfrreppts.data.sql > labels_vfrreppts.data.sql.tmp
ECHO DELETE FROM labels_vfrreppts;>tmpline.txt
ECHO #!SET DEFAULT CHARACTER SET UTF8>>tmpline.txt
copy /b tmpline.txt + labels_vfrreppts.data.sql.tmp tmpfile.txt
del tmpline.txt
del labels_vfrreppts.data.sql
del labels_vfrreppts.data.sql.tmp
Ren tmpfile.txt labels_vfrreppts.data.sql
%LINE_PATH%\dos2unix.exe labels_vfrreppts.data.sql

xcopy %DB_NEW%\tmp\vfr_sql\sqlscripts\rep* %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\sqlscripts
xcopy %DB_NEW%\tmp\vfr_sql\sqlscripts\labels_vfr* %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\sqlscripts

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Alte DB Version
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cd %DB_OLD%\tmp\vfr_sql\sqlscripts

ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints_country.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints_country.data.sql
Ren tmpfile.txt reportingPoints_country.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints_country.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints1.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints1.data.sql
Ren tmpfile.txt reportingPoints1.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints1.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO #!SET DEFAULT CHARACTER SET UTF8>tmpline.txt
copy /b tmpline.txt + reportingPoints_type.data.sql tmpfile.txt
del tmpline.txt
del reportingPoints_type.data.sql
Ren tmpfile.txt reportingPoints_type.data.sql
%LINE_PATH%\dos2unix.exe reportingPoints_type.data.sql
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Labels VFR Reporting Points OLD
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
more +2 labels_vfrreppts.data.sql > labels_vfrreppts.data.sql.tmp
ECHO DELETE FROM labels_vfrreppts;>tmpline.txt
ECHO #!SET DEFAULT CHARACTER SET UTF8>>tmpline.txt
copy /b tmpline.txt + labels_vfrreppts.data.sql.tmp tmpfile.txt
del tmpline.txt
del labels_vfrreppts.data.sql
del labels_vfrreppts.data.sql.tmp
Ren tmpfile.txt labels_vfrreppts.data.sql
%LINE_PATH%\dos2unix.exe labels_vfrreppts.data.sql

:: SQLs erzeugen, zusammen mit Versiontracker, Jeppesen und LPR Polen Obstacles (LPR nur alte Version)
xcopy %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts\* %DB_NEW%\tmp\vfr_sql\sqlscripts /y
xcopy %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\sqlscripts\* %DB_OLD%\tmp\vfr_sql\sqlscripts /y
xcopy %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\sqlscripts\* %DB_OLD%\tmp\vfr_sql\sqlscripts

:: Tabellen Version 25 --> new
set SQLSCRIPTS=%DB_NEW%\tmp\vfr_sql\
rd /q /s %SQLSCRIPTS%\SQL

%DBTOOL_PATH%\dbtool25.exe --with-db-version 25 -r %SQLSCRIPTS% -e  %DBTOOL_PATH%\En5Db.createdb.sql
FOR %%a in (%SQLSCRIPTS%\sqlscripts\*.create.sql) DO %DBTOOL_PATH%\dbtool25.exe --with-db-version 25 -r %SQLSCRIPTS% -e  %%a
FOR %%b in (%SQLSCRIPTS%\sqlscripts\*.data.sql) DO %DBTOOL_PATH%\dbtool25.exe --with-db-version 25 -r %SQLSCRIPTS% -e %%b

:: Tabellen Version 23 --> old
set SQLSCRIPTS=%DB_OLD%\tmp\vfr_sql\
rd /q /s %SQLSCRIPTS%\SQL

%DBTOOL_PATH%\dbtool.exe --with-db-version 23 -r %SQLSCRIPTS% -e  %DBTOOL_PATH%\En5Db.createdb.sql
FOR %%a in (%SQLSCRIPTS%\sqlscripts\*.create.sql) DO %DBTOOL_PATH%\dbtool.exe --with-db-version 23 -r %SQLSCRIPTS% -e  %%a
FOR %%b in (%SQLSCRIPTS%\sqlscripts\*.data.sql) DO %DBTOOL_PATH%\dbtool.exe --with-db-version 23 -r %SQLSCRIPTS% -e %%b

:: Fertige SQLs auf den Servern ablegen und verteilen
xcopy %DB_NEW%\tmp\vfr_sql\SQL\JEPP* 				%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_VFR* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\REPORTING* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\SQL

xcopy %DB_OLD%\tmp\vfr_sql\SQL\JEPP* 				%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_VFR* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\REPORTING* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\SQL

xcopy %DB_NEW%\tmp\vfr_sql\SQL\JEPP* 				%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_VFR* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\REPORTING* 			%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\SQL

xcopy %DB_NEW%\tmp\vfr_sql\SQL\JEPP* 				%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\new
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\new
xcopy %DB_NEW%\tmp\vfr_sql\SQL\VERSIONTRACKER* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\new

xcopy %DB_OLD%\tmp\vfr_sql\SQL\JEPP* 				%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\old
xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\old
xcopy %DB_OLD%\tmp\vfr_sql\SQL\VERSIONTRACKER* 		%VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\upd\db\SQL\old

xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_OBSTACLE_POL* %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\upd\db\SQL\

xcopy %DB_OLD%\tmp\vfr_sql\SQL\JEPP* 				%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\LABELS_OBSTACLE_POL* %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\SQL
xcopy %DB_OLD%\tmp\vfr_sql\SQL\VERSIONTRACKER* 		%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\db\SQL

xcopy %DB_NEW%\tmp\vfr_sql\SQL\VERSIONTRACKER* 		%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\JEPP* 				%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\SQL
xcopy %DB_NEW%\tmp\vfr_sql\SQL\LABELS_JEPP* 		%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\SQL
xcopy %DB_NEW%\SQL\LABELS_OBSTACLE_WW*				%KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\SQL

:: Daten zusammenkopieren inkl. App Matrix für NG Maps
xcopy %WORK_PATH%\%CYCLE%\Rep\VFRREPPTS_toEN5\vfrreppts %DB_NEW%\vector\vfrreppts\ /e

del %DB_NEW%\vector\vfrreppts\labels*
xcopy %DB_NEW%\vector\vfrreppts %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\vfrreppts\ /e
xcopy %DB_NEW%\vector\vfrreppts %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\vfrreppts\ /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\en5\appMatrix.json %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new\db\vector\vfrreppts\

:: Map Packs erzeugen und ablegen inkl. App Matrix für NG Maps
%PACK_PATH%\map2pack.exe %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\vfrreppts %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\db\data\vector\vfrreppts
%PACK_PATH%\map2pack.exe %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc\db\vector\vfrreppts %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\en7\vfrreppts
xcopy %VECTOR_SERVER%\jeppesen\_ww\_appMatrix\vfrreppts\en7\appMatrix.json %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\en7\vfrreppts

:: Daten packen und auf Server hochladen
echo *.tar.gz Archiv erstellen und auf Server ablegen
set MAP_NAME=vfrreppts

cd %DATA_PATH%

echo Erstellung des TAR-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv %MAP_NAME%.tar %MAP_NAME%
echo.
echo Erstellung des TAR.GZ-Archivs
%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz %MAP_NAME%.tar
xcopy %DATA_PATH%\vfrreppts.tar.gz %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\

:: MapPacks Jeppesen und Reporting Points für LPR DTM_new ablegen:
xcopy %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%01\en7\vfrreppts %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\vector\vfrreppts /e
xcopy %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\en7\jeppesen\ %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\db\vector\jeppesen /e 

:: DTM OLD und NEW packen und eine Ebene höher ablegen

cd %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_new\
%ZIP_PATH%\7za.exe a Jeppesen_WW_Obstacles_POL_%CYCLE%_LPR_new.zip db
move *.zip %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp

cd %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp\dtm_old\
%ZIP_PATH%\7za.exe a Jeppesen_WW_Obstacles_POL_%CYCLE%_LPR_old.zip db
move *.zip %KUNDEN_SERVER%\ECD_LPR_POL\20%CYCLE%00_jepp

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

U:

:: Jeppesen Cycle Update fertigstellen CYCLE OLD 
cd %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar esen1

%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz esen1
ren esen1.gz esen1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

:: Fertige Daten abschließend packen ablegen
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Jeppesen_WW_%CYCLE%_CYC.zip @list.txt
move *.zip %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\
del /q list.txt

:: Jeppesen Cycle Update fertigstellen CYCLE NEW
cd %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_new
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar esen1

%DTM_PATH%\%DTM_PATH_LIB%\gzip.exe -fv -S .gz esen1
ren esen1.gz esen1.dat
:: Pause nur zur Sicherheit, manchmal gab es Probleme
@ping -n 5 localhost> nul

:: Fertige Daten abschließend packen und ablegen
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Jeppesen_WW_%CYCLE%_CYCN.zip @list.txt
move *.zip %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\
del /q list.txt

:: Jeppesen Cycle Update fertigstellen CYCLE EN7
:: wird nicht gepackt!
cd %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\%CYCLE%_cyc_en7\
%DTM_PATH%\%DTM_PATH_LIB%\tar.exe cfv db.tar db
ren db.tar esen1.dat

:: Fertige Daten abschließend packen und ablegen
> list.txt echo *.dat
>> list.txt echo *.toc
%ZIP_PATH%\7za.exe a Jeppesen_WW_%CYCLE%_EN7.zip @list.txt
move *.zip %VECTOR_SERVER%\jeppesen\_ww\20%CYCLE%00\
del /q list.txt

cls
echo.
echo.
echo Cycle Update Erstellung fuer Cycle %CYCLE% abgeschlossen.
echo           Fertiggestellt um: %time%
echo.
echo.

pause