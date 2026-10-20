---
title: "Active Directory Basics"
date: 2026-08-21
categories: [Windows, Active Directory]
tags: [windows, active-directory, tryhackme]
---

# Active Directory Basics

I keep the AD picture simple: it stores identities and devices, domain controllers answer directory and sign-in requests, and permissions decide what each identity can do. This page pulls together my notes from TryHackMe's [Active Directory Basics](https://tryhackme.com/room/winadbasics) room. Here, **Active Directory** means the traditional Windows Server directory service, Active Directory Domain Services (AD DS). AD DS is a distributed directory database for information about users, computers, and other resources. Microsoft's [logical model overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/understanding-the-active-directory-logical-model) is a useful reference for the domain and forest terms.

## Domains and domain controllers

A **domain** is a managed group of accounts, computers, and other objects with a DNS name such as `corp.example.com`. It lets an organization manage identities centrally, while resource permissions still decide what each identity can use. A domain controller (DC) is a Windows Server that runs AD DS and provides directory and authentication services for that domain. Organizations usually have more than one DC so the directory can stay available and changes can replicate between servers. A domain can also contain child domains, such as `sales.corp.example.com`.

Domain-joined computers use the Domain Name System (DNS) to find domain controllers and other services. The DC Locator process looks up service records in DNS; Microsoft's [DC Locator documentation](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/dc-locator) explains how that discovery works.

Active Directory tools and applications often use Lightweight Directory Access Protocol (LDAP) to query or update directory objects. DNS helps a client find a domain controller; Kerberos or NTLM is then used for authentication. These names describe different parts of the process.

## The objects I see in a directory

- **User accounts** represent people or services that sign in.
- **Computer accounts** represent domain-joined machines. In many tools, a computer account's name ends in `$`; Windows manages and periodically changes its machine password.
- **Security groups** collect users and computers so permissions can be assigned to a group instead of one person at a time.
- **Organizational units (OUs)** organize objects and provide places to link policies or delegate specific administrative work.

Users, computers, and groups are **security principals**. Windows assigns them security identifiers (SIDs), which appear in access tokens and permissions. The distinction that helps me keep these straight is: groups are commonly used to assign access, while OUs organize objects and set policy or administration scope. Groups can contain other groups, so I check nested membership as well as direct membership when reviewing access. A user can be a member of several groups, but each directory object sits in one location in the directory tree at a time.

Some default groups are worth recognizing:

- **Domain Users**, **Domain Computers**, and **Domain Controllers** group common domain account types.
- **Domain Admins** has extensive control within its domain. **Enterprise Admins**, which lives in the forest root domain, has forest-wide administrative rights and should be kept very small.
- **Backup Operators** can back up and restore files despite normal file permissions. **Server Operators** can perform sensitive tasks on domain controllers. **Account Operators** can manage many accounts, but not the most privileged accounts and groups.

These operator groups aren't ordinary user groups. Membership gives more rights than their names might suggest, so I check what an account can actually do before treating it as low risk. Microsoft's [security-groups guide](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups) describes these built-in groups.

By default, some new user and computer accounts are created in the built-in `Users` and `Computers` containers. Those containers are not OUs, so you can't link a GPO to them directly. Administrators commonly move objects into OUs organized for their devices or teams. Workstations, member servers, and domain controllers may need different policies; domain controllers have their own default OU. Microsoft explains the distinction in its note on [redirecting the default containers](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/redirect-users-computers-containers).

In Active Directory Users and Computers, **Advanced Features** reveals extra object properties. OUs can be protected from accidental deletion. I leave that protection enabled unless I mean to remove the OU and have checked what it contains and which policies are linked to it. To delete an OU intentionally, the protection is changed in the OU's Properties under the Object tab, then the OU can be removed.

For a support team, the Delegate Control wizard can grant a narrow task, such as resetting passwords for users in one OU. I prefer that kind of scoped permission to broad domain administration.

## Group Policy and delegation

A Group Policy Object (GPO) holds **Computer Configuration** and **User Configuration** settings. It can be linked to an Active Directory site, domain, or OU. A policy's scope can also be filtered, so linking a GPO does not always mean every object in that location receives it. The Group Policy Management console is **gpmc.msc**.

The GPO has two related parts: its directory information is stored in AD, and its policy files are stored in SYSVOL on domain controllers. Both parts replicate. Microsoft's [Group Policy overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview) describes that setup.

Delegation is how an administrator gives someone a limited task, such as managing selected accounts in one OU or resetting passwords for a team. That is easier to control than making every support technician a Domain Admin. An OU can also be protected against accidental deletion; that protection should only be removed when the OU is intentionally being deleted.

Windows processes policy by scope, from the local computer through site and domain to the OU hierarchy. For settings that conflict, later policy in the hierarchy commonly takes precedence, but inheritance, enforced links, and filters can change the result. A GPO is not a group or a permission itself; some of its settings can configure permissions, firewall rules, and other security options.

## How a domain sign-in works

Authentication proves who is signing in. Authorization decides what that identity can access. I find it useful to check those separately when a user can sign in but cannot open a resource.

Kerberos is the preferred authentication protocol in an AD domain. Its Key Distribution Center (KDC) runs on domain controllers and uses the directory to verify accounts. The client first receives a ticket-granting ticket (TGT), then requests a service ticket for a specific service, and presents that ticket to the service. The tickets let the client access services without resending its password for each request. Microsoft's [Kerberos overview](https://learn.microsoft.com/en-us/windows-server/security/kerberos/kerberos-authentication-overview) walks through the exchange.

NTLM (NT LAN Manager) is an older challenge-response method that Windows still supports for compatibility and some local or workgroup situations. It does not send the user's password as readable text, but it has fewer protections than Kerberos. Seeing NTLM in a log tells me which authentication method was used; by itself, it does not prove an attack. Microsoft describes NTLM as supported for older application needs while [Kerberos is preferred for AD environments](https://learn.microsoft.com/en-us/windows-server/security/kerberos/ntlm-overview).

After authentication, Windows builds an access token containing the user's identity and group memberships. The target computer or service then checks that identity against its permissions. A trust relationship can let an account from one domain authenticate in another domain, but it does not automatically grant access to every resource there.

## Trees, forests, and trusts

A **tree** is a set of related domains with a connected DNS namespace, such as `sales.example.com` under `example.com`. A **forest** can contain one or more trees. Domains in a forest share core directory information: the schema defines object types and attributes, configuration data describes the forest, and the Global Catalog supports searches across domains. Domains in a forest also have built-in transitive trust relationships.

A trust can be one-way or two-way. Its direction describes which domain accepts authentication from the other. A trust creates a path for authentication; administrators still need to grant the required permissions to files, applications, or other resources.

## Commands I use to check the basics

- `whoami /groups` shows the groups in my current sign-in token.
- **dsa.msc** opens Active Directory Users and Computers; **gpmc.msc** opens Group Policy Management.
- `gpresult /r` summarizes the Group Policy settings applied to the current user and computer.
- `gpupdate /force` asks Windows to refresh policy. It does not change the GPO itself.
- `Get-ADUser -Identity "example.user"` looks up one directory user.
- `Get-ADGroupMember -Identity "ExampleGroup" -Recursive` lists direct and nested members of a directory group.
- `Set-ADAccountPassword -Identity "example.user" -Reset -NewPassword (Read-Host -AsSecureString -Prompt 'New password')` resets a user's password without putting the new value directly in the command.
- `Set-ADUser -Identity "example.user" -ChangePasswordAtLogon $true` requires the user to choose a new password at their next sign-in.

The PowerShell commands require the Active Directory module and the rights for the action. Password resets need delegated or administrative permission. When I troubleshoot access, I start with the account, its groups, the policy scope, and the permissions on the resource instead of assuming that a successful sign-in means access should work.

For the Windows tools underneath this, see [Windows Fundamentals]({{site.baseurl}}/posts/Windows-Fundamentals/).
