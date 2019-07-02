#!/bin/sh
# bindiri.sh - scorpiorooster
# REQUEST BIND TXT FILE
while true; do
printf "\n\n\t";read -p "Enter BIND .TXT file :  " BINDFILE; printf "\n\n"
		case $BINDFILE in
			*txt ) printf "\n\nContinuing...\n\n"; break;;
			* ) printf "Enter a valid .txt file";;
		esac; done
# EXTRACT HOSTLIST FROM BIND FILE
grep -Eo "(^\w+[.]+\w+[.]+\w+[.])" $BINDFILE | sed 's/.$//' | column -x
grep -Eo "(^\w+[.]+\w+[.]+\w+[.])" $BINDFILE | sed 's/.$//' > hostlist.txt
printf "\n\n\n\tThis has been saved as hostlist.txt\n\n\n"
# USER CONFIRMATION FOR LIST OF HOSTS
while true; do
	read -p "Continue using this list? (Y/N) :  " YN;
		case $YN in
			[Yy]* ) printf "\n\nContinuing...\n\n"; break;;
			[Nn]* ) printf "\nExiting...\n\n"; return;;
			* ) printf "Answer yes or no.\n";;
		esac; done
HOSTLIST="hostlist.txt"
# MAKE NEW INDEX EMPLATE
rm indextemp.html; cat >> indextemp.html << 'EOF'
<html>
<head>
	<title>titleTEMPLATE</title>
</head>
<body>
	<h1>h1TEMPLATE</h1>
		<input type="button" value="RELOAD PAGE" onClick="window.location.reload()">
			<p>Click button to reload this page.</p>
</body>
</html>
EOF
INDEXTEMP='indextemp.html'; cat indextemp.html
printf "\n\n\tThis has been saved as indextemp.html"
printf "\n\t<title> and <h1> will be replaced with server name.\n\t"
# USER CONFIRMATION FOR INDEX TEMPLATE
while true; do
	read -p "Continue using this template? (Y/N) :  " YN
		case $YN in
			[Yy]* ) echo "Continuing..."; break;;
			[Nn]* ) echo "Exiting..."; return;;
			* ) echo "Please answer yes or no.";;
		esac; done
read -p "Enter webroots directory (sites-available) :  " SITESDIR;
printf "\n\n\tYou have entered:  ${SITESDIR}\n\n"
# USER CONFIRMATION FOR SITES DIRECTORY
while true; do
	read -p "Continue using this directory? (Y/N) :  " YN
		case $YN in
			[Yy]* ) echo "Continuing..."; break;;
			[Nn]* ) echo "Exiting..."; return;;
			* ) echo "Please answer yes or no.";;
		esac; done
while read SERVERNAME; do
	# CREATE ROOT SERVER DIRECTORIES FROM .hostlist.txt
    mkdir "$SITESDIR/$SERVERNAME"
	# CREATE index.html IN EACH SERVER ROOT
	cp $INDEXTEMP $SITESDIR/$SERVERNAME/index.html
	# RENAME index <title> AND <h1> DATA FOR SITE
	sed -i "s/titleTEMPLATE/${SERVERNAME}/g" $SITESDIR/$SERVERNAME/index.html
	sed -i "s/h1TEMPLATE/${SERVERNAME}/g" $SITESDIR/$SERVERNAME/index.html
done < hostlist.txt
printf "/nls $SITESDIR/n"; ls $SITESDIR; printf "/nDone!/n"
