#!/bin/bash
cpu_freq=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
cpu_temp=/sys/class/thermal/thermal_zone0/temp
if [ -e $cpu_freq ] ; then
  if [ -e $cpu_temp ] ; then
    while [ true ] ; do
      clk=$(cat $cpu_freq)
      cpu=$(cat $cpu_temp)
      dt=$(date '+%d/%m/%Y %H:%M:%S');
      #echo -ne $(($clk/1000))" Mhz / "$(($cpu/1000))" C"
      echo $dt" "$(($clk/1000))" Mhz / "$(($cpu/1000))" C"
      sleep 1
    done
  fi
fi
