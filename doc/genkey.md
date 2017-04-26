---
modulename: SSHD
title: /genkey/
giturl: gitlab.com/space-sh/sshd
weight: 200
---
# SSHD module: Generate key

Generate a new server key.


## Example

```sh
space -m sshd /genkey/ -- "/home/janitor/ssh_host_rsa_key"
```

Exit status code is expected to be 0 on success.
