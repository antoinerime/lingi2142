#!/usr/bin/env python
import utils

nodes = ["Halles", "Pythagore", "SH1C", "Michotte", "Stevin", "Carnoy"]


def test_dns():
    for node in nodes:
   	print("Start pinging google.com on {}".format(node))
        out, err, err_code = utils.execute_in_host(node, "ping6 -c 1 -n -W2 google.com")
        if err_code:
            print("Could not ping google.com")
            print(out)
            print(err)

if __name__ == '__main__':
    test_dns()
