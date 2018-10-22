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
            out, err, err_code = utils.execute_in_host(current_node, "ping6 -c 1 -n -W2 " + ip)
            if err_code:  # TODO Printing method in utils
                ping_err[current_node][node].append(ip)
                # print("Router {} can't ping {}".format(current_node, ip))
            # else:
            # print("Router {} successfully ping {}".format(current_node, ip))


def ping_provider():
    ip_200 = "fd00:200::b"
    ip_300 = "fd00:300::b"
    for ip in node_ips[current_node]:
        out, err, err_code = utils.execute_in_host(current_node, "ping6 -I {} -c 1 -n -W2 {} ".format(ip, ip_200))
        if err_code:
            ping_err[current_node]["AS 200"].append(ip)
             # print("Router {} can't ping {}".format(current_node, ip_200))
        # else:
        # print("Router {} successfully ping {}".format(current_node, ip_200))
        out, err, err_code = utils.execute_in_host(current_node, "ping6 -I {} -c 1 -n -W2 {} ".format(ip, ip_300))
        if err_code:
            ping_err[current_node]["AS 300"].append(ip)
            # print("Router {} can't ping {}".format(current_node, ip_300))
        # else:
        #    print("Router {} successfully ping {}".format(current_node, ip_300))


def print_ping_err():
    for node in ping_err:
        print("-" * 7 + " " + node + " " + "-" * 7)
        if not ping_err[node]:
            print("Every ping succeed")
        else:
            for acc_node in ping_err[node]:
                for ip in ping_err[node][acc_node]:
                    print("Could not access {} on address {}".format(acc_node, ip))

def init_dict():
    AS = ["AS 200", "AS 300"]
    for node1 in nodes:
	ping_err[node1] = dict()
	for node2 in nodes:
	    ping_err[node1][node2] = list()
	for x in AS:
	    ping_err[node1][x] = list()


if __name__ == '__main__':
    ping_err = dict()
    node_ips = get_all_ip()
    init_dict()
    for current_node in nodes:
        ping_nodes()
        ping_provider()
    print_ping_err()
