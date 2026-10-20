---
title: "aa-exec: pwn.college"
date: 2026-10-18
categories: [CTF, pwn.college]
tags: [ctf, pwn-college, aa-exec]
---
# aa-exec: pwn.college


## Check the sudo rule
The `sudo -l` output allows `/usr/bin/aa-exec` to run as root without a password.
![Screenshot](images/Pasted%20image%2020260911154156.png)

## Locate the flag
The search output shows the protected file at `/flag`:
![Screenshot](images/Pasted%20image%2020260911154208.png)

## Open a shell
I found a way to start a shell with **aa-exec** on [GTFOBins](https://gtfobins.github.io/gtfobins/aa-exec/). I ran it through the sudo rule, checked my user ID, then read the flag:
```bash
sudo -u root aa-exec /bin/sh
id
cat /flag
```
![Screenshot](images/Pasted%20image%2020260911154246.png)
![Screenshot](images/Pasted%20image%2020260911154524.png)

The shell is subject to the host's active AppArmor profile.

## Findings

I checked `sudo -l` and found I could run **aa-exec** as root. I used it to open a shell, checked my user ID, and read `/flag`. AppArmor can still limit what the shell can do.

## What I Learned

I had to check both the **sudo** permission and the AppArmor rules. Running **aa-exec** as root can open a shell, but the rules may still limit it. I checked the command in the [aa-exec manual](https://gitlab.com/apparmor/apparmor/-/blob/master/binutils/aa-exec.pod). The [pwn.college challenge](https://pwn.college/) provides this sudo rule.
