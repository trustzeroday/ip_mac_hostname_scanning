#!/usr/bin/env bash
####################
# Script to filter the IP, MAC addresses, and hostname
# and store them in a text file.
####################
# Author:   Muhammad "Trust0" AlMatrouk
# Date  :   2025-08-24
####################


#SCRIPT_DIR=$(dirname "$0")

if [ $# -ne 1 ]
then
  echo "Usage: $0 <hosts_file>"
  exit 1
fi

HOSTS_FILE="$1"

if [ ! -f "${HOSTS_FILE}" ]; then
  echo "Error: ${HOSTS_FILE} not found"
  exit 1
fi

OUTPUTFILE0="./nbtscan.output"
OUTPUTFILE1="./addresses.ip"
OUTPUTFILE2="./addresses.mac"
OUTPUTFILE3="./addresses.hostnames"
OUTPUTFILE4="./ip_mac_hostname.csv"
OUTPUTFILE5="./ip_hostname.csv"

NBTOUTPUT=$(nbtscan -vf "${HOSTS_FILE}")

#--------------------#
# Storing `nbtscan` Output
#--------------------#
echo "${NBTOUTPUT}" > "${OUTPUTFILE0}"

#--------------------#
# Filtering IP Addresses
#--------------------#
echo "[!] Filtering IP Addresses"
if [ -f "${OUTPUTFILE1}" ]
then
  rm "${OUTPUTFILE1}"
fi
while read -r line
do
  IPADDR=$(echo "${line}"  |\
    grep -i netbios |\
    awk '{print $NF}' |\
    sed 's/:$//')

  if [ -n "${IPADDR}" ]
  then
    echo "${IPADDR}" >> "${OUTPUTFILE1}"
  fi

done <<< "${NBTOUTPUT}"
echo "[+] Done"

#--------------------#
# Filtering MAC Addresses
#--------------------#
echo "[!] Filtering MAC Addresses"
if [ -f "${OUTPUTFILE2}" ]
then
  rm "${OUTPUTFILE2}"
fi
while read -r line
do
  MACADDR=$(echo "${line}"  |\
    grep -i adapter |\
    awk -F'address: ' '{print $NF}' |\
    sed 's/:$//')

  if [ -n "${MACADDR}" ]
  then
    echo "${MACADDR}" >> "${OUTPUTFILE2}"
  fi
done <<< "${NBTOUTPUT}"
echo "[+] Done"

#--------------------#
# Filtering Hostnames
#--------------------#
echo "[!] Filtering Hostnames"
if [ -f "${OUTPUTFILE3}" ]
then
  rm "${OUTPUTFILE3}"
fi
while read -r line
do
  HOSTNAME=$(echo "${line}"  |\
    grep -i '<00>' |\
    grep -vi "${DOMAIN}" |\
    grep -vi 'workgroup' |\
    awk '{print $1}')

  if [ -n "${HOSTNAME}" ]
  then
    echo "${HOSTNAME}" >> "${OUTPUTFILE3}"
  fi
done <<< "${NBTOUTPUT}"
echo "[+] Done"

#--------------------#
# Joining the text files
#--------------------#
echo "[!] Joining Outputs"
echo "IP Address,Hostname" > "${OUTPUTFILE5}"
echo "IP Address,MAC Address,Hostname" > "${OUTPUTFILE4}"
paste -d, "${OUTPUTFILE1}" "${OUTPUTFILE3}" >> "${OUTPUTFILE5}"
paste -d, "${OUTPUTFILE1}" "${OUTPUTFILE2}" "${OUTPUTFILE3}" >> "${OUTPUTFILE4}"
echo "[+] Done"
