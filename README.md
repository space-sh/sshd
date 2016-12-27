# SSHD module | [![build status](https://gitlab.com/space-sh/sshd/badges/master/build.svg)](https://gitlab.com/space-sh/sshd/commits/master)

Handles ssh daemon (server).


## /genkey/
	Generate a server key


## /run/
	Run a local SSHD server.

	Copy your pub key into the 'authorized_keys' file
	to be able to connect to the server.


# Functions 

## SSHD\_DEP\_INSTALL ()  
  
  
  
Check dependencies for this module.  
  
### Returns:  
- 0: dependencies were found  
- 1: failed to find dependencies  
  
  
  
## SSHD\_GENKEY ()  
  
  
  
Generate server key  
  
### Parameters:  
- $1: host file  
  
### Returns:  
- Non-zero on failure.  
  
  
  
## SSHD\_RUN ()  
  
  
  
Run ssh server  
  
### Parameters:  
- $1: host key file  
- $2: port number  
- $3: authorized key file  
- $4: configuration template file  
  
### Returns:  
- Non-zero on failure.  
  
  
  