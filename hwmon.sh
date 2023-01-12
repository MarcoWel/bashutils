#!/bin/bash
stress --cpu 4 &
while true;
do
        timestamp=`date "+%Y-%m-%d %H:%M:%S"`;

        cpuSpeed0=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq);
        cpuSpeed1=$(($cpuSpeed0/1000));

        gpuTemp=$(/opt/vc/bin/vcgencmd measure_temp);

        cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp);
        cpuTemp1=$(($cpuTemp0/1000));
        cpuTemp2=$(($cpuTemp0/100));
        cpuTempM=$(($cpuTemp2 % $cpuTemp1));

        cpuThrottled=$(vcgencmd get_throttled);

        echo $timestamp"  |  "GPU $gpuTemp"  |  CPU temp="$cpuTemp1"."$cpuTempM"'C  |  CPU freq"=$cpuSpeed1"MHz  |  "$cpuThrottled;

        sleep 1;
done
