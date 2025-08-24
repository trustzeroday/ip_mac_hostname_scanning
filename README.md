# ip_mac_hostname_scanning
Shell script for scanning and enumerating IP and MAC addresses alongside their hostname, filtered from the `nbtscan` output.

Running this script requires a text file with the IP addresses of the hosts connected in the internal network, generating the following text files:

    [+] nbtscan.output
  
    [+] addresses.ip
  
    [+] addresses.mac
  
    [+] addresses.hostnames
  
    [+] ip_mac_hostname.csv
  
    [+] ip_hostname.csv

It is recommended to create a directory called `~/tools/` and source the shell script's full path to the `~/.bashrc`, which makes it convenient to run the script from anywhere in the filesystem.

For example, you can create a file in `~/.foo` with the following:
  
  `alias ipmac='~/tools/ipmac.sh'`

And then add the following line to the end of the file `~/.bashrc`:

  `source ~/.foo`

Doing it this way guarantees not messing with the `~/.bashrc` which can lead to some problems.

--------------------
# Two ways to run the script:
## A text file comprising the subnets

`while read -r subnet; do fping -ag $subnet; done < subnets.txt 2> /dev/null 1> hosts.txt`

Run the command, feeding it the HOSTS file.

`~/tools/ipmac.sh hosts.txt`

## A single subnet
`fping -ag $SUBNET | tee hosts.txt`

Run the command, feeding it the HOSTS file.

`~/tools/ipmac.sh hosts.txt`
