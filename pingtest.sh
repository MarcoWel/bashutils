#!/bin/bash
echo $(date '+%F %T') "PINGTEST started" | tee -a pinglog.txt
while true; do
  if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo $(date '+%F %T') "Network up" # | tee -a pinglog.txt
  else
    echo $(date '+%F %T') "Network down" | tee -a pinglog.txt
  fi
  sleep 1
done
