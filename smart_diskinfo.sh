#!/bin/bash

###############################################################################
# Get me some disk info!
###############################################################################

# ----
# No free variables!
# ----

set -o nounset

# ----
# Configure arrays depending on machine
# ----

declare -a SATA_DISKS
declare -a SCSI_DISKS
declare -a SATA_DISK_NAMES
declare -a SCSI_DISK_NAMES


COUNT=0
for I in $(ls /sys/block); do
  SATA_DISKS[$COUNT]="/dev/$I"
  SATA_DISK_NAMES[$COUNT]="/dev/$I"
  let COUNT=$COUNT+1
done

# ----
# SATA disk readout
# ----

I=0
while [[ -n ${SATA_DISKS[$I]:-""} ]]; do
   #
   # General disk info
   #
   DATA=`smartctl -a ${SATA_DISKS[$I]} | tr '\n' '~'`
   TAG1=`echo $DATA | perl -e 'if (<STDIN> =~ /(Device:|Device Model:)\s+(.*?)~/) { print $2 }'`
   TAG2=`echo $DATA | perl -e 'if (<STDIN> =~ /Serial (N|n)umber:\s+(.*?)~/) { print $2 }'`
   TAG3=`echo $DATA | perl -e 'if (<STDIN> =~ /Firmware Version:\s+(.*?)~/) { print $2 }'`
   TAG="$TAG1, $TAG2"
   if [[ -n $TAG3 ]]; then
      TAG="$TAG, $TAG3"
   fi
   # 
   # Vendor-specific attributes
   # 
   DATA=`smartctl -A ${SATA_DISKS[$I]} | tr '\n' '~'`
   #
   # --- One-liner output ---
   #
   OUTPUT="${SATA_DISK_NAMES[$I]:-'?'}:"
   #
   # Reallocated Sector Count, use raw value
   #
   RSEC=`echo $DATA  | perl -e 'if (<STDIN> =~ /Reallocated_Sector_Ct.*?(\d+)\s*~/) { print $1*1 }'`
   if [[ -z $RSEC ]]; then
      RSEC='?'
   fi
   OUTPUT="$OUTPUT realloc sectors: $RSEC"
   #
   # Temperature; use "value" and "raw value"
   #
   if [[ -n `echo $TAG1 | grep SAMSUNG` ]]; then
      # Use Raw Value:
      # 194 Temperature_Celsius     0x0022   065   056   000    Old_age   Always       -       35 (Lifetime Min/Max 11/40)
      TEMP_VAL=`echo $DATA  | perl -e 'if (<STDIN> =~ /Temperature_Celsius.*?(\d+)\s*\(Lifetime/) { print $1*1 }'`
   elif [[ -n `echo $TAG1 | grep WDC` ]]; then
      # Use Raw Value:
      # 194 Temperature_Celsius     0x0022   116   109   000    Old_age   Always       -       27
      TEMP_VAL=`echo $DATA  | perl -e 'if (<STDIN> =~ /Temperature_Celsius.*?(\d+)\s*~/) { print $1*1 }'`
   else
      # Use Value:
      TEMP_VAL=`echo $DATA  | perl -e 'if (<STDIN> =~ /Temperature_Celsius\s+0x\w+\s+(\d+)\s/) { print $1*1 }'`
   fi
   if [[ -z $TEMP_VAL ]]; then
      TEMP_VAL='?'
   fi
   OUTPUT="$OUTPUT, $TEMP_VAL °C"
   #
   # UDMA CRC errors, use raw value
   #
   UDMA_CRC_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /UDMA_CRC_Error_Count.*?(\d+)\s*~/) { print $1 }'`
   if [[ -z $UDMA_CRC_ERR ]]; then
      UDMA_CRC_ERR='?' 
   fi
   OUTPUT="$OUTPUT, UDMA CRC errors: $UDMA_CRC_ERR"
   #
   # Error rates, use value and threshold (values range from 254 to 0, higher is better. transform to percent)
   #
   READ_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /Raw_Read_Error_Rate\s+0x\w+\s+(\d+)\s+(\d+)\s+(\d+)\s/) { print int($1*100/254) . "%[" . int($3*100/254) . "%]" }'` 
   if [[ -z $READ_ERR ]]; then
      READ_ERR='?'
   fi
   OUTPUT="$OUTPUT, raw read error rate: $READ_ERR"
   #
   # Seek error rates, use value and threshold (values range from 254 to 0, higher is better. transform to percent)
   #
   SEEK_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /Seek_Error_Rate\s+0x\w+\s+(\d+)\s+(\d+)\s+(\d+)\s/) { print int($1*100/254) . "%[" . int($3*100/254) . "%]" }'` 
   if [[ -z $SEEK_ERR ]]; then
      SEEK_ERR='?'
   fi
   OUTPUT="$OUTPUT, seek error rate: $SEEK_ERR"
   #
   # HW ECC recovered, if it exists use value and threshold (values range from 254 to 0, higher is better. transform to percent)
   #
   HW_ECC=`echo $DATA | perl -e 'if (<STDIN> =~ /Hardware_ECC_Recovered\s+0x\w+\s+(\d+)\s+(\d+)\s(\d+)\s/) { print int($1*100/254) . "%[" . int($3*100/254) . "%]" }'`
   if [[ -n $HW_ECC ]]; then
      OUTPUT="$OUTPUT, HW ECC recovered: $HW_ECC"
   fi
   #
   # Load Cycle Count, if it exists, use the raw value
   #
   LOAD_CYC_COUNT=`echo $DATA | perl -e 'if (<STDIN> =~ /Load_Cycle_Count.*?(\d+)\s*~/) { print $1 }'`
   if [[ -n $LOAD_CYC_COUNT ]]; then
      OUTPUT="$OUTPUT, load cycle count: $LOAD_CYC_COUNT"
   fi
   #
   # DONE
   #
   echo "$OUTPUT ($TAG)"
   let I=$I+1
done

# ----
# SCSI disk readout
# ----

I=0
while [[ -n ${SCSI_DISKS[$I]:-""} ]]; do
   #
   # General disk info
   #
   DATA=`smartctl -a  ${SCSI_DISKS[$I]} | tr '\n' '~'`
   TAG1=`echo $DATA | perl -e 'if (<STDIN> =~ /Device:\s+(.*?)~/) { print $1 }'`
   TAG2=`echo $DATA | perl -e 'if (<STDIN> =~ /Serial number:\s+(.*?)~/) { print $1 }'`
   TAG="$TAG1, $TAG2"
   #
   # Vendor specific SMART Attributes
   #
   DATA=`smartctl -A ${SCSI_DISKS[$I]} | tr '\n' '~'`
   RSEC=`echo $DATA  | perl -e 'if (<STDIN> =~ /Elements in grown defect list:\s*(\d+)\s*~/) { print $1 }'`
   TEMP=`echo $DATA  | perl -e 'if (<STDIN> =~ /Current Drive Temperature:\s*(\d+)\s*C~/)    { print $1 }'`
   #
   # Error log
   #
   DATA=`smartctl --log=error ${SCSI_DISKS[$I]} | tr '\n' '~'`
   R_CORR_ERR=`echo $DATA  | perl -e 'if (<STDIN> =~ /~read:\s+\d+\s+\d+\s+\d+\s+(\d+)\s/)                        { print $1 }'`
   W_CORR_ERR=`echo $DATA  | perl -e 'if (<STDIN> =~ /~write:\s+\d+\s+\d+\s+\d+\s+(\d+)\s/)                       { print $1 }'`
   V_CORR_ERR=`echo $DATA  | perl -e 'if (<STDIN> =~ /~verify:\s+\d+\s+\d+\s+\d+\s+(\d+)\s/)                      { print $1 }'`
   R_XCORR_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /~read:\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\.\d+\s+(\d+)/)   { print $1 }'`
   W_XCORR_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /~write:\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\.\d+\s+(\d+)/)  { print $1 }'`
   V_XCORR_ERR=`echo $DATA | perl -e 'if (<STDIN> =~ /~verify:\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+\.\d+\s+(\d+)/) { print $1 }'`
   NM_ERR=`echo $DATA      | perl -e 'if (<STDIN> =~ /Non-medium error count:\s*(\d+)\s*~/)                       { print $1 }'`
   #
   # --- One-liner output ---
   #
   OUTPUT="$SCSI_DISK_NAMES[$I]:"
   if [[ -z $RSEC ]]; then
      RSEC='?'
   fi
   OUTPUT="$OUTPUT realloc sectors: $RSEC"
   if [[ -z $TEMP ]]; then
      TEMP='?'
   fi
   OUTPUT="$OUTPUT, $TEMP °C"
   if [[ -z $NM_ERR ]]; then
      NM_ERR='?'
   fi
   OUTPUT="$OUTPUT, non-medium errors: $NM_ERR"
   if [[ -z $R_CORR_ERR ]]; then
      R_CORR_ERR='?'
   fi
   if [[ -z $W_CORR_ERR ]]; then
      W_CORR_ERR='?'
   fi
   if [[ -z $V_CORR_ERR ]]; then
      V_CORR_ERR='?'
   fi
   OUTPUT="$OUTPUT, corrected errors (R/W/V): ($R_CORR_ERR/$W_CORR_ERR/$V_CORR_ERR)"
   if [[ -z $R_XCORR_ERR ]]; then
      R_XCORR_ERR='?'
   fi
   if [[ -z $W_XCORR_ERR ]]; then
      W_XCORR_ERR='?'
   fi
   if [[ -z $V_XCORR_ERR ]]; then
      V_XCORR_ERR='?'
   fi
   OUTPUT="$OUTPUT, noncorrected errors (R/W/V): ($R_XCORR_ERR/$W_XCORR_ERR/$V_XCORR_ERR)"
   let I=$I+1
   echo "$OUTPUT ($TAG)"
done


