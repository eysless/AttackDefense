from caronteInteract import *

password = 'e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'
ipVULNBOX = '79.35.222.240'
indexone = 999
caronte = Caronte(f"http://root:{password}@127.0.0.1:3333")
error1 = caronte.setup(ipVULNBOX,'root',password)
controllo = 1
while controllo:
    name = input("Name of the service: ")
    port = int(input("What port for service: "))
    selection1 = int(input("Do you want to set color? 1=yes, 0=no: "))
    if selection1:
        indexone = int(input("Give me the index from 1 to 9: "))
    selection2 = int(input("Want to put a description? 1=yes, 0=no: "))
    if selection2:
        commentone = input("Write the description here: ")
    if selection1:
        if selection2:
            caronte.addService(port=port, name=name, index=indexone, notes=commentone)
        else:
            caronte.addService(port=port, name=name, index=indexone)
    else:
        if selection2:
            caronte.addService(port=port, name=name, notes=commentone)
        else:
            caronte.addService(port=port, name=name)
    controllo = int(input("Want to add another? 1=yes, 0=no: "))

