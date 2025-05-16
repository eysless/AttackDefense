CARONTEPORT=1111
SELFPORT=42777
IP="10.81.63.4"
USERNAME='root'
PASSWORD='e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'

while true; do
    bash -c "scp -i /home/eysless/.ssh/personal -r root@10.60.63.1:/root/caronte/log/ ./"
    NEWFILE=$(find . -maxdepth 2 -type f -name 'log*.pcap' -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

    if [[ -n "$NEWFILE" ]]; then
        # Check if we found a file
        if [[ "$NEWFILE" != "$OLDFILE" ]]; then
            bash -c "curl -X 'POST' \
			'http://$USERNAME:$PASSWORD@$IP:$CARONTEPORT/api/pcap/upload' \
			-H 'accept: application/json' \
			-H 'Content-Type: multipart/form-data' \
			-F 'file=@$NEWFILE;type=application/vnd.tcpdump.pcap' \
			-F 'flush_all=false' > output.json"

            token=$(jq -r '.session' <output.json)

        fi
    fi
    OLDFILE=$NEWFILE
    sleep 30
done
