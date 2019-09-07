; BedPositioning for Ender 3
; Copyright G3P 2017 (Edited by QuietGanache 2018)
G90
M82
G28 ; Home all axis
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
M84 ; disable motors

