#!/usr/bin/env python
import utils

# Node to test, add new nodes in that list to test them
nodes = ["Halles", "Pythagore", "SH1C", "Michotte", "Stevin", "Carnoy"]


def get_all_ip():
    nodes_ips = dict()

    for node in nodes:
        nodes_ips[node] = (utils.lookup_host_ip(node))
    return nodes_ips


def ping_nodes():
    for node in nodes:
        for ip in node_ips[node]:
            out, err, p = utils.execute_in_host(current_node, "ping6 -c 1 -n -W2 " + ip)
            if p:  # TODO Printing method in utils
		print(out, err, p)
                print("Router {} can't ping {}".format(current_node, ip))
            else:
                print("Router {} successfully ping {}".format(current_node, ip))


def ping_provider():
    ip_200 = "fd00:200::b"
    ip_300 = "fd00:300::b"
    for ip in node_ips[current_node]:
        out, err, p = utils.execute_in_host(current_node, "ping6 -I" + ip + "-c 1 -n -W2" + ip_200)
        if p:
            print("Router {} can't ping {}".format(current_node, ip_200))
        else:
            print("Router {} successfully ping {}".format(current_node, ip_200))
        out, err, p = utils.execute_in_host(current_node, "ping6 -I" + ip + "-c 1 -n -W2" + ip_300)
        if p:
            print("Router {} can't ping {}".format(current_node, ip_300))
        else:
            print("Router {} successfully ping {}".format(current_node, ip_300))


if __name__ == '__main__':
    node_ips = get_all_ip()
    for node in nodes:
	for ip in node_ips[node]:
	    print(ip)
    for current_node in nodes:
        ping_nodes()
        ping_provider()
