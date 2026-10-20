---
title: "Windows Fundamentals"
date: 2026-08-21
categories: [Windows]
tags: [windows, fundamentals, tryhackme]
---

# Windows Fundamentals

I find Windows easier to study when I group the tools by the question they answer: who is signed in, what is running, where a setting lives, and what can reach the computer. These notes bring together the parts I want to remember from [Windows Fundamentals 1](https://tryhackme.com/room/windowsfundamentals1xbx), [2](https://tryhackme.com/room/windowsfundamentals2x0x), and [3](https://tryhackme.com/room/windowsfundamentals3xzx).

The screens and names can differ between Windows desktop and Server editions. Desktop Windows is made for interactive use; Windows Server can also host services for other devices, such as file sharing or AD DS. Home and Pro are desktop editions with different feature sets. I check the exact edition and any organization policy before expecting a feature to be available.

## The desktop and its settings

The desktop is the main workspace. I use the **Start menu** to open apps and settings, **Search** to find items, **Task View** to switch between open windows, and the **taskbar** to see running or pinned apps. The notification area is where Windows shows things such as network, sound, and the clock.

Windows has both the newer **Settings** app and the older **Control Panel**. Some settings are only in one place, and some links move between them, so searching for the setting by name can be quicker than remembering which menu contains it. **control.exe** opens Control Panel, and **UserAccountControlSettings.exe** opens the UAC slider on typical desktop installations.

## Files, folders, and access

Windows installs its system files under `C:\Windows`; `%windir%` is an environment variable that points to that folder. `C:\Windows\System32` contains many important system programs and libraries. A user's profile and personal folders are usually under `C:\Users\`.

NTFS (New Technology File System) is the usual file system for Windows system drives. Older formats such as FAT16 and HPFS are legacy formats; FAT32 is still useful for compatibility, but it cannot hold an individual file larger than 4 GB. NTFS supports larger files, journaling, compression, permissions, Encrypting File System (EFS), and alternate data streams. BitLocker works at the whole-volume level instead.

NTFS permissions control what a user or group can do with an object. Common permissions include **Full Control**, **Modify**, **Read & Execute**, **List folder contents**, **Read**, and **Write**. Permissions can pass down from a parent folder, so the access check may include inherited rules as well as rules set directly on a file. Microsoft's [access-control overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control) explains how permissions, groups, and inheritance fit together.

As a quick guide, **Read** lets someone view a file, **Write** lets them change it, and **Modify** adds the ability to delete it. **Full Control** also lets them change permissions or ownership. **List folder contents** applies to folders, while **Read & Execute** is commonly used for programs.

For a network share, I keep share permissions and NTFS permissions separate in my head. Both can affect access to a file over the network.

**EFS** encrypts individual files. **BitLocker** protects entire volumes, which is useful if a laptop or disk is lost or stolen. They solve different problems, and BitLocker can use a TPM to protect the key that unlocks the volume and check the startup state. Microsoft's [BitLocker overview](https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-overview) explains the relationship.

NTFS also supports alternate data streams (ADS), which attach a named stream of data to a file. Windows uses the `Zone.Identifier` stream to record that a file came from the Internet. Explorer does not show these streams in its normal file listing, so they can be easy to miss when only browsing folders.

## Accounts and administrator rights

A **local account** exists on one computer. A **domain account** is managed through an organization's Active Directory and can be used on domain-joined computers, depending on policy. Windows keeps each user's profile under `C:\Users\`; that profile holds the user's settings and folders such as Desktop, Documents, Downloads, and Pictures.

Windows permissions are commonly assigned to groups, then users are added to those groups. This is easier to manage than setting separate permissions for every person. A user's effective access depends on the account, its group memberships, and the permissions on the file or resource.

I also keep standard access separate from administrator access. A standard account is enough for ordinary work. User Account Control (UAC) prompts when an action needs administrator-level permission; it gives the user a chance to approve or deny that elevation. Its slider changes how often Windows asks; setting it to **Never notify** weakens those warnings, so I wouldn't use it as a routine fix. UAC reduces the chance that software silently runs with administrator rights, but it is not a replacement for antivirus or careful account management. Microsoft's [UAC overview](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/) describes the prompt and elevation process.

When I need to check the account context, **whoami** prints the signed-in account and `whoami /all` shows its groups and privileges. That helps me see which identity Windows is using before I try to explain an access result. On editions with the Local Users and Groups console, **lusrmgr.msc** opens it; the same account tools are also available through Computer Management. The **Remote Desktop Users** group can grant remote sign-in rights, subject to local policy and other access rules.

## Tools I come back to

- **Task Manager** shows running processes and resource use. Its tabs can show CPU and memory use, network activity, signed-in users, and startup apps. The shortcut is `Ctrl+Shift+Esc`.
- **compmgmt.msc** opens Computer Management. Under System Tools I can find Task Scheduler, Event Viewer, Shared Folders, Local Users and Groups, Performance Monitor, Device Manager, and Services. Shared Folders shows network shares, active sessions, and open files. Disk Management and WMI (Windows Management Instrumentation) Control are also available in this console.
- **msconfig** opens System Configuration. Common tabs cover General, Boot, Services, and Tools. Startup-app management varies by Windows version and may hand off to Task Manager. I use MSConfig mainly for startup and boot troubleshooting.
- **sysdm.cpl** opens System Properties. Its Advanced tab contains settings for visual performance, virtual memory (the paging file), startup and recovery, and crash dumps. I leave these alone unless I know what problem I am trying to solve.
- **msinfo32** shows a summary of hardware, components, and the software environment.
- **resmon** opens Resource Monitor for more detail about CPU, memory, disk, and network activity.
- **eventvwr.msc** opens Event Viewer. The Application, System, and Security logs can help explain what happened, but I still check the time, source, and surrounding events before drawing a conclusion.
- **regedit** opens Registry Editor. The registry stores settings for Windows, hardware, users, and applications. I treat edits carefully because a wrong change can break an application or Windows behavior.

In Services, a startup type such as **Automatic**, **Manual**, or **Disabled** controls when Windows can start a service. Manual does not mean the service can never start; Windows or another program can start it when needed. Disabling a service can break features that depend on it.

MSConfig's General tab can select Normal, Diagnostic, or Selective startup. Boot options include safe boot and a startup timeout. The Services tab can temporarily limit which services start, and Tools opens other Windows utilities. I use these settings to isolate a startup problem, then restore the normal configuration when I finish.

System Information groups details into Hardware Resources, Components, and Software Environment. The Software Environment section includes environment variables such as `ComSpec` (the path to Command Prompt) and `windir` (the Windows folder). Resource Monitor gives a live view of CPU, Memory, Disk, and Network use. Those views help me narrow down what is using resources before I change a setting.

The registry is arranged into keys and values. Common root hives include `HKEY_LOCAL_MACHINE` for machine-wide settings and `HKEY_CURRENT_USER` for the signed-in user. The other hives, such as `HKEY_CLASSES_ROOT`, `HKEY_USERS`, and `HKEY_CURRENT_CONFIG`, serve other system or user configuration purposes. I read a key before changing it and keep a recovery plan for important edits.

## Built-in security features

Windows Update delivers security, reliability, and feature updates. In a managed organization, update timing and policy may be controlled by administrators, so an individual computer may not offer the same choices as a home PC. The regular monthly security release is often called Patch Tuesday, but urgent fixes can arrive outside that schedule.

Windows Security is the place to review built-in protections such as Microsoft Defender Antivirus, firewall settings, app and browser controls, and device security. Defender includes quick, full, and custom scans, protection history for quarantined or allowed items, real-time checks, cloud protection, automatic sample submission, and Controlled Folder Access. Real-time protection should normally stay enabled. Exclusions should be narrow: an exclusion tells Defender to skip a file, folder, or process.

SmartScreen can warn about or block websites, downloads, and applications based on reputation. Exploit Protection provides system and application mitigations. I treat both as part of layered protection, not as a reason to ignore suspicious behavior.

Windows Firewall has **Domain**, **Private**, and **Public** profiles. Windows uses the Domain profile when it detects the joined domain, Private is for a network the user trusts, and Public is intended for networks such as cafés or airports. Rules can differ by profile, so I check which profile is active before deciding whether a rule is missing. Microsoft's [Windows Firewall overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/) describes how the profiles are selected.

A **Trusted Platform Module (TPM)** is a hardware security component that can protect cryptographic keys and help verify the startup state. **Core Isolation / Memory Integrity** uses virtualization-based security to help prevent untrusted or vulnerable code and drivers from loading into the Windows kernel. **BitLocker** encrypts a whole volume; when a TPM is available, Windows can use it to protect the key and check the startup state. If the machine cannot use a TPM, BitLocker can be configured with another startup protector, such as a USB startup key. Microsoft's [BitLocker overview](https://learn.microsoft.com/en-us/windows/security/information-protection/bitlocker/bitlocker-overview) explains these options.

**Volume Shadow Copy Service (VSS)** creates snapshots that Windows backup and restore features can use. A shadow copy can help recover an earlier version, but it is not a substitute for a separate backup; malware can also target recovery data. Restore points can be created or managed through System Protection. Windows keeps shadow-copy data in protected system storage, commonly under `C:\System Volume Information`; I wouldn't edit that folder by hand.

Windows tools can be used for normal administration or misused by an attacker. That is the idea behind **living off the land**: using tools already present on the system. A familiar Microsoft utility is not proof that an action is safe, so I pay attention to the command line, account, parent process, and timing.

## A few checks from the command line

I use **hostname** to see the computer name, **whoami** to see the current account, and `ipconfig /all` to review network settings. `netstat -ano` lists network connections with their process IDs; the PID can then be compared with a process in Task Manager. **Get-Process** and **Get-Service** give me process and service lists in PowerShell.

The **net** command has subcommands for local users, groups, shares, and other network settings. `net user` lists local accounts, and `net localgroup` lists local groups. For help with a subcommand, I use `net help user` or `net help localgroup`. **cls** clears the Command Prompt screen, and `command /?` shows a command's built-in help.

In PowerShell, `Get-Item -Path 'C:\path\file' -Stream *` can show alternate data streams on an NTFS file. The path is an example and needs to be replaced with a file I am allowed to inspect.

These tools give me facts to investigate. A process name or an unusual connection by itself is a lead to check, not proof that a computer is compromised.

For domain accounts, groups, and policies, see [Active Directory Basics]({{site.baseurl}}/posts/Active-Directory-Basics/).
