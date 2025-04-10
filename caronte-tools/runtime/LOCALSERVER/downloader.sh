#!/bin/bash

PORT=42777
LOGID_FILE="logid.txt"

# Initialize log ID if file doesn't exist
if [[ ! -f "$LOGID_FILE" ]]; then
  echo 1 > "$LOGID_FILE"
fi

echo "Listening on port $PORT..."

while true; do
  nc -l -p "$PORT" | (
    CONTENT_LENGTH=0

    # Read headers
    while IFS= read -r LINE; do
      [[ "$LINE" == $'\r' || -z "$LINE" ]] && break
      if echo "$LINE" | grep -i '^Content-Length:' >/dev/null; then
        CONTENT_LENGTH=$(echo "$LINE" | cut -d':' -f2 | tr -d '\r' | xargs)
      fi
    done

    # Read body
    SESSIONID=""
    if [[ "$CONTENT_LENGTH" -gt 0 ]]; then
      IFS= read -r -n "$CONTENT_LENGTH" SESSIONID
    fi

    # Send response
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 2\r\nConnection: close\r\n\r\nOK"

    # Use a lock to prevent race conditions if multiple requests come in fast
    (
      flock -x 9

      LOGID=$(cat "$LOGID_FILE")

      if [[ -n "$SESSIONID" ]]; then
        echo "Received POST data: $SESSIONID"
        echo "Downloading: $SESSIONID"
        curl -s -X GET \
          "http://root:e26347d0c030e16a1446bcd4989722a3d4ed3bd9f6f2f0ec762c069b88ef1eefcdf4cbdb54ed5a3499963290e6c5d008cc5c44353872f08fa1d094e7a6701c11@localhost:3333/api/pcap/sessions/$SESSIONID/download" \
          -H 'accept: application/pcap' \
          -o "log_${LOGID}.pcap"

        # Increment log ID
        echo $((LOGID + 1)) > "$LOGID_FILE"
      else
        echo "No session ID received!"
      fi
    ) 9>"$LOGID_FILE.lock" # file lock for concurrent safety

  )
done
