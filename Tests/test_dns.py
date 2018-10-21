#!/usr/bin/env python

nodes = ["Halles", "Pythagore", "SH1C", "Michootte", "Stevin", "Carnoy"]


def test_dns():
    for node in nodes:
        out, err, err_code = utils.execute_in_host(node, "ping6 -c 1 -n -W2 google.com")
    if err_code:
        print("Could not ping google.com")
        print(out)
        print(err)
