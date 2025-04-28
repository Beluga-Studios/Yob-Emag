
main:

if pinC.6 = 0 then ;if button pressed

dirsb = %00011111 ;Set direction of Port B as Output Pins
pinsb = %00000000 ;Set Port B Output Pins LOW
dirsc = %00011111 ;Set direction of Port C as Outout Pins
pinsc = %00011111 ;Set Port C Output Pins HIGH
tune c.5,4, (1,2,3) ;test speaker

endif
goto main
