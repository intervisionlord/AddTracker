#!/bin/bash

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

VER='AddTRACK v:0.6 by Intervision'
TRACKFILE='data/trackers.txt'
TORUSER='debian-transmission'
TORGROUP='debian-transmission'
AUTODOWNLOADDIR='/opt/transmission/auto'
DELIMITER='--------------------'
