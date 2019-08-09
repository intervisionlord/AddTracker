#!/bin/bash

#################################################################
# Скрипт прописывания дополнительных трекеров для торрентов	#
# Версия: 0.4(5)						#
# Автор: Intervision (Solitario) (twilightradio.ru)		#
# ###############################################################

# Пользовательские переменные

# TRACKFILE - файл, в котором хроанятся трекеры и ретрекеры (по одному на строку)
#
# TORFILE - торрент-файл который нужно отредактировать
# по умолчанию переменная пустая и заполняется либо через параметр при вызове скрипта
# либо в процессе работы скрипта через диалог
#
# TORUSER, TORGROUP - пользователь и группа, от имени которых работает transmission (на всякий случай, чтобы избежать возможных конфликтов)
#
# AUTODOWNLOADDIR - директория, которую читает transmission для добавления найденных торрентов в автозагрузку

VER='AddTRACK v:0.5 by Intervision'
TRACKFILE='trackers.txt'
TORFILE=''
TORUSER='debian-transmission'
TORGROUP='debian-transmission'
AUTODOWNLOADDIR='/opt/transmission/auto'
DELIMITER='--------------------'

#################################################################

TRACKCOUNT=$(wc -l $TRACKFILE | cut -d" " -f1)

if [ $1 == '-h' ]
then
	cat help.txt
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
			echo "Используется рекурсивный режим для директории $2"
			echo $DELIMITER

			RECUDIR=$2
			TORCOUNT=`find $RECUDIR -type f -name '*.torrent' | wc -l`
		if [ $TORCOUNT != '0' ]
		then
			echo -e "Найдено торрент-файлов: $TORCOUNT \n"
			ls -1 $RECUDIR | grep -i ".torrent"
			echo -e "\n$DELIMITER"
		else
			echo "Торрентов для обработки в директории $RECUDIR не найдено!"
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
