# SSHD module | [![build status](https://gitlab.com/space-sh/sshd/badges/master/build.svg)](https://gitlab.com/space-sh/sshd/commits/master)

Handles ssh daemon (server).



## /config/
	Configure SSHD for user space

	Make sure that SSHD is properly configured
	to be using an authorized_keys file.
	


## /run/
	Run a local SSHD server.

	Copy your pub key into the 'authorized_keys' file
	to be able to connect to the server.
	


# Functions 

## SSHD\_DEP\_INSTALL()  
  
  
  
Check dependencies for this module.  
  
### Returns:  
- 0: dependencies were found  
- 1: failed to find dependencies  
  
  
  
## SSHD\_CONFIG()  
  
  
  
Configure the SSHD user config files  
  
### Returns:  
- 0: success  
- 1: error  
  
  
  
## SSHD\_RUN()  
  
  
  
Run ssh server  
  
### Parameters:  
- $1: host key file  
- $2: port number  
- $3: authorized key file  
- $4: configuration template file  
  
### Returns:  
- Non-zero on failure.  
  
  
  
