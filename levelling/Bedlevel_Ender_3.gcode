; BedPositioning for Ender 3
; Copyright G3P 2017 (Edited by QuietGanache 2018)
M140 S60 ; Set Heat Bed temperature
M104 S210 ; Set Extruder temperature
M190 S60 ; Wait for Heat Bed temperature
M109 S210 ; Wait for Extruder temperature
G28 ; Home all axis
M117 Purge extruder
G92 E0 ; Reset Extruder
G1 Z10 ; Lift Z axis
G1 X30 Y35 ; Move to Position 1
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X30 Y210 ; Move to Position 2
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X200 Y210 ; Move to Position 3
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X200 Y35 ; Move to Position 4
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X30 Y35 ; Move to Position 1
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X30 Y210 ; Move to Position 2
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X200 Y210 ; Move to Position 3
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
G1 X200 Y35 ; Move to Position 4
G1 Z0
M0 ; Pause print
G1 Z10 ; Lift Z axis
M104 S0 ; Turn off Extruder temperature
M140 S0 ; Turn off Heat Bed
M106 S0 ; Turn off Cooling Fan
M107 ; Turn off Fan
M84 ; Disable stepper motors
