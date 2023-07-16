#!/bin/bash

#
# Credit Eduardo Augusto https://gist.github.com/eduardoaugustojulio/fa83cf85efa39919d6a70ca679e91f28
#
#Licensed to the Apache Software Foundation (ASF) under one
#or more contributor license agreements.  See the NOTICE file
#distributed with this work for additional information
#regarding copyright ownership.  The ASF licenses this file
#to you under the Apache License, Version 2.0 (the
#"License"); you may not use this file except in compliance
#with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.  See the License for the
#specific language governing permissions and limitations
#under the License.

TimeZoneOptionsByRegion ()
{
    options=$(cd /usr/share/zoneinfo/$1 && find . | sed "s|^\./||" | sed "s/^\.//" | sed '/^$/d')
}

TimeZoneRegions ()
{
    regions=$(find /usr/share/zoneinfo/. -maxdepth 1 -type d | cut -d "/" -f6 | sed '/^$/d')
}

TimeZoneSelectionMenu ()
{
    TimeZoneRegions
    regionsArray=()
    while read name; do
        regionsArray+=($name "")
    done <<< "$regions"

    region=$(dialog   --stdout \
                      --title "Scegli il fuso orario" \
                      --backtitle " " \
                      --ok-label "Continua" \
                      --no-cancel \
                      --menu "Seleziona il continente:" \
                      20 30 30 \
                      "${regionsArray[@]}")

    TimeZoneOptionsByRegion $region

    optionsArray=()
    while read name; do
        offset=$(TZ="$region/$name" date +%z | sed "s/00$/:00/g")
        optionsArray+=($name "($offset)")
    done <<< "$options"

    tz=$(dialog     --stdout \
                    --title "Fuso orario" \
                    --backtitle " " \
                    --ok-label "Continua" \
                    --cancel-label "Indietro" \
                    --menu "Seleziona il fuso orario in ${region}:" \
                    20 40 30 \
                    "${optionsArray[@]}")

    if [[ -z "${tz// }" ]]; then
        TimeZoneSelectionMenu
    else
        echo "$region/$tz"
    fi
}

echo "$(TimeZoneSelectionMenu)"
