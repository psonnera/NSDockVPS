#!/bin/bash
######################################################################################################
#
#  Alerts and alarms
#
#  Patrick Sonnerat - https://github.com/psonnera
#
######################################################################################################

echo -e "\x1b[37;44mEdit Nightscout variables                                                                         \x1b[0m"
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
'Enable alarm when crossing BG high target'
'Enable alarm when crossing BG low target'
'Enable urgent alarm when crossing high BG value'
'Enable urgent alarm when crossing low BG value'
'Enable urgent alarm when no data received'
'Enable alarm when no data received'
'Urgent low BG value'
'Lower normal BG target value'
'Higher normal BG target value'
'Urgent high BG value'
'Urgent delay for missing readings (min)'
'Warning delay for missing readings (min)'
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

cmd=(dialog --output-fd 1 --separate-output --ok-label 'Save'\
 --cancel-label 'Cancel' --checklist 'Enable these alarms:\nUse space to toggle.' 0 0 0)
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

aldialog=$(dialog --clear --backtitle "$BACKTITLE" --title "Setup alarm values" \
--form " Enter your alarm levels and delays below.\n\
Use the unit you prefer, mmol/l or mg/dl. Nightscout will convert automatically." 12 50 0 \
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

aldialog=$(dialog --clear --backtitle "$BACKTITLE" --title "Setup alarm values" \
--form " Enter your alarm levels and delays below.\n\
 Use the unit you prefer, mmol/l or mg/dl.\n Nightscout will convert them automatically." 15 55 0 \
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
