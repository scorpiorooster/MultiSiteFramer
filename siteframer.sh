#!/bin/sh
# REQUEST BIND TXT FILE
while true; do
printf "\n\n\t";read -p "Enter BIND .TXT file:	" BINDFILE; printf "\n\n"
		case $BINDFILE in
			*txt ) printf "\n\nContinuing...\n\n"; break;;
			* ) printf "Enter a valid .txt file";;
		esac; done
# EXTRACT HOSTLIST FROM BIND FILE
grep -Eo "(^\w+[.]+\w+[.]+\w+[.])" $BINDFILE | sed 's/.$//' | column -x
grep -Eo "(^\w+[.]+\w+[.]+\w+[.])" $BINDFILE | sed 's/.$//' > hostlist.txt
printf "\n\n\n\tThis has been saved as hostlist.txt\n\n\n"
while true; do
	read -p "Continue using this list? (Y/N) :" yn;
		case $yn in
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
printf "\n\n\n\tThis has been saved as indextemp.html\n"
printf "\ttitle and h1 will be replaced with server name.\n\n"
while true; do
	read -p "Continue using this template? (Y/N) :" yn
		case $yn in
			[Yy]* ) echo "Continuing..."; break;;
			[Nn]* ) echo "Exiting..."; return;;
			* ) echo "Please answer yes or no.";;
		esac; done
read -p "Enter sites directory (sites-available):  " SITESDIR;
printf "\n\n\tYou have entered:  ${SITESDIR}\n\n"
while true; do
	read -p "Continue using this directory? (Y/N) :" yn
		case $yn in
			[Yy]* ) echo "Continuing..."; break;;
			[Nn]* ) echo "Exiting..."; return;;
			* ) echo "Please answer yes or no.";;
		esac; done
# MAKE NAMED index.html
while read SERVERNAME; do
	# MAKE SERVER DIRECTORIES FROM .hostlist.txt
    mkdir "$SITESDIR/$SERVERNAME"
	cp $INDEXTEMP $SITESDIR/$SERVERNAME/index.html
	sed -i "s/titleTEMPLATE/${SERVERNAME}/g" $SITESDIR/$SERVERNAME/index.html
	sed -i "s/h1TEMPLATE/${SERVERNAME}/g" $SITESDIR/$SERVERNAME/index.html
done < hostlist.txt
ls -l $SITESDIR; printf "/nDone!/n"
