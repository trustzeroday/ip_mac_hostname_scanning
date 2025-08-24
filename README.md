####################
# ip_mac_scanning
Shell script for scanning and enumerating IP and MAC addresses alongside their hostname, filtered from the `nbtscan` output.

Running this script requires a file with the IP addresses of the hosts connected in the internal network, generating the following text files:
  [+] nbtscan.output
  [+] addresses.ip
  [+] addresses.mac
  [+] addresses.hostnames
  [+] ip_mac_hostname.csv
  [+] ip_hostname.csv

It is recommended to create a directory called `~/tools/` and alias the shell script's full path to the `~/.bashrc`, which makes it convenient to run the script from anywhere in the filesystem.
For example, you can create a file in `~/.foo` with the following:
  `alias ipmac='~/tools/mac_ip.sh'`

And then add the following line to the `~/.bashrc`:
  `source ~/.foo`

####################
# Steps for running the script
# Two ways to run the script:
# A text file comprising the subnets.
`while read -r subnet
do
  fping -ag $subnet
done < subnets.txt 2> /dev/null 1>hosts.txt`

`~/tools/mac_ip.sh hosts.txt` # or `ipmac hosts.txt` if aliasing is done.

# A single subnet
`fping -ag $SUBNET | tee hosts.txt`

# Run the command, feeding it the HOSTS file.
`~/tools/mac_ip.sh hosts.txt` # or `ipmac hosts.txt` if aliasing is done.
