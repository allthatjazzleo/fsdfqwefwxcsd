#! /bin/sh

which mmdblookup > /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
  echo "Try 'brew install libmaxminddb'"
  brew install libmaxminddb
  exit
fi

RECORD=$(wc -l $1 | awk '{ print $1 }')
echo "Total no of records in access.log are $RECORD\n"

echo "Top 10 hosts:"
echo " No.| IP"
awk '{ print $1}' $1 | sort | uniq -c | sort -nr | head -n 10

rm -f ipcountry.txt
touch ipcountry.txt
declare -a array=()
echo "Loading\n"
for ip in $(awk '{ print $1}' $1 | sort | uniq -c | awk '{ print $2 }' | head -n 10000)
do 
    COUNTRY=$(mmdblookup -i $ip -f ./GeoLite2-Country.mmdb country names en 2> /dev/null | sed '1d;3d' | grep -o '".*"' | sed s/\"//g ) 
    array+=("$COUNTRY")
done 

echo "Top country requests from:\n"
printf "%s\n" "${array[@]}" | sort -n -r | uniq -c | sort -n -r | head -1 | cut -f2- -d " "
