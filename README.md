
### simple_diskinfo.sh

```bash
root@nas:~/smart_diskinfo# ./simple_diskinfo.sh
Checking Disks For Important Smart Errors...
DISK md0 -
----------------
DISK sda - Serial Number:    WD-WMC300538334
----------------
DISK sdb - Serial Number:    WD-WMC300557594
----------------
DISK sdc - Serial Number:    WD-WCAZA3699181
----------------
DISK sdd - Serial Number:    WD-WCAZA3696286
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       11
----------------
DISK sde - Serial Number:    WD-WCC1H0392262
----------------
DISK sdf - Serial Number:    WD-WMAZA3858032
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       1
----------------
DISK sdg - Serial Number:    WD-WMAZA3861898
----------------
DISK sdh - Serial Number:    WD-WMAZA3853707
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       4
----------------
DISK sdi - Serial Number:    143192400432
----------------
DISK sdj - Serial Number:    142811400132
----------------
DISK sdk - Serial Number:    CVPR131200RP120LGN
----------------
DISK sdl - Serial Number:    WD-WCAZA3698504
```

### smart_diskinfo.sh

Forked from dtonhofer/smart_diskinfo

```bash
root@nas:~/smart_diskinfo# ./smart_diskinfo.sh
/dev/md0: realloc sectors: ?, ? °C, UDMA CRC errors: ?, raw read error rate: ?, seek error rate: ? (, )
/dev/sda: realloc sectors: 0, 34 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 1001 (WDC WD20EFRX-68AX9N0, WD-WMC300538334)
/dev/sdb: realloc sectors: 0, 32 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 1001 (WDC WD20EFRX-68AX9N0, WD-WMC300557594)
/dev/sdc: realloc sectors: 0, 36 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 13299 (WDC WD20EARS-00MVWB0, WD-WCAZA3699181)
/dev/sdd: realloc sectors: 0, 39 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 13880 (WDC WD20EARS-00MVWB0, WD-WCAZA3696286)
/dev/sde: realloc sectors: 0, 38 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 104 (WDC WD20EARX-00ZUDB0, WD-WCC1H0392262)
/dev/sdf: realloc sectors: 0, 36 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 3084 (WDC WD20EARS-00MVWB0, WD-WMAZA3858032)
/dev/sdg: realloc sectors: 0, 37 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 3583 (WDC WD20EARS-00MVWB0, WD-WMAZA3861898)
/dev/sdh: realloc sectors: 0, 36 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 151987 (WDC WD20EARS-00MVWB0, WD-WMAZA3853707)
/dev/sdi: realloc sectors: 0, 68 °C, UDMA CRC errors: 0, raw read error rate: ?, seek error rate: ? (SanDisk SDSSDXPS480G, 143192400432)
/dev/sdj: realloc sectors: 0, 67 °C, UDMA CRC errors: 0, raw read error rate: ?, seek error rate: ? (SanDisk SDSSDXPS480G, 142811400132)
/dev/sdk: realloc sectors: 0, ? °C, UDMA CRC errors: ?, raw read error rate: ?, seek error rate: ? (INTEL SSDSA2CW120G3, CVPR131200RP120LGN)
/dev/sdl: realloc sectors: 0, 35 °C, UDMA CRC errors: 0, raw read error rate: 78%[20%], seek error rate: 78%[0%], load cycle count: 14277 (WDC WD20EARS-00MVWB0, WD-WCAZA3698504)
```

License
-------

Public domain!
