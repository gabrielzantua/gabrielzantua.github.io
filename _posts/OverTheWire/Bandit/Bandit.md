---
title: "Bandit: OverTheWire"
date: 2026-10-18
categories: [CTF, OverTheWire]
tags: [ctf, overthewire, bandit, linux]
---
# Bandit: OverTheWire


This note covers my progress from Level 0 through Level 12.

Official game: [OverTheWire Bandit](https://overthewire.org/wargames/bandit/)
## Level 0 → Level 1
Read the password from the supplied `readme` file:
```sh
cat readme
```

**Password for Level 1:**
`6y2kwnwK6grgvwvpvLaa2T1cpFEKOhNR`


## Level 1 → Level 2
The filename is `-`. I used `./-` to tell **cat** to open that file instead of treating a bare `-` as standard input:
```sh
cat ./-
```

**Password for Level 2:**
`PK8fYLZg2hnHSz83plBL1iEPKdD3QToB`


## Level 2 → Level 3
Quote the filename so its spaces stay in one argument:
```sh
cat "spaces in this filename"
```

**Password for Level 3:**
`7ZZ2LFrykP2zEyvBl4m3clcL7tGYJPME`


## Level 3 → Level 4
The password is in a hidden file inside `inhere`:
```sh
cat inhere/.hidden
```

**Password for Level 4:**
`xzTXq1rDJQVVAzdv5cHq1TQytTWufAMq`


## Level 4 → Level 5
Identify which file in `inhere` contains text, then read it:
```sh
cat inhere/-file07
```

**Password for Level 5:**
`6C7h9GD8M6ai5nr7wo1RonrzFjj9yIrG`


## Level 5 → Level 6
Filter by the required size, then inspect the candidate's file type:
```sh
find inhere/* -type f -size 1033c -exec file {} \;
```

**Password for Level 6:**
`pXa26xhMWaC2SvDotA4r9EgZkulOeSBW`


## Level 6 → Level 7
Search by owner, group, and size; suppress permission errors:
```sh
find / -user bandit7 -group bandit6 -size 33c -type f 2>/dev/null
cat /var/lib/dpkg/info/bandit7.password
```

**Password for Level 7:**
`Bmnnvf82KzQlfxgAI2d1zYbr1u9pr3E3`


## Level 7 → Level 8
Search the data file for the line containing `millionth`:
```sh
cat data.txt | grep millionth
```

**Password for Level 8:**
`VR1ljMayciFxbnUokuQmJFw6QC9VKtub`


## Level 8 → Level 9
Sort first so duplicate lines are adjacent; `uniq -u` prints the unique line:
```sh
sort data.txt | uniq -u  # Need to sort bc uniq only detects duplicated lines that are adjacent. 
```

**Password for Level 9:**
`EjmOSvuAu7sGAHqHVcBDPirRe9T03kxl`


## Level 9 → Level 10
Extract printable strings and filter for the `=` marker:
```sh
strings data.txt | grep =
```

**Password for Level 10:**
`B0s2khmbT9u0geKuOoVGW3JZKhndE3BG`


## Level 10 → Level 11
Decode the Base64 data:
```sh
base64 -d data.txt
```

**Password for Level 11:**
`pYfOY6HwUsDj5rL9UvyhU7MCmv8vN5Ro`


## Level 11 → Level 12
Apply ROT13 to the text:
```sh
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m' #ROT13
```

**Password for Level 12:**
`GROozWPO8QyN0mGrjUkID0WCYkZiQxrN`


## Findings

I saved my steps from Level 0 through Level 11 → Level 12. The levels taught me to handle odd filenames, search by file properties, filter output, and decode Base64 and ROT13 text.

## What I Learned

I learned to pay attention to filenames and input format. `cat ./-` reads the file named `-`, while `cat "spaces in this filename"` keeps a spaced filename together as one argument. I used **find** to narrow files by size, owner, and group, then checked the matching file with **file**. I also sorted the lines before using `uniq -u`, searched binary files with **strings**, decoded Base64 with `base64 -d data.txt`, and used `tr 'A-Za-z' 'N-ZA-Mn-za-m'` for ROT13.
