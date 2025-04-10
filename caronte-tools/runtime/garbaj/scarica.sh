#!/bin/bash

PORT=42777
LOGID=1

echo "Listening on port $PORT..."

while true; do
  # Listen for a POST request and capture the entire HTTP request
  REQUEST=$(nc -l -p "$PORT" -q 1)

  # Extract the body of the POST request (everything after the empty line)
  SESSIONID=$(echo "$REQUEST" | sed -n '/^\r$/,$p' | tail -n +2)

  # Send an HTTP 200 OK response immediately after receiving data
  echo -e "HTTP/1.1 200 OK\r\n\r\nOK" | nc -N localhost $PORT 

  # Check if POST data was received
  if [[ -n "$SESSIONID" ]]; then
    echo "Received POST data: $SESSIONID"

    # Execute the data as a command (DANGEROUS!)
    echo "Downloading: $SESSIONID"
    bash -c "curl -X 'GET' 'http://root:e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11@localhost:3333/api/pcap/sessions/$SESSIONID/download' -H 'accept: application/pcap' > log_$LOGID.pcap"

    # Increment the log ID for the next file
    LOGID=$(( LOGID + 1))
  else
    echo "No session ID received in the POST data!"
  fi
done
