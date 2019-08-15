#!/bin/bash

#################################################################
# Скрипт прописывания дополнительных трекеров для торрентов	#
# Версия: 0.4(6)						#
# Автор: Intervision (Solitario) (twilightradio.ru)		#
# ###############################################################

# VER='AddTRACK v:0.6 by Intervision'
# TRACKFILE='data/trackers.txt'
# TORUSER='debian-transmission'
# TORGROUP='debian-transmission'
# AUTODOWNLOADDIR='/opt/transmission/auto'
# DELIMITER='--------------------'

source conf/conf.sh

TRACKCOUNT=$(wc -l $TRACKFILE | cut -d" " -f1)

if [ $1 == '-h' ]
	then
		cat doc/$LANGCODE/help.txt
fi

if [ $1 == '' ]
	then
		echo -e "Не указаны параметры работы и файлы для обработки. Ознакомьтесь со справочной информацией\n"
		cat doc/$LANGCODE/help.txt
fi

if [ $1 == '-v' ]
then
	echo $VER
fi

if [[ $1 == '-r'  &&  $2 == '' ]]
then
	echo "Использован рекурсивный режим без указания целевой директории"
else
	if [[ $1 == '-r'  &&  $2 != '' ]]
		then
			RECFOLDER=$2/
			TRACKCOUNT=`wc -l $TRACKFILE | awk '{print $1}'`
			echo -e "Используется рекурсивный режим для директории $RECFOLDER\n"

			RECUDIR=$2
			TORCOUNT=`find $RECUDIR -type f -name '*.torrent' | wc -l`

		if [ $TORCOUNT != '0' ]
		then
			echo -e "Найдено торрент-файлов: $TORCOUNT \n"
			ls -1 $RECUDIR | grep -i ".torrent"

			echo -e "\nПрименяется список трекеров из файла $TRACKFILE\n"
			echo -e "Общее кол-во трекеров: $TRACKCOUNT\n"

			echo -e "\n$DELIMITER"
			echo -e "Выполняется рекурсивное изменение файлов\n"
				for TRACKERS in $(cat $TRACKFILE)
					do
						transmission-edit -a $TRACKERS $RECFOLDER*\.torrent
				done

			echo $DELIMITER
			echo -e "Применение прав $TORUSER:$TORGROUP на файлы"

			chown -R $TORUSER:$TORGROUP $RECFOLDER

			echo $DELIMITER
			echo -e "Перемещение торрент-файлов в директорию автозагрузки\n"
			echo $DELIMITER

			echo -e "Отладка:\nИспользованы переменные:\n$TRACKERS as TRACKERS\n$RECFILES as RECFILES\n$RECFOLDER as RECFOLDER\n"

#			for READYTORRENTS in $(ls -1 $RECFOLDER)
#				do
#					mv $READYTORRENTS $AUTODOWNLOADDIR
#			done

			mv $RECFOLDER*\.torrent $AUTODOWNLOADDIR

			echo -e "\n$DELIMITER"
		else
			echo -e "\nТоррентов для обработки в директории $RECUDIR не найдено!"
		fi
	fi
fi

if [[ $1 == '-f' && $2 != '' ]]
	then
		SINGLETORRENT=$2

		echo -e "Одиночный режим\nПрименяется список трекеров к одиночному файлу $SINGLETORRENT"
		echo $DELIMITER

		for TRACKERS_SINGLE in $(cat $TRACKFILE);
			do
				transmission-edit -a $TRACKERS_SINGLE	$SINGLETORRENT;
		done

		echo -e "\nПрименяются права $TORUSER:$TORGROUP на торрент $SINGLETORRENT\n"
		chown $TORUSER:$TORGROUP $SINGLETORRENT

		echo -e "Выполняется перенос в директорию автозагрузки: $AUTODOWNLOADDIR\n"
		mv $SINGLETORRENT $AUTODOWNLOADDIR

		echo "Работа заваршена."

	else
		if [[ $1  == '-f' && $2 == '' ]]
			then
				echo "Выбран режим одиночного файла, но не указан путь к файлу. Хотите указать путь? [Y/n]: "
				read -q PATH_YESNO
					if [[ $PATH_YESNO == 'Y' || $PATH_YESNO == 'y' ]]
						then
							echo "Укажите полный путь к файлу: "
							read -q PATHTOTORRENT
							echo $DELIMITER
							echo -e "Применяется список трекеров к одиночному файлу $PATHTOTORRENT\n"
								for TRACKERS_SINGLE_INTERACTIVE in $(cat $TRACKFILE)
									do
										transmission-edit -a $TRACKERS_SINGLE_INTERACTIVE $PATHTOTORRENT
									done
							echo -e "Применяются права $TORUSER:$TORGROUP к файлу $PATHTOTORRENT\n"
							chown $TORUSER:$TORGROUP $PATHTOTORRENT

							echo -e "Перемещение файла $PATHTOTORRENT в директорию автозагрузки $AUTODOWNLOADDIR\n"
							mv $PATHTOTORRENT $AUTODOWNLOADDIR

							echo -e "Работа завершена."
					fi
		fi
fi
: '
if [ -n "$1" ]
then
TORFILE=$1
echo "Файл для редактирования указан: $TORFILE"
else
echo -n "Укажите путь до торрент-файла: "
read TORFILE
fi

# Если параметра нет, спрашиваем имя файла уже в процессе работы скрипта

echo "Читаем список трекеров: $TRACKCOUNT трекеров найдено"

echo $DELIMITER

for i in $(cat $TRACKFILE); do transmission-edit -a $i $TORFILE; done

echo $DELIMITER

echo "$TRACKCOUNT трекеров прописано в файл $TORFILE"

echo "Меняем владельца файла на transmission-daemon"

chown $TORUSER:$TORGROUP $TORFILE

echo "Помещаем торрент-файл в директорию автозагрузки"
mv $TORFILE $AUTODOWNLOADDIR

echo "Все операции завершены!"

'.
