#!/bin/bash
######################################################################################################
#
#  Show plugins
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdita le variabili di Nightscout                                                                  \x1b[0m"

sh_var=(
'rawbg'
'iob'
'cob'
'cage'
'sage'
'iage'
'bage'
'basal'
'bolus'
'pump'
)

sh_des=(
'rawbg (Glicemia grezza)'
'iob (Insulina attiva)'
'cob (CHO attivi)'
'cage (Eta cannula)'
'sage (Eta sensore)'
'iage (Eta insulina)'
'bage (Eta batteria)'
'basal (Profilo basale)'
'bolus (Aspetto boli)'
'pump (Monitoraggio micro)'
)

oldshow="`grep "SHOW_PLUGINS:" /nightscout/docker-compose.yml`"
sh_sta=('off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off'
        'off' 'off' 'off' 'off' 'off')
for i in ${!sh_var[@]}; do
  if [ "`grep "SHOW_PLUGINS:" /nightscout/docker-compose.yml | grep ${sh_var[$i]}`" != "" ]
    then
    sh_sta[$i]=on
    else
    sh_sta[$i]=off
  fi
done

options=(
  0 "${sh_des[0]}" ${sh_sta[0]}
  1 "${sh_des[1]}" ${sh_sta[1]}
  2 "${sh_des[2]}" ${sh_sta[2]}
  3 "${sh_des[3]}" ${sh_sta[3]}
  4 "${sh_des[4]}" ${sh_sta[4]}
  5 "${sh_des[5]}" ${sh_sta[5]}
  6 "${sh_des[6]}" ${sh_sta[6]}
  7 "${sh_des[7]}" ${sh_sta[7]}
  8 "${sh_des[8]}" ${sh_sta[8]}
  9 "${sh_des[9]}" ${sh_sta[9]}
)

cmd=(dialog --output-fd 1 --separate-output --ok-label 'Salva'\
 --cancel-label 'Cancella' --checklist 'Visualizza questi plugins:\nUsa spazio per cambiare.' 0 0 0)
load-dialog () {
    choices=$("${cmd[@]}" "${options[@]}")
}
load-dialog
exit_code="$?"

if [ $exit_code = "0" ]
  then
  sh_sta=('off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off' 'off'
          'off' 'off' 'off' 'off' 'off')
  sh_str="      SHOW_PLUGINS:"
  for i in $choices
  do
    sh_str="$sh_str ${sh_var[$i]}"
  done
  sh_str="$sh_str careportal dbsize"
fi

sudo sed -i "s/$oldshow/$sh_str/" /nightscout/docker-compose.yml

