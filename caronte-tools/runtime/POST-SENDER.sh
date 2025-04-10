#!/bin/bash
# NON METTERE IN CARTELLA DEI LOG
CARONTEPORT=42777
SELFPORT=1111
IP="127.0.0.1"

# Find the latest modified file that starts with 'log' and ends with '.pcap'
latest_file=$(find . -maxdepth 2 -type f -name 'log*.pcap' -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)

# Check if we found a file
if [[ -n "$latest_file" ]]; then
  bash -c f"curl -X 'POST' \
  'http://$IP:$CARONTEPORT/api/pcap/upload' \
  -H 'accept: application/json' \
  -H 'Content-Type: multipart/form-data' \
  -F 'file=@$latest_file;type=application/vnd.tcpdump.pcap' \
  -F 'flush_all=false' > output.json"

  token=$(jq -r '.session' < output.json)

  bash -c f"curl -X POST http://$IP:$SELFPORT -d $token"
fi


