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

#=====================
# SSHD_GENKEY
#
# Generate server key
#
# Parameters:
#   $1: host file
#
# Returns:
#   Non-zero on failure.
#
#=====================
SSHD_GENKEY()
{
    SPACE_SIGNATURE="sshhostkeyfile"
    SPACE_DEP="PRINT"               # shellcheck disable=SC2034

    local sshhostkeyfile="${1}"
    shift

    PRINT "Generate key as: ${sshhostkeyfile}."

    ssh-keygen -f "${sshhostkeyfile}"
}

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
    SPACE_SIGNATURE="sshhostkeyfile port authorizedkeys configemplate"
    SPACE_ENV="CWD"         # shellcheck disable=SC2034
    SPACE_DEP="PRINT"       # shellcheck disable=SC2034

    local sshhostkeyfile="${1}"
    shift

    local port="${1}"
    shift

    local authorizedkeys="${1}"
    PRINT "Authorized keys: ${authorizedkeys}."
    authorizedkeys=$(echo "$authorizedkeys" | sed 's/\//\\\//g')
    shift

    local configtemplate="${1}"
    shift

    local sshdconfig="${CWD}/sshd_config"

    sed "s/AUTHORIZED_KEYS_DIR/${authorizedkeys}/g" "${configtemplate}" > "${sshdconfig}" || return 1

    $(which sshd) -h "${sshhostkeyfile}" -D -p "${port}" -f "${sshdconfig}" "$@"
}
