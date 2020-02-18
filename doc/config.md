---
modulename: SSH
title: /config/
giturl: gitlab.com/space-sh/sshd
editurl: /edit/master/doc/config.md
weight: 200
---
# SSH module: Configure SSH daemon

Generate a new server key, configures and makes sure that _SSHD_ is properly set up, in particular, enabling `authorized_keys` file.


## Example

```sh
space -m ssh /config/
```

Exit status code is expected to be 0 on success.
