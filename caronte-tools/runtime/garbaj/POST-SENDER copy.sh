#!/bin/bash
# NON METTERE IN CARTELLA DEI LOG
CARONTEPORT=3333
SELFPORT=42777
IP="127.0.0.1"
USERNAME='root'
PASSWORD='e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11'

# Find the latest modified file that starts with 'log' and ends with '.pcap'
latest_file=$(find . -maxdepth 2 -type f -name 'log*.pcap' -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

# Check if we found a file
if [[ -n "$latest_file" ]]; then
  bash -c "curl -X 'POST' \
  'http://$USERNAME:$PASSWORD@$IP:$CARONTEPORT/api/pcap/upload' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -F 'file=@$latest_file;type=application/vnd.tcpdump.pcap' \
  -F 'flush_all=false' > output.json"

  token=$(jq -r '.session' < output.json)

  bash -c "wget --quiet --method=POST \
     --header="Content-Type: text/plain" \
     --header="Connection: close" \
     --body-data="$token" \
     "$IP:$SELFPORT""
fi


