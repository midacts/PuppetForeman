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
	dpkg -i puppetlabs-release-squeeze.deb
	apt-get update
	echo "The Latest Puppet Repos have been acquired!"
}
function installPuppet()
{
	echo '+++ Installing Puppet Master...'
	apt-get install puppetmaster -y
	echo "The Puppet Master has been installed!"
}
function enablePuppet()
{
	echo '+++ Enabling Puppet Master Service...'
	puppet resource service puppetmaster ensure=running enable=true
	echo "The Puppet Master Service has been initiated!"
}
function foremanRepos()
{
	echo '+++ Getting repositories...'
	echo "deb http://deb.theforeman.org/ squeeze stable" > /etc/apt/sources.list.d/foreman.list
	wget -q http://deb.theforeman.org/foreman.asc -O- | apt-key add -
	apt-get update
	echo "The Latest Foreman Repos have been acquired!"
}
function installForeman()
{
	echo '+++ Installing The Foreman...'
	apt-get install foreman-installer -y
	echo "The Foreman Installer has been downloaded!"
	echo
	echo "Initializing The Foreman Installer..."
	sleep 1
	echo "Select"
	sleep 1
	echo "Yes"
	sleep 1
	echo "Three"
	sleep 1
	echo "Times"
	sleep .5
	echo "Here"
	sleep .5
	echo "We"
	sleep .5
	echo "G O  ! ! ! !"
	ruby /usr/share/foreman-installer/generate_answers.rb
	service apache2 restart
	echo "The Foreman has been installed!"
	echo "Foreman Default Credentials:"
	echo "Username: admin"
	echo "Password: changeme"
}
function doAll()
{
	echo "=== Set Machine's Hostname to for Puppet Runs ? [RECOMMENDED] (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		setHostname
	fi

	echo "=== Get Latest Puppet Repos ? (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		puppetRepos
	fi

	echo "=== Install Puppet Master ? (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		installPuppet
	fi

	echo "=== Enable Puppet Master Service ? (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		enablePuppet
	fi

	echo "=== Get Latest Foreman Repos ? (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		foremanRepos
	fi

	echo "=== Install The Foreman ? (y/n)"
	read yesno
	if [ "$yesno" = "y" ]; then
		installForeman
	fi
	echo -e '\e[01;37;42mWell done! you have completed you Puppet Master and Foreman Installation.\e[0m'
	echo -e '\e[01;37;42mProceed to your Foreman web UI, http://fqdn\e[0m'
	exit 0
}
# Check privileges
[ $(whoami) == "root" ] || die "You need to run this script as root."
# Welcome to the script
echo -e "\e[01;37;42m Welcome to Midacts Mystery's Puppet Master Installer! \e[0m"

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
