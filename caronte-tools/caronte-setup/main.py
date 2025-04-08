import requests
class Caronte:
    def __init__(self, address):
        self.address = address
        self.setupAddr = (address + "/setup").translate('//','/')
        self.serviceAddr = (address + "/api/services").translate('//','/')
        self.pcapAddr = (address + "/api/pcap/upload").translate('//','/')

    def setup(server_address, username, password):
        headers = {
            'accept': '*/*',
            'Content-Type': 'application/json'
        }

        json = {
            "config": {
                "server_address": server_address,
                "flag_regex": "/^[A-Z0-9]{31}=$/",
                "auth_required": true
            },
            "accounts": {
                username: password
            }
        }

        return requests.post(self.setupAddr,headers=headers, json=json)

    def addService(port,name,index = 0,notes = ''):
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
        return requests.post(self.serviceAddr,headers=headers, json=json)
    
    def sendPcap(path):
        headers = {
            'accept': 'application/json',
            'Content-Type': 'multipart/form-data'
        }
        files = {
            'file': (path, open(path, 'rb'), 'application/vnd.tcpdump.pcap')
        }

        return requests.post(self.pcapAddr,headers=headers, json=json)
        

