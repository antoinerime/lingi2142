#!/usr/bin/env python
import utils

# Node to test, add new nodes in that list to test them
nodes = ["Halles", "Pythagore", "SH1C", "Michotte", "Stevin", "Carnoy"]


def inside_HTTP_HTTPS_test():
    addr_list = ["fd00:200:7:13::1"]
    for node in nodes:
      for addr in addr_list:
          out, err, err_code = utils.execute_in_host(node,"wget " + addr)
    if err_code:
        print(node, " -- Could not make a HTTP-HTTPS request : this is normal")
        print(out)
        print(err)

def outside_HTTP_HTTPS_test():
    addr_list = ["http://www.google.com/" , "https://www.google.com"]
    for node in nodes:
      for addr in addr_list:
          out, err, err_code = utils.execute_in_host(node,"wget " + addr)
    if err_code:
        print(node, " -- Could not make a HTTP-HTTPS request")
        print(out)
        print(err)

def dig_test():
    addr_list = ["google.com"]
    for node in nodes:
      for addr in addr_list:
          out, err, err_code = utils.execute_in_host(node,"dig " + addr)
    if err_code:
        print(node, " -- Could not make a DNS request")
        print(out)
        print(err)

inside_HTTP_HTTPS_test()
dig_test()
outside_HTTP_HTTPS_test()
