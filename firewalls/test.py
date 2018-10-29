#!/usr/bin/env python
import utils

# Node to test, add new nodes in that list to test them
nodes = ["Halles", "Pythagore", "SH1C", "Michotte", "Stevin", "Carnoy"]


def wget_http_https():
    addr_list = ["http://www.google.com/" , "https://www.google.com"]
    for node in nodes:
      for addr in addr_list:
          out, err, err_code = utils.execute_in_host("::1","wget " + addr)
    if err_code:
        print("Could not make a request to HTTP-HTTPS")
        print(out)
        print(err)
        

wget_http_https()
