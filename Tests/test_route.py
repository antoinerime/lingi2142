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
                ping_succ[current_node] = False
                ping_err[current_node][node].append(ip)
                # print("Router {} can't ping {}".format(current_node, ip))
            # else:
            # print("Router {} successfully ping {}".format(current_node, ip))


def ping_provider():
    # ip_200 = "fd00:200::b"
    # ip_300 = "fd00:300::b"
    ip_google = "2a00:1450:400e:804::200e"
    for ip in node_ips[current_node]:
        out, err, err_code = utils.execute_in_host(current_node, "ping6 -I {} -c 1 -n -W2 {} ".format(ip, ip_google))
        if err_code:
            ping_err[current_node]["Google"].append(ip)
            ping_succ[current_node] = False
             # print("Router {} can't ping {}".format(current_node, ip_200))
        # else:
        # print("Router {} successfully ping {}".format(current_node, ip_200))


def print_ping_err():
    for node in ping_err:
        print("-" * 7 + " " + node + " " + "-" * 7)
	if ping_succ[node]:
	    print("All ping succeed !")
	else:            
            for acc_node in ping_err[node]:
	        for ip in ping_err[node][acc_node]:
		    print("Could not access {} on address {}".format(acc_node, ip))

def init_dict():
    # AS = ["AS 200", "AS 300"]
    for node1 in nodes:
	ping_err[node1] = dict()
	ping_succ[node1] = True
	for node2 in nodes:
	    ping_err[node1][node2] = list()
	ping_err[node1]["Google"] = list()
	# for x in AS:
	    # ping_err[node1][x] = list()


if __name__ == '__main__':
    ping_err = dict()
    ping_succ = dict()
    node_ips = get_all_ip()
    init_dict()
    for current_node in nodes:
        ping_nodes()
        ping_provider()
    print_ping_err()
