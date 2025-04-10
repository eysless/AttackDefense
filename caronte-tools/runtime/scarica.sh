#!/bin/bash

PORT=42777

echo "Listening on port $PORT..."
LOGID=1

while true; do
  # Listen for an HTTP POST request
  { 
    REQUEST=$(nc -l -p "$PORT" -q 1)

    # Send an HTTP 200 OK response
    echo -e "HTTP/1.1 200 OK\r\n\r\nOK" | nc -l -p "$PORT" -q 1 &

    # Extract POST data (everything after the empty line)
    SESSIONID=$(echo "$REQUEST" | sed -n '/^\r$/,$p' | tail -n +2)

    echo "Received POST data: $SESSIONID"

    # Execute the data as a command (DANGEROUS!)
    echo "Downloading: $SESSIONID"
    bash -c "curl -X 'GET'   'http://root:a@localhost:42777/api/pcap/sessions/$SESSIONID/download'   -H 'accept: application/pcap' > suca.pcap"
    LOGID=$(( LOGID + 1))
  }
done
