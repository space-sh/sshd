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
