#!/bin/bash
# NON METTERE IN CARTELLA DEI LOG
CARONTEPORT=1111
SELFPORT=42777
IP="10.81.63.7"
USERNAME='root'
PASSWORD='e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'

# Find the latest modified file that starts with 'log' and ends with '.pcap'
while true; do
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

      token=$(jq -r '.session' < output.json)

      bash -c "curl -X POST http://$IP:$SELFPORT \
      -H 'Connection: close' \
      -d $token \
      -v"
    fi
  fi
  OLDFILE=$NEWFILE
  sleep 30
done


