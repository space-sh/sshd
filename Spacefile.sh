#
# Copyright 2016 Blockie AB
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

clone os file

SSHD_DEP_INSTALL ()
{
    SPACE_CMDDEP="OS_IS_INSTALLED PRINT"

    PRINT "Checking for OS dependencies." "info"

    OS_IS_INSTALLED "sshd" "openssh"
    OS_IS_INSTALLED "ssh-keygen" "openssh"

    if [ "$?" -eq 0 ]; then
        PRINT "Dependencies found." "success"
    else
        PRINT "Failed finding dependencies." "error"
        return 1
    fi
}

SSHD_GENKEY ()
{
    SPACE_SIGNATURE="sshhostkeyfile"
    SPACE_CMDDEP="PRINT"

    local sshhostkeyfile="${1}"
    shift

    PRINT "Generate key as: ${sshhostkeyfile}."

    ssh-keygen -f "${sshhostkeyfile}"
}

SSHD_RUN ()
{
    SPACE_SIGNATURE="sshhostkeyfile port authorizedkeys configemplate"
    SPACE_CMDENV="CWD"
    SPACE_CMDDEP="PRINT"

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
