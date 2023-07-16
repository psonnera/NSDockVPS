#!/bin/bash
######################################################################################################
#
#  Alerts and alarms
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdita le variabili di Nightscout                                                                  \x1b[0m"
al_var=(
'ALARM_HIGH:'
'ALARM_LOW:'
'ALARM_URGENT_HIGH:'
'ALARM_URGENT_LOW:'
'ALARM_TIMEAGO_URGENT:'
'ALARM_TIMEAGO_WARN:'
'BG_LOW:'
'BG_TARGET_BOTTOM:'
'BG_TARGET_TOP:'
'BG_HIGH:'
'ALARM_TIMEAGO_URGENT_MINS:'
'ALARM_TIMEAGO_WARN_MINS:'
)
al_des=(
'Abilita l'allarme sopra la soglia glicemia alta'
'Abilita l'allarme sotto la soglia glicemia bassa'
'Abilita l'allarme urgente sopra la soglia alta urgente'
'Abilita l'allarme urgente sotto la soglia bassa urgente'
'Abilita l'allarme urgente per dati mancanti'
'Abilita l'allarme per dati mancanti'
'Valore glicemia bassa urgente'
'Valore glicemia bassa'
'Valore glicemia alta urgente'
'Valore glicemia alta'
'Letture mancante (urgente) da ... (min)'
'Letture mancante da ... (min)'
)

al_sta=('off' 'off' 'off' 'off' 'off' 'off')
for i in ${!al_var[@]}; do
  al_sta[$i]="`grep "${al_var[$i]}" /nightscout/docker-compose.yml | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//'`"
done

options=(
  0 "${al_des[0]}" ${al_sta[0]}
  1 "${al_des[1]}" ${al_sta[1]}
  2 "${al_des[2]}" ${al_sta[2]}
  3 "${al_des[3]}" ${al_sta[3]}
  4 "${al_des[4]}" ${al_sta[4]}
  5 "${al_des[5]}" ${al_sta[5]}
)

cmd=(dialog --output-fd 1 --separate-output --ok-label 'Salva'\
 --cancel-label 'Cancella' --checklist 'Abilita questi allarmi:\nUsa spazio per cambiare.' 0 0 0)
load-dialog () {
    choices=$("${cmd[@]}" "${options[@]}")
}
load-dialog
exit_code="$?"

num=($choices)

if [ $exit_code = "0" ]
  then
  al_new=('off' 'off' 'off' 'off' 'off' 'off')
  for i in "${num[@]}"; do
    j=$(($i))
    al_new[j]='on'
  done

  for i in 0 1 2 3 4 5; do
    sudo sed -i "s/${al_var[i]} ${al_sta[i]}/${al_var[i]} ${al_new[i]}/" /nightscout/docker-compose.yml
  done
fi

aldialog=$(dialog --clear --backtitle "$BACKTITLE" --title "Impostazione valori di allarmi" \
--form " Digita livelli e ritardi sotto.\n\
 Usa l'unita che vuoi, mmol/l o mg/dl. Nightscout convertira automaticamente." 12 50 0 \
"${al_des[6]}: " 1 1 "${al_sta[6]}" 1 14 4 0 \
"${al_des[7]}: " 1 1 "${al_sta[7]}" 2 14 4 0 \
"${al_des[8]}: " 1 1 "${al_sta[8]}" 3 14 4 0 \
"${al_des[9]}: " 1 1 "${al_sta[9]}" 4 14 4 0 \
"${al_des[10]}: " 1 1 "${al_sta[10]}" 5 14 4 0 \
"${al_des[11]}: " 1 1 "${al_sta[11]}" 6 14 4 0 \
 2>&1 >/dev/tty)
status=$?

if [ $status = 0 ]
  then
  al_new=($aldialog)

  for i in 6 7 8 9 10 11; do
"${al_des[0]}" ${al_sta[0]}
    sudo sed -i "s/${al_var[i]} ${al_sta[i]}/${al_var[i]} ${al_new[i-6]}/" /nightscout/docker-compose.yml
  done
fi

aldialog=$(dialog --clear --backtitle "$BACKTITLE" --title "SImpostazione valori di allarmi" \
--form " Digita livelli e ritardi sotto.\n\
 Usa l'unita che vuoi, mmol/l o mg/dl. Nightscout convertira automaticamente." 15 55 0 \
"${al_des[6]}" 1 1 "${al_sta[6]}" 1 45 4 0 \
"${al_des[7]}" 2 1 "${al_sta[7]}" 2 45 4 0 \
"${al_des[8]}" 3 1 "${al_sta[8]}" 3 45 4 0 \
"${al_des[9]}" 4 1 "${al_sta[9]}" 4 45 4 0 \
"${al_des[10]}" 5 1 "${al_sta[10]}" 5 45 4 0 \
"${al_des[11]}" 6 1 "${al_sta[11]}" 6 45 4 0 \
 2>&1 >/dev/tty)
status=$?

if [ $status = 0 ]
  then
  al_new=($aldialog)

  for i in 6 7 8 9 10 11; do
    sudo sed -i "s/${al_var[i]} ${al_sta[i]}/${al_var[i]} ${al_new[i-6]}/" /nightscout/docker-compose.yml
  done
fi
