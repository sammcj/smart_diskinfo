#/bin/bash
declare -a SMART_COMMAND

echo "Checking Disks For Important Smart Errors..."
for I in $(ls /sys/block); do
  SMART_COMMAND="smartctl -a /dev/$I"
  SERIAL="$(smartctl -a /dev/$I | grep -i serial)"

  echo "DISK $I - $SERIAL"
  $SMART_COMMAND | grep -v "\-       0" | grep Raw_Read_Error_Rate
  $SMART_COMMAND | grep -v "\-       0" | grep Reallocated_Event_Count
  $SMART_COMMAND | grep -v "\-       0" | grep Reallocated_Sector_Count
  $SMART_COMMAND | grep -v "\-       0" | grep Reported_Uncorrectable_Errors
  $SMART_COMMAND | grep -v "\-       0" | grep Command_Timeout
  $SMART_COMMAND | grep -v "\-       0" | grep Current_Pending_Sector_Count
  $SMART_COMMAND | grep -v "\-       0" | grep Offline_Uncorrectable
  echo "----------------"
done
