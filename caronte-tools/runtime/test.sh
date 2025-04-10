TESTICOLO=1
bash -c "curl -X 'GET'   'http://root:a@localhost:42777/api/pcap/sessions/54fb5617911f51ab3972cc33829b49f207e1b3e85fa93d212281a02982dab2d0/download'   -H 'accept: application/pcap' > suca$TESTICOLO.pcap"
