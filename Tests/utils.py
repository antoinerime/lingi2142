import os
import re
import subprocess


# --------- Execute some commands ------------------

def execute_in_host(host, command):
    """
        Execute command inside host
    """

    p = subprocess.Popen("sudo Tests/exec_command.sh 's' 's'".format(host, command), stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE, shell=True)

    output, err = p.communicate()

    return output.decode("utf-8"), err.decode("utf-8"), p.returncode


# ---------- Lookup commands ----------------------


def lookup_host_ip(host):
    """
        Lookup for all availabe ip of host

    """

    lines = os.popen('sudo Tests/exec_comand.sh' + host + "ip -f inet6 a | awk '/inet6 / { print $2 }").read()
    ips = re.findall(r'fd00:[2-3]00.7.*', lines)

    return ips
