---
title: "Intermediate Nmap: TryHackMe"
date: 2026-10-19
categories: [CTF, Networking, TryHackMe]
category_paths:
  - [CTF, TryHackMe]
  - [Networking, TryHackMe]
tags: ["networking", "nmap", "tryhackme"]
---

# Intermediate Nmap: TryHackMe


Replace `TARGET_IP` with the active room address. The screenshots show the address from the original session.
## 1. Scan the target
I ran a default **nmap** scan:
```bash
sudo nmap TARGET_IP
```
The scan listed port 22 as `ssh`, port 2222 as `EtherNetIP-1`, and port 31337 as `Elite`. These are Nmap's port labels from this default scan, not results from service-version detection:
![Screenshot](images/Pasted%20image%2020260826205132.png)

## 2. Read the service hint
Connect to port 31337 to read the supplied account details:
```sh
nc TARGET_IP 31337
```
![Screenshot](images/Pasted%20image%2020260826205238.png)
The service returns the SSH username and password.

**Recovered SSH credential:**
`ubuntu:Dafdas!!/str0ng`

## 3. Log in and inspect the home directory
```
ssh ubuntu@TARGET_IP
```

![Screenshot](images/Pasted%20image%2020260826205532.png)
The login starts in a minimal shell. I switched to Bash:
![Screenshot](images/Pasted%20image%2020260826210201.png)
I listed the visible and hidden files. The home directory contained only basic dotfiles.
![Screenshot](images/Pasted%20image%2020260826210214.png)
Search for the flag file:
```sh
find / -name 'flag.*' 2>/dev/null
```
![Screenshot](images/Pasted%20image%2020260826210513.png)
The file is `/home/user/flag.txt`; read it:
```sh
cat /home/user/flag.txt
```
![Screenshot](images/Pasted%20image%2020260826210539.png)

**Flag:**

```
flag{251f309497a18888dde5222761ea88e4}
```


## Findings

My **nmap** scan listed ports 22 (`ssh`), 2222 (`EtherNetIP-1`), and 31337 (`Elite`). I connected to port 31337 and it gave me the SSH login details. I then logged in and found `flag.txt` under `/home/user`. Room: [TryHackMe Intermediate Nmap](https://tryhackme.com/room/intermediatenmap).

## What I Learned

The port number alone didn't tell me much. Connecting to it gave me the useful hint, then **ssh** got me into the machine ([Nmap guide](https://nmap.org/book/man.html), [OpenSSH guide](https://man.openbsd.org/ssh)).
