import requests
import string
class Caronte:
    def __init__(self, address):
        self.address = address
        self.setupAddr = (address + "/setup")
        #self.setupAddr.translate('/','/')
        print(self.setupAddr)
        self.serviceAddr = (address + "/api/services")
        #self.serviceAddr.translate('//','/')
        print(self.serviceAddr)
        self.pcapAddr = (address + "/api/pcap/upload")
        #self.pcapAddr.translate('//','/')
        print(self.pcapAddr)
    def setup(self, server_address, username, password):
        headers = {
            'accept': '*/*',
            'Content-Type': 'application/json'
        }

        json = {
            "config": {
                "server_address": server_address,
                "flag_regex": "/^[A-Z0-9]{31}=$/",
                "auth_required": True
            },
            "accounts": {
                username: password
            }
        }

        return requests.post(self.setupAddr,headers=headers, json=json)

    def addService(self, port, name, index = 0,notes = ''):
        colors = ["#e53935","#d81b60","#8e24aa","#5e35b1","#3949ab","#1e88e5","#039be5","#00897b","#f9a825"] 
        headers = {
            'accept': 'application/json',
            'Content-Type': 'application/json'
        }
        
        json = {
            
            "port": port,
            "name": name,
            "color": colors[index],
            "notes": notes
        }
        return requests.put(self.serviceAddr,headers=headers, json=json)
    
    def sendPcap(self, path, name):
        headers = {
            'accept': 'application/json'
        }
        files = {
            'file': (name, open(path, 'rb'), 'application/vnd.tcpdump.pcap')
        }
        data = {
            'flush_all': 'false'
        }
        return requests.post(self.pcapAddr,headers=headers, files=files, data=data)


caronte = Caronte("http://127.0.0.1:42777")
#error1 = caronte.setup('79.35.222.240','root','a')
error2 = (caronte.addService(port=42777, name='test', index=1))
error3 = (caronte.sendPcap(path='caronte-tools/caronte-setup/logs/log_test.pcap', name='test.pcap'))

print (error2.text)