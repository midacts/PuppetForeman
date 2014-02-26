#!/bin/bash
# Puppet Master Install with The Foreman 1.4 on Debian Wheezy 7.4
# Author: John McCarthy
# Date: February 26, 2014
#
# To God only wise, be glory through Jesus Christ forever. Amen.
# Romans 16:27, I Corinthians 15:1-4
#------------------------------------------------------
######## FUNCTIONS ########
function setHostname()
{
# /etc/hosts
	IP=`hostname -I`
	Hostname=`hostname`
	FQDN=`hostname -f`
	echo -e "127.0.0.1	localhost		localhosts.localdomain\n$IP	$FQDN	$Hostname	puppet" > /etc/hosts
}
function puppetRepos()
{
	echo -e '\e[01;34m+++ Getting repositories...\e[0m'
	wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
	dpkg -i puppetlabs-release-wheezy.deb
	apt-get update
	echo -e '\e[01;37;42mThe Latest Puppet Repos have been acquired!\e[0m'
}
function installPuppet()
{
	echo -e '\e[01;34m+++ Installing Puppet Master...\e[0m'
	apt-get install puppetmaster -y
	echo -e '\e[01;37;42mThe Puppet Master has been installed!\e[0m'
}
function enablePuppet()
{
	echo -e '\e[01;34m+++ Enabling Puppet Master Service...\e[0m'
	puppet resource service puppetmaster ensure=running enable=true
	echo -e '\e[01;37;42mThe Puppet Master Service has been initiated!\e[0m'
}
function foremanRepos()
{
	echo -e '\e[01;34m+++ Getting repositories...\e[0m'
	echo "deb http://deb.theforeman.org/ wheezy stable" > /etc/apt/sources.list.d/foreman.list
	wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
	apt-get update
	echo -e '\e[01;37;42mThe Latest Foreman Repos have been acquired!\e[0m'
}
function installForeman()
{
	echo -e '\e[01;34m+++ Installing The Foreman...\e[0m'
	apt-get install foreman-installer -y
	echo -e '\e[01;37;42mThe Foreman Installer has been downloaded!\e[0m'
	echo
	echo -e '\e[01;34mInitializing The Foreman Installer...\e[0m'
	echo "-------------------------------------"
	sleep 1
	echo -e '\e[33mMake any additional changes you would like\e[0m'
	sleep 1
	echo -e '\e[33mSelect option "5" and hit ENTER to run the install\e[0m'
	sleep 1
	echo 
	echo -e '\e[97mHere\e[0m'
	sleep .5
	echo -e '\e[97mWe\e[0m'
	sleep .5
	echo -e '\e[01;97;42mG O  ! ! ! !\e[0m'
	foreman-installer -i
	service apache2 restart
	echo -e '\e[01;37;42mThe Foreman has been installed!\e[0m'
	echo
	echo "Foreman Default Credentials:"
	echo -e '\e[34mUsername\e[0m: admin'
	echo -e '\e[34mPassword\e[0m: changeme'
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
	echo
	echo
	echo -e '   \e[01;37;42mWell done! You have completed your Puppet Master and Foreman Installation!\e[0m'
	echo
	echo -e '                  \e[01;37;42mProceed to your Foreman web UI, http://fqdn\e[0m'
	echo
	echo
	echo -e '                            \e[01;37m########################\e[0m'
	echo -e '                            \e[01;37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[01;37m#\e[0m'
	echo -e '                            \e[01;37m########################\e[0m'
	echo
	echo
	exit 0
}
# Check privileges
[ $(whoami) == "root" ] || die "You need to run this script as root."
# Welcome to the script
echo
echo
echo -e '             \e[01;37;42mWelcome to Midacts Mystery'\''s Puppet Master Installer!\e[0m'
echo
echo
case "$go" in
	hostname)
		setHostname ;;
	repos)
		puppetRepos ;;
	puppet)
		installPuppet ;;
	enablePuppet)
		enablePuppet ;;
	foremanRepos)
		foremanRepos ;;
	Foreman)
		installForeman ;;
	* )
			doAll ;;
esac

exit 0
