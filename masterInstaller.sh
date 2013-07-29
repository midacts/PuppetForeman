#!/bin/bash
# Puppet Master Install with The Foreman 1.1 on Debian Wheezy
# Author: John McCarthy
# Date: July 24, 2013
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
	echo '+++ Getting repositories...'
	wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
	dpkg -i puppetlabs-release-wheezy.deb
	apt-get update
	echo -e '\e[01;37;42mThe Latest Puppet Repos have been acquired!\e[0m'
}
function installPuppet()
{
	echo '+++ Installing Puppet Master...'
	apt-get install puppetmaster -y
	echo -e '\e[01;37;42mThe Puppet Master has been installed!\e[0m'
}
function enablePuppet()
{
	echo '+++ Enabling Puppet Master Service...'
	puppet resource service puppetmaster ensure=running enable=true
	echo -e '\e[01;37;42mThe Puppet Master Service has been initiated!\e[0m'
}
function foremanRepos()
{
	echo '+++ Getting repositories...'
	echo "deb http://deb.theforeman.org/ squeeze stable" > /etc/apt/sources.list.d/foreman.list
	wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
	apt-get update
	echo -e '\e[01;37;42mThe Latest Foreman Repos have been acquired!\e[0m'
}
function installForeman()
{
	echo '+++ Installing The Foreman...'
	apt-get install foreman-installer -y
	echo -e '\e[01;37;42mThe Foreman Installer has been downloaded!\e[0m'
	echo
	echo "Initializing The Foreman Installer..."
	echo "-------------------------------------"
	sleep 1
	echo "Select"
	sleep 1
	echo "Yes"
	sleep 1
	echo "Three"
	sleep 1
	echo "Times"
	echo 
	sleep .5
	echo "Here"
	sleep .5
	echo "We"
	sleep .5
	echo -e '\e[01;37;42mG O  ! ! ! !\e[0m'
	ruby /usr/share/foreman-installer/generate_answers.rb
	service apache2 restart
	echo -e '\e[01;37;42mThe Foreman has been installed!\e[0m'
	echo
	echo "Foreman Default Credentials:"
	echo "Username: admin"
	echo "Password: changeme"
}
function doAll()
{
	echo -e "\e[33m=== Set Machine's Hostname for Puppet Runs ? [RECOMMENDED] (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		setHostname
	fi

	echo -e "\e[33m=== Get Latest Puppet Repos ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		puppetRepos
	fi

	echo -e "\e[33m=== Install Puppet Master ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		installPuppet
	fi

	echo -e "\e[33m=== Enable Puppet Master Service ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		enablePuppet
	fi

	echo -e "\e[33m=== Get Latest Foreman Repos ? (y/n)\e[0m"
	read yesno
	if [ "$yesno" = "y" ]; then
		foremanRepos
	fi

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
	echo -e '                            \e[37m########################\e[0m'
	echo -e '                            \e[37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[37m#\e[0m'
	echo -e '                            \e[37m########################\e[0m'
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
