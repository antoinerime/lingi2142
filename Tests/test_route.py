from .utils import *


# Node to test, add new nodes in that list to test them
nodes = ["Halles", "Pythagore", "SH1C", "Michotte", "Stevin", "Carnoy"]


def get_all_ip():
    nodes_ips = []

    for node in nodes:
        nodes_ips.append(lookup_host_ip(node))
    return nodes_ips


def ping_nodes():
    node_ips = get_all_ip()

    for node in nodes:
        for ip in node_ips:
            out, err, p = execute_in_host(node, "ping6 -c 1 -n -W2" + ip)
            if p:  # TODO Printing method in utils
                print("Router 's' can't ping 's'".format(node, ip))
            else:
                print("Router 's' successfully ping 's'".format(node, ip))


def ping_provider():
    ip_200 = "fd00:200::b"
    ip_300 = "fd00:300::b"
    for node in nodes:
        out, err, p = execute_in_host(node, "ping6 -c 1 -n -W2" + ip_200)
        if p:
            print("Router 's' can't ping 's'".format(node, ip_200))
        else:
            print("Router 's' successfully ping 's'".format(node, ip_200))
        out, err, p = execute_in_host(node, "ping6 -c 1 -n -W2" + ip_200)
        if p:
            print("Router 's' can't ping 's'".format(node, ip_300))
        else:
            print("Router 's' successfully ping 's'".format(node, ip_300))


if __name__ == '__main__':
    ping_nodes()
    ping_provider()
