 #!/bin/bash
#########################
#Installer für Steam-Games by Stoertebeker
#Funktionsweise
# prüft: - ob benötigte Pakete installiert sind (gcc-multilib, dialog)
#	 - legt Ordner für Gameserver an
#	 - installiert SteamCMD
#	 - Auswahlmenü für Spieleinstallationen
#########################

# Variablen
hlstats_ip=10.10.2.1
hlstats_port=27500
partyname="NGC 2015"
rcon=ngc15serveradmin
#Variablen Ende
speicherplatz=0

echo "###############"
echo "Spiele-Installer"
echo "###############"
echo ""

read -e -p "Gib den Party-Namen ein [Default: $partyname]: " partyname_temp
if [ ! -z $partyname_temp ] # false, wenn variable leer
then
        partyname=$partyname_temp
fi

echo "###############"
echo "Voraussetzungen prüfen ..."
echo "###############"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' gcc-multilib|grep "install ok installed")
echo Checking for gcc-multilib: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No gcc-multilib. Installing."
  sudo apt-get --force-yes --yes install gcc-multilib
fi

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' dialog|grep "install ok installed")
echo Checking for dialog: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No gcc-multilib. Installing."
  sudo apt-get --force-yes --yes install dialog
fi

sleep 2

echo "###############"
echo "SteamCMD wird installiert"
echo "###############"
cd ~/
if [ ! -d ~/gs ]
  then
    echo "Ordner ~/gs wird erstellt"
    mkdir ~/gs
    sleep 2
fi
cd ~/gs

if [ ! -d ./steamcmd ]
  then
    echo "Ordner ./steamcmd wird erstellt"
    mkdir steamcmd
    sleep 2
fi

echo "###############"
echo "SteamCMD wird installiert"
echo "###############"
cd ./steamcmd
wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
tar xvfz steamcmd_linux.tar.gz
rm steamcmd_linux.tar.gz
./steamcmd.sh +login anonymous +quit
echo "Checking..."
if [ -f ~/.steam/sdk32/steamclient.so ]
  then
    echo ".steam/sdk32/steamclient.so vorhanden"
  else
    ln -s ~/gs/steamcmd/linux32 ~/.steam/sdk32
    echo ".steam/sdk32/steamclient.so nicht vorhanden; erstellt"
fi
echo "###############"
sleep 2


cmd=(dialog --separate-output --title "Spieleauswahl" --checklist "Select options:" 22 76 16)
options=(1 "Counter-Strike 1.6" off   		 # 769 MB
         2 "Counter-Strike Source" off		 # 2120
         3 "Counter-Strike Global Offensive" off # 10644 MB
         4 "Team Fortress Classic" off		 # 890 MB
	 5 "Team Fortress 2" off		 # 5560 MB
	 6 "Day of Defeat" off			 # 1146 MB
	 7 "Day of Defeat Source" off		 # 1632 MB
	 8 "Insurgency" off			 # 8714 MB
	 9 "HL Deathmatch Classic" off		 # 816 MB
	 10 "HL2 Deathmatch" off		 # 629 MB
	 11 "Garrys Mod" off)			 # 3635 MB
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            echo "Installiere cs16"
	    echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../cs16 +app_update 90 +quit
	    sed -i "/hostname/ {s:.*:hostname \"$partyname Counter-Strike 1.6 Public Server\": }" ~/gs/cs16/cstrike/server.cfg
	    echo "rcon_password \"$rcon\"" >> ~/gs/cs16/cstrike/server.cfg
            ;;
        2)
            echo "Installiere css"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../css +app_update 232330 +quit
	    touch ~/gs/css/cstrike/cfg/server.cfg
	    echo "sv_lan 1" >> ~/gs/css/cstrike/cfg/server.cfg
            echo "hostname \"$partyname Counter-Strike Source Public Server\"" >> ~/gs/css/cstrike/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/css/cstrike/cfg/server.cfg
            ;;
        3)
            echo "Installiere csgo"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../csgo +app_update 740 +quit
	    mv ~/gs/csgo/csgo/gamemodes_server.txt.example ~/gs/csgo/csgo/gamemodes_server.txt
	    touch ~/gs/csgo/csgo/cfg/server.cfg
            echo "hostname \"$partyname Counter-Strike GO Public Server\"" >> ~/gs/csgo/csgo/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/csgo/csgo/cfg/server.cfg
	    ;;
        4)
            echo "Installiere tfc"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../tfc +app_update 90 +app_set_config 90 mod tfc +quit
            ;;
        5)
            echo "Installiere tf2"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../tf2 +app_update 232250 +quit
            touch ~/gs/tf2/tf/cfg/server.cfg
            echo "hostname \"$partyname TF2 Public Server\"" >> ~/gs/tf2/tf/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/tf2/tf/cfg/server.cfg
            ;;
        6)
            echo "Installiere dod"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../dod +app_update 90 +app_set_config 90 mod dod +quit
            ;;
        7)
            echo "Installiere dods"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../dods +app_update 232290 +quit
            touch ~/gs/dods/dod/cfg/server.cfg
            echo "hostname \"$partyname DOD:S Public Server\"" >> ~/gs/dods/dod/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/dods/dod/cfg/server.cfg
            ;;
	8)
	    echo "Installiere Insurgency"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../insurgency +app_update 237410 +quit
            touch ~/gs/insurgency/insurgency/cfg/server.cfg
	    mv ~/gs/insurgency/insurgency/cfg/server.cfg.example ~/gs/insurgency/insurgency/cfg/server.cfg
            echo "hostname \"$partyname Insurgency Public Server\"" >> ~/gs/hl2dm/hl2mp/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/insurgency/insurgency/cfg/server.cfg
	    echo "sv_playlist coop" >> ~/gs/insurgency/insurgency/cfg/server.cfg
            ;;
        9)
            echo "Installiere HL Deathmatch Classic"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../dmc +app_update 90 +app_set_config 90 mod dmc +quit
            ;;
        10)
            echo "Installiere HL2 Deathmatch"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../hl2dm +app_update 232370 +quit
            touch ~/gs/hl2dm/hl2mp/cfg/server.cfg
            echo "hostname \"$partyname HL2:DM Public Server\"" >> ~/gs/hl2dm/hl2mp/cfg/server.cfg
            echo "rcon_password \"$rcon\"" >> ~/gs/hl2dm/hl2mp/cfg/server.cfg
            ;;
        11)
            echo "Garrys Mod"
            echo "####################################"
            sleep 1
            ./steamcmd.sh +login anonymous +force_install_dir ../gmod +app_update 4020 +quit
            ;;

    esac
done

echo "####################"
echo "Installation(en) abgeschlossen"
echo "####################"
sleep 3

cmd2=(dialog --separate-output --title "Erweiterungen und Mods installieren" --checklist "Select options:" 22 76 16)
options2=(1 "HLStatsX in cs16" off    # any option can be set to default to "on"
         2 "Option 2" off
         3 "Option 3" off
         4 "Option 4" off)
choices2=$("${cmd2[@]}" "${options2[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices2
do
    case $choice in
        1)
            echo "log on" >> ~/gs/cs16/cstrike/server.cfg
	    echo "logaddress_add $hlstats_ip $hlstats_port" >> ~/gs/cs16/cstrike/server.cfg
            ;;
        2)
            echo "Second Option"
            ;;
        3)
            echo "Third Option"
            ;;
        4)
            echo "Fourth Option"
            ;;
    esac
done

