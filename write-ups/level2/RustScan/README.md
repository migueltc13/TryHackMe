# RustScan

RustScan is the modern day port scanner.

Capable of scanning targets in less than a second, extensible scripting language allowing you to write scripts in Python, and more.

This room will teach you all there is need to know about RustScan.

You can find RustScan's GitHub repository [here](https://github.com/RustScan/RustScan).

---

Alternatively, you can get version 2.1.1 using docker: [getRustScan.sh](getRustScan.sh)

## Scan results

```bash
rustscan -a 10.10.141.167 -t 500 -- -A
```

```
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
The Modern Day Port Scanner.
________________________________________
: http://discord.skerritt.blog           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
😵 https://admin.tryhackme.com

[~] The config file is expected to be at "/home/rustscan/.rustscan.toml"
[~] File limit higher than batch size. Can increase speed by increasing batch size '-b 1048476'.
Open 10.10.141.167:22
Open 10.10.141.167:80
[~] Starting Script(s)
[>] Running script "nmap -vvv -p {{port}} {{ip}} -A" on ip 10.10.141.167
Depending on the complexity of the script, results may take some time to appear.
[~] Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-17 21:28 UTC
NSE: Loaded 151 scripts for scanning.
NSE: Script Pre-scanning.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
Initiating Ping Scan at 21:28
Scanning 10.10.141.167 [2 ports]
Completed Ping Scan at 21:28, 0.06s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 21:28
Completed Parallel DNS resolution of 1 host. at 21:28, 0.01s elapsed
DNS resolution of 1 IPs took 0.01s. Mode: Async [#: 1, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 21:28
Scanning 10.10.141.167 [2 ports]
Discovered open port 22/tcp on 10.10.141.167
Discovered open port 80/tcp on 10.10.141.167
Completed Connect Scan at 21:28, 0.06s elapsed (2 total ports)
Initiating Service scan at 21:28
Scanning 2 services on 10.10.141.167
Stats: 0:00:07 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 100.00% done; ETC: 21:28 (0:00:00 remaining)
Completed Service scan at 21:28, 6.26s elapsed (2 services on 1 host)
NSE: Script scanning 10.10.141.167.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 2.40s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.23s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
Nmap scan report for 10.10.141.167
Host is up, received syn-ack (0.058s latency).
Scanned at 2023-04-17 21:28:30 UTC for 10s

PORT   STATE SERVICE REASON  VERSION
22/tcp open  ssh     syn-ack OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 43:e4:c9:20:f6:5b:2f:59:ac:32:99:a9:63:73:f6:28 (DSA)
| ssh-dss AAAAB3NzaC1kc3MAAACBAJOfbiCBbCLzCXAe+oNnLXCXV+F+/rr8BfLqh5YkCovSpOCT/faylSiVExUnjz4VdchFPdPZHcQCLHPPO2s5BLMf0OYy1RZgf3H7OmY9Cfk9a8UaneN9vWRPnJ+dV61K4sMwc1uXiOhnihe2Ch0ONlQoIH0lfkDeceXxWa65k4GjAAAAFQCI5Ffn/WbVuSundMXHX/yW7eQHFwAAAIBYh0Z9MrO3NYhB5Ac8CkvrzNaAyJksrhSMLg6a9jiqlpyAZt3RxzaM7ZMzMR2kMMRP92vQOFpucmM4UHN5QKLWIdW+pRN814pM8TjcyjEFL+jyxA9EaKHEcr3Ow/wfQoQKxETPJKxfwK9Mk6VTLR9CqtYUmAcnkJtmMfxF5/M4hwAAAIAZmmpB84hAlE4pR3hFef19Js1ja2gQ+gm2QgCETACkczxeMDcOokvGx1PHZo5Sz03/F7ANu3FciyrkbGP0TdX2819YL0O+ZpAcZqBOinb8vqFo+smlU/t+4SXv2ZExms5sgPOa9uTUmn7IAO1+fV5NfR43gupJcX0wEzk6sr1BmA==
|   2048 03:af:f5:f9:b4:f2:f2:76:07:d0:13:40:79:31:75:b7 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7vUmVTpbrdPnxyuKitoZ6oSbxFi+pSHZkGznEw6GvdyIti7MhTq4J8lQ9knozAH0JfJXGB0TBqFJfCr8RE6q2CT7sNHvSWJedJnwB6tZnXUEA47F/WikO2nO2k1FXjHDia8zOkn/enY5/ofFbyFHLviDG0exlQV4s7pAmhbp8wyZSRgg3w+96Rx5lwaf3Fjqj0t/n7HYhFYL9kBPnjjFfpmDnaO1vBK0yfQE/NhA0UAVeeex4Kr9D06NR/F/WH2VhADUiindZqwSmHh1Owt2dzuyambT+NuHcqCjfhu5hC9XQIQ/E9XbrC31zUJqqPe+yk6NX9VoE/tOXLGLNM8dV
|   256 c9:c4:93:99:48:9b:ba:62:1c:d4:60:79:b4:c5:1d:c3 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMjtHWAVSqUQ1DviP5PwXU1a4V8QPK+f1QCdULdsuj+vqO1yKm5+S4UXVouLYNxQRJ5+2vfM1BeW2JFkqR5g7kU=
|   256 a9:17:4e:b8:1b:36:2c:72:00:13:e9:53:97:c6:77:62 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2T3a4jjn2nXcdf+T9ztPapKAHh6g1F4/nCRWbnwB+J
80/tcp open  http    syn-ack Apache httpd 2.4.7 ((Ubuntu))
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-favicon: Unknown favicon MD5: 69C728902A3F1DF75CF9EAC73BD55556
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
| http-robots.txt: 1 disallowed entry 
|_/
|_http-server-header: Apache/2.4.7 (Ubuntu)
| http-title: Login :: Damn Vulnerable Web Application (DVWA) v1.10 *Develop...
|_Requested resource was login.php
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 21:28
Completed NSE at 21:28, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.33 seconds
```

## More on RustScan

```
rustscan 2.1.1
Fast Port Scanner built in Rust. WARNING Do not use this program against sensitive infrastructure since the specified
server may not be able to handle this many socket connections at once. - Discord https://discord.gg/GFrQsGy - GitHub
https://github.com/RustScan/RustScan

USAGE:
    rustscan [FLAGS] [OPTIONS] [-- <command>...]

FLAGS:
        --accessible    Accessible mode. Turns off features which negatively affect screen readers
    -g, --greppable     Greppable mode. Only output the ports. No Nmap. Useful for grep or outputting to a file
    -h, --help          Prints help information
    -n, --no-config     Whether to ignore the configuration file or not
        --top           Use the top 1000 ports
    -V, --version       Prints version information

OPTIONS:
    -a, --addresses <addresses>...     A comma-delimited list or newline-delimited file of separated CIDRs, IPs, or
                                       hosts to be scanned
    -b, --batch-size <batch-size>      The batch size for port scanning, it increases or slows the speed of scanning.
                                       Depends on the open file limit of your OS.  If you do 65535 it will do every port
                                       at the same time. Although, your OS may not support this [default: 4500]
    -c, --config-path <config-path>    Custom path to config file
    -p, --ports <ports>...             A list of comma separed ports to be scanned. Example: 80,443,8080
    -r, --range <range>                A range of ports with format start-end. Example: 1-1000
        --scan-order <scan-order>      The order of scanning to be performed. The "serial" option will scan ports in
                                       ascending order while the "random" option will scan ports randomly [default:
                                       serial]  [possible values: Serial, Random]
        --scripts <scripts>            Level of scripting required for the run [default: default]  [possible values:
                                       None, Default, Custom]
    -t, --timeout <timeout>            The timeout in milliseconds before a port is assumed to be closed [default: 1500]
        --tries <tries>                The number of tries before a port is assumed to be closed. If set to 0, rustscan
                                       will correct it to 1 [default: 1]
    -u, --ulimit <ulimit>              Automatically ups the ULIMIT with the value you provided

ARGS:
    <command>...    The Script arguments to run. To use the argument -A, end RustScan's args with '-- -A'. Example:
                    'rustscan -T 1500 -a 127.0.0.1 -- -A -sC'. This command adds -Pn -vvv -p $PORTS automatically to
                    nmap. For things like --script '(safe and vuln)' enclose it in quotations marks \"'(safe and
                    vuln)'\"")
```
