---
modulename: SSHD
title: /run/
giturl: gitlab.com/space-sh/sshd
weight: 200
---
# SSHD module: Run

Run a local _SSHD_ server.


## Example

First generate the server host key:  
```sh
$ space /m sshd /genkey/
```

Default _SSHD_ server start:
```sh
$ space -m sshd /run/
```

_SSHD_ server start on port 22 and customized file paths:
```sh
$ space -m sshd /run/ -- "/home/janitor/ssh_host_rsa_key" "22" "/home/janitor/authorized_keys"
```

Exit status code is expected to be 0 on success.
