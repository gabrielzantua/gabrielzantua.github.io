---
title: "Undo: picoCTF"
date: 2026-10-18
categories: [CTF, picoCTF]
tags: [ctf, picoctf, undo]
---
# Undo: picoCTF


## General Skills
Connect using the host and port shown by the challenge, then reverse each displayed transformation in order.

### Step 1: Base64 decode
![Screenshot](images/Pasted%20image%2020260823165714.png)
The hint identifies Base64 encoding. Decode the input with:
```sh
base64 -d
```
![Screenshot](images/Pasted%20image%2020260823165829.png)

### Step 2: Reverse each line
![Screenshot](images/Pasted%20image%2020260823165923.png)
Use **rev** to reverse the characters in each input line:
```sh
rev
```
![Screenshot](images/Pasted%20image%2020260823170439.png)

### Step 3: Replace underscores
![Screenshot](images/Pasted%20image%2020260823170851.png)
Replace underscores with dashes:
```sh
tr '_' '-'
```
![Screenshot](images/Pasted%20image%2020260823171236.png)

### Step 4: Restore braces
![Screenshot](images/Pasted%20image%2020260823171334.png)
Replace parentheses with curly braces:
```sh
tr '()' '{}'
```

### Step 5: Apply ROT13
![Screenshot](images/Pasted%20image%2020260823171455.png)
ROT13 shifts each English letter 13 positions. Because the alphabet has 26 letters, applying it twice restores the original text. **tr** can apply the substitution:
```sh
tr 'A-Za-z' 'N-ZA-Mn-za-m'
```
![Screenshot](images/Pasted%20image%2020260823171917.png)


**Recovered flag:**

```
picoCTF{Revers1ng_t3xt_Tr4nsf0rm@t10ns_fa04039f}
```


## Findings

I reversed five text changes to recover the challenge flag: I decoded Base64, reversed each line, changed the dashes and braces back, then used ROT13.

## What I Learned

The trick that worked for me was undoing each change in the opposite order from how it was applied. GNU coreutils can decode [Base64](https://www.gnu.org/software/coreutils/manual/html_node/base64-invocation.html) and replace characters with [**tr**](https://www.gnu.org/software/coreutils/manual/html_node/tr-invocation.html). I used **rev** to reverse each line ([rev guide](https://github.com/util-linux/util-linux/blob/master/text-utils/rev.1.adoc)). The challenge is on [picoCTF](https://picoctf.org/).
