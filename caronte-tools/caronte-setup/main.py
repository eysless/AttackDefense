from caronteInteract import *

password = 'e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'
ipVULNBOX = '79.35.222.240'

caronte = Caronte(f"http://root:{password}@127.0.0.1:3333")
error1 = caronte.setup(ipVULNBOX,'root',password)
controllo = 0
while not controllo:
    name = input("Name of the service: ")
    port = int(input("What port for service: "))
    selection = int(input("Do you want to set color? 1=yes, 0=no"))
    error2 = caronte.addService(port=port, name=name)


error3 = caronte.sendPcap(path='caronte-tools/caronte-setup/logs/log_test.pcap', name='test.pcap')