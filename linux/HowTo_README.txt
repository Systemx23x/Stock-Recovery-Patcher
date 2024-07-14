0# Simply Extract from AP_xxxxxx_.tar.md5 the recovery.img.lz4

1# Copy recovery.img.lz4 in this Directory

2# run in WSL or Linux
   chmod 777 patch.sh
   bash patch.sh
   
3# Flash Created "patched-recovery.tar.md5" via Odin

   Make sure to hold the power button and Volume Up as soon as the phone 
   starts rebooting, otherwise the patched recovery will be overwritten 
   by the Samsung one when the phone boots into OneUI

5# After entering recovery, choose "Enter fastboot"

6# Flash an ARM64 A/B GSI with fastboot 
           fastboot flash system gsi-system.img

7# Go back into recovery and Wipe Data and Cache

8# Reboot!
