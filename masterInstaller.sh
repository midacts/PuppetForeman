#!/bin/bash
# Puppet Master Install with The Foreman 1.5 on Debian Wheezy 7.5
# Author: John McCarthy
# <http://www.midactstech.blogspot.com> <https://www.github.com/Midacts>
# Date: 18th of June, 2014
# Version 1.3
#
# To God only wise, be glory through Jesus Christ forever. Amen.
# Romans 16:27, I Corinthians 15:1-4
#---------------------------------------------------------------
######## FUNCTIONS ########
function setHostname()
{
# /etc/hosts
	IP=`hostname -I`
	Hostname=`hostname`
	FQDN=`hostname -f`
	echo -e "127.0.0.1	localhost		localhosts.localdomain	$FQDN\n$IP	$FQDN	$Hostname	puppet" > /etc/hosts
}
function puppetRepos()
{
	echo
	echo -e '\e[01;34m+++ Getting repositories...\e[0m'
	wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
	dpkg -i puppetlabs-release-wheezy.deb
	apt-get update
	echo -e '\e[01;37;42mThe Latest Puppet Repos have been acquired!\e[0m'
}
function installPuppet()
{
	echo
	echo -e '\e[01;34m+++ Installing Puppet Master...\e[0m'
	apt-get install puppetmaster -y
	echo -e '\e[01;37;42mThe Puppet Master has been installed!\e[0m'
}
function enablePuppet()
{
	echo
	echo -e '\e[01;34m+++ Enabling Puppet Master Service...\e[0m'
	puppet resource service puppetmaster ensure=running enable=true
	sed -i 's/START=no/START=yes/g' /etc/default/puppet
	sed -i 's/START=no/START=yes/g' /etc/default/puppetmaster
	echo -e '\e[01;37;42mThe Puppet Master Service has been initiated!\e[0m'
}
function foremanRepos()
{
	echo
	echo -e '\e[01;34m+++ Getting repositories...\e[0m'
	echo "deb http://deb.theforeman.org/ wheezy 1.5" > /etc/apt/sources.list.d/foreman.list
	echo "deb http://deb.theforeman.org/ plugins 1.5" >> /etc/apt/sources.list.d/foreman.list
	wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
	apt-get update
	echo -e '\e[01;37;42mThe Latest Foreman Repos have been acquired!\e[0m'
}
function installForeman()
{
	echo
	echo -e '\e[01;34m+++ Installing The Foreman...\e[0m'
	apt-get install foreman-installer -y
	echo -e '\e[01;37;42mThe Foreman Installer has been downloaded!\e[0m'
	echo
	echo -e '\e[01;34mInitializing The Foreman Installer...\e[0m'
	echo "-------------------------------------"
	sleep 1
	echo -e '\e[33mMake any additional changes you would like\e[0m'
	sleep 1
	echo -e '\e[33mSelect option "20" and hit ENTER to run the install\e[0m'
	sleep 1
	echo 
	echo -e '\e[97mHere\e[0m'
	sleep .5
	echo -e '\e[97mWe\e[0m'
	sleep .5
	echo -e '\e[01;97;42mG O  ! ! ! !\e[0m'
	foreman-installer -i -v
	service apache2 restart
	echo -e '\e[01;37;42mThe Foreman has been installed!\e[0m'
}
function doAll()
{
	echo
	echo -e "\e[33m=== Set Machine's Hostname for Puppet Runs ? [RECOMMENDED] (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		setHostname
	fi

	echo
	echo -e "\e[33m=== Get Latest Puppet Repos ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		puppetRepos
	fi

	echo
	echo -e "\e[33m=== Install Puppet Master ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		installPuppet
	fi

	echo
	echo -e "\e[33m=== Enable Puppet Master Service ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		enablePuppet
	fi

	echo
	echo -e "\e[33m=== Get Latest Foreman Repos ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		foremanRepos
	fi

	echo
	echo -e "\e[33m=== Install The Foreman ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		installForeman
	fi
	
	# End of Script Congratulations, Farewell and Additional Information
		clear
		farewell=$(cat << EOZ

  \e[01;37;42mWell done! You have completed your Puppet Master and Foreman Installation! \e[0m

                  \e[01;39mProceed to your Foreman web UI, https://fqdn\e[0m

                         \e[01;39mForeman Default Credentials:\e[0m
                               \e[34mUsername\e[0m\e[01;39m: admin\e[0m
                               \e[34mPassword\e[0m\e[01;39m: changeme\e[0m

  \e[30;01mCheckout similar material at midactstech.blogspot.com and github.com/Midacts\e[0m

                            \e[01;37m########################\e[0m
                            \e[01;37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[01;37m#\e[0m
                            \e[01;37m########################\e[0m


EOZ
)

		#Calls the End of Script variable
		echo -e "$farewell"
		echo
		echo
		exit 0
}

# Check privileges
	[ $(whoami) == "root" ] || die "You need to run this script as root."
	
# Welcome to the script
	clear
	welcome=$(cat << EOA


             \e[01;37;42mWelcome to Midacts Mystery's Puppet Master Installer!\e[0m


EOA
)

# Calls the welcome variable
	echo -e "$welcome"

# Calls the doAll function
	case "$go" in
		* )
			doAll ;;
	esac

	exit 0
