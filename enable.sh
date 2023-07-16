#!/bin/bash
######################################################################################################
#
#  Enable variables
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdita le variabili Nightscout                                                                     \x1b[0m"

en_var=(
'rawbg'
'iob'
'cob'
'cage'
'sage'
'iage'
'bage'
'treatmentnotify'
'basal'
'bolus'
'bridge'
'pump'
'alexa'
'googlehome'
'speech'
'cors'
)

en_des=(
'rawbg (Glicemia grezza)'
'iob (Insulina attiva)'
'cob (CHO attivi)'
'cage (Eta cannula)'
'sage (Eta sensore)'
'iage (Eta insulina)'
'bage (Eta batteria)'
'treatmentnotify (Notifiche trattamenti)'
'basal (Profilo di basale)'
'bolus (Aspetto boli)'
'bridge (Dexcom share)'
'pump (Monitoraggio micro)'
'alexa (Amazon Alexa)'
'googlehome (NON FUNZIONA PIU)'
'speech (Sintesi vocale)'
'cors (Condivisione risorse)'
)

oldenable="`grep "ENABLE:" /nightscout/docker-compose.yml`"
en_sta=('off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off'
        'off' 'off' 'off' 'off' 'off')
for i in ${!en_var[@]}; do
  if [ "`grep "ENABLE:" /nightscout/docker-compose.yml | grep ${en_var[$i]}`" != "" ]
    then
    en_sta[$i]=on
    else
    en_sta[$i]=off
  fi
done

options=(
  0 "${en_des[0]}" ${en_sta[0]}
  1 "${en_des[1]}" ${en_sta[1]}
  2 "${en_des[2]}" ${en_sta[2]}
  3 "${en_des[3]}" ${en_sta[3]}
  4 "${en_des[4]}" ${en_sta[4]}
  5 "${en_des[5]}" ${en_sta[5]}
  6 "${en_des[6]}" ${en_sta[6]}
  7 "${en_des[7]}" ${en_sta[7]}
  8 "${en_des[8]}" ${en_sta[8]}
  9 "${en_des[9]}" ${en_sta[9]}
  A "${en_des[10]}" ${en_sta[10]}
  B "${en_des[11]}" ${en_sta[11]}
  C "${en_des[12]}" ${en_sta[12]}
  D "${en_des[13]}" ${en_sta[13]}
  E "${en_des[14]}" ${en_sta[14]}
  F "${en_des[15]}" ${en_sta[15]}
)

cmd=(dialog --output-fd 1 --separate-output --ok-label 'Salva'\
 --cancel-label 'Cancella' --checklist 'Abilita questi plugins:\nUsa spazio per cambiare.' 0 0 0)
load-dialog () {
    choices=$("${cmd[@]}" "${options[@]}")
}
load-dialog
exit_code="$?"

if [ $exit_code = "0" ]
  then
  en_sta=('off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off'
          'off' 'off' 'off' 'off' 'off')
  en_str="      ENABLE:"
  for i in $choices
  do
    en_str="$en_str ${en_var[$i]}"
  done
  en_str="$en_str careportal dbsize upbat devicestatus"
fi

sudo sed -i "s/$oldenable/$en_str/" /nightscout/docker-compose.yml

