mkdir -p ./log
chmod 777 ./log
sudo tcpdump -G 60 -i game port not 22 -w './log/log_%H_%M_%S.pcap'
