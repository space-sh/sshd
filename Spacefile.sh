#
# Copyright 2016-2017 Blockie AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Disable warning about indirectly checking status code
# shellcheck disable=SC2181

#=====================
# SSHD_DEP_INSTALL
#
# Check dependencies for this module.
#
# Returns:
#   0: dependencies were found
#   1: failed to find dependencies
#
#=====================
SSHD_DEP_INSTALL()
{
    SPACE_DEP="OS_IS_INSTALLED PRINT"       # shellcheck disable=SC2034

    PRINT "Checking for OS dependencies." "info"

    if OS_IS_INSTALLED "sshd" "openssh-server" && OS_IS_INSTALLED "ssh-keygen" "openssh-server"; then
        PRINT "Dependencies found." "ok"
    else
        PRINT "Failed finding dependencies." "error"
        return 1
    fi
}

# Disable warning about local keyword
# shellcheck disable=SC2039

#=======================
# SSHD_CONFIG
#
# Configure the SSHD user config files
#
# Returns:
#   0: success
#   1: error
#
#=======================
SSHD_CONFIG()
{
    SPACE_SIGNATURE="configemplate"
    SPACE_DEP="PRINT FILE_ROW_PERSIST"   # shellcheck disable=SC2034
    SPACE_REDIR="<${1}"

    # File contents are fed on STDIN thanks to SPACE_REDIR
    # We don't need the filename.
    #local configtemplate="${1}"
    shift

    # This works for root, who can access all user dirs.
    local authorized_keys="%h/.ssh/authorized_keys"
    if [ "$(id -u)" != "0" ]; then
        # Set it to user space
        authorized_keys="${HOME}/sshd_authorized_keys"
        touch "${authorized_keys}"
    fi

    PRINT "Authorized keys: ${authorized_keys}."
    authorized_keys=$(printf "%s\\n" "${authorized_keys}" | sed 's/\//\\\//g')

    local sshdconfig="${HOME}/sshd_config"

    # Read from STDIN
    if ! sed "s/AUTHORIZED_KEYS_DIR/${authorized_keys}/g" >"${sshdconfig}"; then
        PRINT "Could not write to ${sshdconfig}" "error"
        return 1
    fi

    local sshdhostkeyfile="${HOME}/sshd_host_key_file"

    PRINT "Generate key as: ${sshdhostkeyfile}."
    if ! ssh-keygen -f "${sshdhostkeyfile}"; then
        PRINT "Could not generate key file" "error"
        return 1
    fi
}

# Disable warning about local keyword
# shellcheck disable=SC2039

#=====================
# SSHD_RUN
#
# Run ssh server
#
# Parameters:
#   $1: host key file
#   $2: port number
#   $3: authorized key file
#   $4: configuration template file
#
# Returns:
#   Non-zero on failure.
#
#=====================
SSHD_RUN()
{
    # shellcheck disable=SC2034
    SPACE_SIGNATURE="port"
    SPACE_DEP="PRINT"       # shellcheck disable=SC2034

    local port="${1}"
    shift

    local sshdhostkeyfile="${HOME}/sshd_host_key_file"
    local sshdconfig="${sshdhostkeyfile%/*}/sshd_config"

    local sshdbinary=
    if ! sshdbinary=$(which sshd); then
        PRINT "sshd not present" "error"
        return 1
    fi

    ${sshdbinary} -h "${sshdhostkeyfile}" -D -p "${port}" -f "${sshdconfig}" "$@"
}
