#no_data
setfreq m32
#Picaxe20M2

;Snap = LED picture at that SNAP of time
; 2022 Snake Game 25 LED multiplex, picaxe 20M2
;NPN BC370 transistors on c port, output to LED+ve , b port imports LED current -ve

let dirsB = %00011111 
let dirsC = %00011111

symbol tempB = b1 
symbol picaxePosition = b2     ;Speed of each frame (SNAP) ????   ;
symbol PlayerPosition = b4      ;player position across screen
symbol playerX = b3             ;how far X is player
symbol playerY = b9             ;how far Y is player
symbol playerSnapSpeed = b5       ;Speed of playerMove to appear like gravity exists.????
playerSnapSpeed = 25
;b6 = temp variable
symbol score = b7                      ;Counting number of scores
symbol picaxeDelay = b8         ; 
;b21/b9/b10 = calculate_number, or use temp variables?
symbol JoystickDirection = b11          ;
symbol highscore = b12                ;highscore tracker
write 10,b12                                  ;write the highscore to EEPROM position 10
symbol picaxeMiss = b13            

symbol tempW = w11                     ;;temporary word variable
symbol randomNumber = w12        ;random number word variable

;**********************************************

;************************************************************
                        
;**************Check Joystick Start, then countdown***************

CheckStart:
playerX = 3
playerY = 3
picaxeDelay = 0
picaxeMiss = 0
playerSnapSpeed = 25
;random randomNumber
gosub randomBegin

for tempW = 1 to 400
gosub horz3
next
;tune C.5,2,(0,3,5,7,10)
for tempW = 1 to 300
gosub twothree
gosub threethree
gosub fourthree
next
for tempW = 1 to 200
gosub threethree
next
for tempW = 1 to 300
gosub twothree
gosub threethree
gosub fourthree
next

readadc b.6,b1
if b1 > 135 or b1 < 120  then

   for tempB = 1 to 240
      gosub number3
   next
   sound c.5,(40,80)
   for tempB = 1 to 130
      gosub number2
   next
  sound c.5,(45,80)
  for tempB = 1 to 80
     gosub number1
  next
  sound c.5,(48,50)
  goto main
endif
goto checkstart

;tune c.5,2,(1,5,7,16)
#rem
Intro:
;#rem
for b1 = 1 to 150
gosub S
next
;sound c.5,(115,20,110,20,105,20,100,20)
for b1 = 1 to 140
gosub T
next
;sound c.5,(100,20,105,20,110,20,115,20)
for b1 = 1 to 130
gosub LetterA
next
;sound c.5,(115,20,110,20,105,20,100,20)
for b1 = 1 to 120
gosub R
next

;for b1 = 1 to 150
;gosub S
;next
;next
#endrem 


#rem
test:

do until playerX = 5
for b6 = 1 to playerSnapSpeed
gosub playerMove                              ;Flash player height
next
inc playerX
inc playerY

loop
goto test
#endrem

;playerX = 3
;playerY = 3
;***************Main Loop***********************
main:
   random randomNumber
  ; gosub snapCheck   ;check snap position
   gosub joystickCheck   ;Is the button being pushed? then inc or dec playerheight
   gosub nextPlayerPosition
   gosub nextPicaxePosition
   gosub playerMoveSnap   
   gosub checkPlayerPicaxe

goto main
;**************End of main Loop ******************

;*****Where playerMove and picaxemove are put together*****************************
playerMoveSnap:
for b6 = 1 to playerSnapSpeed
   if playerSnapSpeed < 15 then
      playerSnapSpeed = 15
   endif
   gosub playerMove                              ;Flash player position
   gosub picaxeMove
next
for b6 = 1 to playerSnapSpeed
   gosub playerMove                              ;Flash player position
;gosub picaxeMove
   
next
dec playerSnapSpeed
return

;****************************************************************
;*********Random generator 1-25 **********************************
randomBegin: 

random randomNumber               ;Use random algorithm to change value in beepnext variable
picaxePosition = randomNumber//25   ;Modulo Divide beepNext by 2 to get REMAINDER   0 or 1      ;
return
;*****************************************************

;****Decide picaxe position/Number of Misses/number of blinks**********************************
nextPicaxePosition:
inc picaxeDelay
if picaxeDelay < 10 then
   return
endif
if picaxeMiss > 6 then
   goto endgame
endif

inc picaxeMiss
for b6 = 20 to 10 step -2
   for b1 = 1 to 60
   gosub picaxeMove  
   next 
   sound c.5,(b6,30)                    
next
gosub randomBegin
picaxeDelay = 0
return
;************************************************
checkPlayerPicaxe:
If playerPosition = picaxePosition then
inc score 
for b6 = 1 to 8
gosub playerMove                              ;Flash player position
gosub picaxeMove
tune c.5,1,(b6)                        
next
picaxeDelay = 0
gosub randomBegin
endif
return


;*************Read Joystick**************************************

joystickCheck:
readadc b.6,b1
if b1 < 110 then;and playerX < 5 then
   ;inc playerX
   JoystickDirection = 2
   sound c.5,(50,5)
elseif b1 > 145 then;and playerX > 1 then   
   ;dec playerX   
    JoystickDirection = 1
   sound c.5,(30,5)   
endif     

readadc b.5,b6
if b6 > 145 then;and playerY < 5 then
   ;inc playerY
    JoystickDirection = 3
   sound c.5,(70,5)
elseif b6 < 110 then;and playerY > 1 then   
   ;dec playerY  
    JoystickDirection = 4 
   sound c.5,(90,5)   
endif   
return


;**************Decide next player position**********************************

nextPlayerPosition:
;Left = 1, Right = 2, up = 3, down = 4
offScreen:
;down bottom
if  JoystickDirection = 4 and playerY = 1 then
   playerY = 5
;Up Top
elseif  JoystickDirection = 3 and  playerY = 5 then 
   playerY = 1
;Right right
elseif  JoystickDirection = 2 and  PlayerX = 5 then 
 playerX = 1 
;Left left
elseif  JoystickDirection = 1 and  PlayerX = 1 then
playerX = 5
 
onScreen:
elseif JoystickDirection = 3 and playerY < 5 then
   inc playerY

elseif JoystickDirection = 4 and playerY > 1 then
   dec playerY

elseif JoystickDirection = 2 and playerX < 5 then
   inc playerX

elseif JoystickDirection = 1 and playerX > 1 then
   dec playerX
endif
joystickDirection = 0
return

;******PlayerXY positions************************************
playerMove:
;Y=1
if playerX = 1 and playerY = 1 then
   gosub oneone
   playerPosition = 1
elseif playerX = 2 and playerY = 1 then
   gosub twoone
   playerPosition = 2
elseif playerX = 3 and playerY = 1 then
   gosub threeone
   playerPosition = 3
elseif playerX = 4 and playerY = 1 then
   gosub fourone
   playerPosition = 4
elseif playerX = 5 and playerY = 1 then
    gosub fiveone
playerPosition = 5
endif

;Y=2
if playerX = 1 and playerY = 2 then
    gosub onetwo
   playerPosition = 6
elseif playerX = 2 and playerY = 2 then
   gosub twotwo
   playerPosition = 7
elseif playerX = 3 and playerY = 2 then
   gosub threetwo
   playerPosition = 8
elseif playerX = 4 and playerY = 2 then
   gosub fourtwo
   playerPosition = 9
elseif playerX = 5 and playerY = 2 then
    gosub fivetwo
    playerPosition = 10
endif

;Y=3
if playerX = 1 and playerY = 3 then
    gosub onethree
   playerPosition = 11
elseif playerX = 2 and playerY = 3 then
   gosub twothree
   playerPosition = 12
elseif playerX = 3 and playerY = 3 then
   gosub threethree
   playerPosition = 13
elseif playerX = 4 and playerY = 3 then
   gosub fourthree
   playerPosition = 14
elseif playerX = 5 and playerY = 3 then
    gosub fivethree
   playerPosition = 15
endif

;Y=4
if playerX = 1 and playerY = 4 then
    gosub onefour
   playerPosition = 16
elseif playerX = 2 and playerY = 4 then
   gosub twofour
   playerPosition = 17
elseif playerX = 3 and playerY = 4 then
   gosub threefour
   playerPosition = 18
elseif playerX = 4 and playerY = 4 then
   gosub fourfour
   playerPosition = 19
elseif playerX = 5 and playerY = 4 then
    gosub fivefour
    playerPosition = 20
endif

;Y=5
if playerX = 1 and playerY = 5 then
    gosub onefive
   playerPosition = 21
elseif playerX = 2 and playerY = 5 then
   gosub twofive
   playerPosition = 22
elseif playerX = 3 and playerY = 5 then
   gosub threefive
   playerPosition = 23
elseif playerX = 4 and playerY = 5 then
   gosub fourfive
   playerPosition = 24
elseif playerX = 5 and playerY = 5 then
    gosub fivefive
   playerPosition = 25
endif
return

;*************************************************
picaxeMove:
 
if picaxePosition = 0 then
   picaxePosition = 1
   gosub oneone
elseif picaxePosition = 1 then
   gosub oneone  
elseif picaxePosition = 2 then
   gosub twoone  
elseif picaxePosition = 3 then
   gosub threeone  
elseif picaxePosition = 4 then
   gosub fourone  
elseif picaxePosition = 5 then
    gosub fiveone
elseif picaxePosition = 6 then
    gosub onetwo
elseif picaxePosition = 7 then
   gosub twotwo
elseif picaxePosition = 8 then
   gosub threetwo
elseif picaxePosition = 9 then
   gosub fourtwo  
elseif picaxePosition = 10 then
    gosub fivetwo
elseif picaxePosition = 11 then
    gosub onethree  
elseif picaxePosition = 12 then
   gosub twothree
elseif picaxePosition = 13 then
   gosub threethree
elseif picaxePosition = 14 then
   gosub fourthree  
elseif picaxePosition = 15 then
    gosub fivethree
elseif picaxePosition = 16 then
    gosub onefour
elseif picaxePosition = 17 then
   gosub twofour
elseif picaxePosition = 18 then
   gosub threefour
elseif picaxePosition = 19 then
   gosub fourfour
elseif picaxePosition = 20 then
    gosub fivefour
elseif picaxePosition = 21 then
    gosub onefive
elseif picaxePosition = 22 then
   gosub twofive  
elseif picaxePosition = 23 then
   gosub threefive
elseif picaxePosition = 24 then
   gosub fourfive
elseif picaxePosition = 25 then
    gosub fivefive
endif
return


;******************Delay Routine for next block*************************************
;snapCheck:


;:**********************************
endGame:
sound c.5,(60,125,40,250,20,500,10,1000)
;for tempW = 1 to 400
;gosub onoff
;next

gosub playerScore
;debug
read 10, highscore 	;Read highest score into highscore
if score >= highScore then   ;Check highScore variable
   write 10, score           ;Write new Highscore
   pause 100
   gosub highScoreBling
endif
picaxeMiss = 0
score = 0
goto checkStart

;************************************
highScoreBling:
' Flntstn
;tune c.5,4,($28,$21,$01,$6A,$28,$21,$28,$66,$65,$65,$66,$68,$21,$23,$E5)

for tempW = 1 to 500
smile:
gosub onethree
gosub twotwo
gosub threetwo
gosub fourtwo
gosub fivethree
gosub twofive
gosub fourfive
next
;for tempW = 1 to 100
;gosub onOff
;next
return

;snap:
;return
#rem
#endrem
;********************************************************
;onOff:
;dirsC = %00010111
;pinsB = %00000000
;pinsC = %00011111
;pause b8
;pinsB = %00011111
;pinsC = %00000000
;return

oneOne:
;dirsC = %00010111
pinsB = %00001111
pinsC = %00010000
;pause b8
pinsB = %00011111
pinsC = %00000000
return

twoOne:
pinsB = %00001111
pinsC = %00001000
;pause b8
pinsB = %00011111
pinsC = %00000000
return

threeOne:
pinsB = %00001111
pinsC = %00000100
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fourOne:
pinsB = %00001111
pinsC = %00000010
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fiveOne:
pinsB = %00001111
pinsC = %00000001
;pause b8
pinsB = %00011111
pinsC = %00000000
return

oneTwo:
pinsB = %00010111
pinsC = %00010000
;pause b8
;dirsb = 0
pinsC = %00000000 
pinsB = %00011111

return

twoTwo:
pinsB = %00010111
pinsC = %00001000
;pause b8
;dirsb = 0
pinsC = %00000000 
pinsB = %00011111

return

threeTwo:
pinsB = %00010111
pinsC = %00000100
;pause b8
pinsC = %00000000 
pinsB = %00011111

return

fourTwo:
pinsB = %00010111
pinsC = %00000010
;pause b8
pinsC = %00000000 
pinsB = %00011111

return

fiveTwo:
pinsB = %00010111
pinsC = %00000001
;pause b8
pinsC = %00000000 
pinsB = %00011111
return

oneThree:
pinsB = %00011011
pinsC = %00010000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

twoThree:
pinsB = %00011011
pinsC = %00001000
;;pause b8
pinsB = %00011111
pinsC = %00000000 
return

threeThree:
pinsB = %00011011
pinsC = %00000100
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fourThree:
pinsB = %00011011
pinsC = %00000010
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fiveThree:
pinsB = %00011011
pinsC = %00000001
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

onefour:
pinsB = %00011101
pinsC = %00010000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

twofour:
pinsB = %00011101
pinsC = %00001000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

threefour:
pinsB = %00011101
pinsC = %00000100
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fourfour:
pinsB = %00011101
pinsC = %00000010
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fivefour:
pinsB = %00011101
pinsC = %00000001
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

onefive:
pinsB = %00011110
pinsC = %00010000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

twofive:
pinsB = %00011110
pinsC = %00001000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

threefive:
pinsB = %00011110
pinsC = %00000100
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fourfive:
pinsB = %00011110
pinsC = %00000010
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

fivefive:
pinsB = %00011110
pinsC = %00000001
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

;*************************************************************
vert1:
;dirsC = %00010111
pinsB = %00000000
pinsC = %00010000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

vert2:
;dirsC = %00010111
pinsB = %00000000
pinsC = %00001000
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

vert3:
;dirsC = %00010111
pinsB = %00000000
pinsC = %00000100
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

vert4:
;dirsC = %00010111
pinsB = %00000000
pinsC = %00000010
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

vert5:
;dirsC = %00010111
pinsB = %00000000
pinsC = %00000001
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

horz1:
;dirsC = %00010111
pinsB=%00001111
pinsC=%00011111
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

horz2:
;dirsC = %00010111
pinsB = %00010111
pinsC = %00011111
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

horz3:
;dirsC = %00010111
pinsB = %00111011
pinsC = %00011111
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

horz4:
;dirsC = %00010111
;pinsB = %00111101
;pinsC = %00011111
;;pause b8
;pinsB = %00011111
;pinsC = %00000000 
;return

horz5:
;dirsC = %00010111
pinsB = %00011110
pinsC = %00011111
;pause b8
pinsB = %00011111
pinsC = %00000000 
return

;*******************************************************
#rem
S:
gosub horz5
gosub horz1
gosub horz3
gosub onefour
gosub fivetwo
;gosub threeone
return

T:
gosub horz5
gosub vert3
;gosub vert5
return

LetterA:
gosub vert2
gosub vert4
gosub threethree
gosub threefive
;gosub twofour
return

R:
gosub vert1
gosub horz5
gosub horz3
gosub fivefour
gosub fourtwo
gosub fiveone
return

#endrem 

;***************************************************************

Number0:
gosub threeone
gosub threefive
gosub vert2
gosub vert4
return

Number1:
gosub vert3
gosub vert3
return

Number2:
gosub horz1
gosub twotwo
gosub threethree
gosub fourfour
gosub threefive
gosub twofive
gosub onefour
return

Number3:
gosub horz1
gosub horz5
gosub vert5
gosub fourthree
gosub threethree
return

Number4:
gosub vert4
gosub horz2
gosub threefour
gosub twothree
return

Number5:
gosub horz5
gosub horz3
gosub onefour
gosub fivetwo
gosub fourone
gosub threeone
gosub twoone
gosub oneone
return

Number6:
gosub horz5
gosub horz3
gosub horz1
gosub vert1
gosub fivetwo
return

Number7:
gosub horz5
gosub fivefour
gosub fourthree
gosub threetwo
gosub twoone
return

Number8:
gosub horz5
gosub horz3
gosub horz1
gosub vert1
gosub vert5
return

Number9:
gosub horz5
gosub horz3
gosub vert5
gosub onefour
gosub fivefour
return



;********************************************************
;#REM
playerScore:

;b21 = b1 /  100 // 10  ; MODULO divide number of hundreds, store in b21
'Calculate 100's
;if b7 > 10 then
'Calculate 10's
b10 = b7/  10 // 10 	; MODULO divide number of tens, store in b10
;else b1 = 0
;endif
'Calculate 1's
b9 = b7 // 10 		; MODULO divide number of ones, store in b9

;debug


Tens:
for tempW = 1 to 350
if  b10 = 0 then
gosub number0
elseif b10 = 1 then
gosub number1
elseif b10 = 2 then
gosub number2
elseif b10 = 3 then
gosub number3
elseif b10 = 4 then
gosub number4
elseif b10 = 5 then
gosub number5
elseif b10 = 6 then
gosub number6
elseif b10 = 7 then
gosub number7
elseif b10 = 8 then
gosub number8
elseif b10 = 9 then
gosub number9
endif
next
nap 5

Ones:
for tempW = 1 to 350
if b9 = 0 then
gosub number0
elseif b9 = 1 then
gosub number1
elseif b9 = 2 then
gosub number2
elseif b9 = 3 then
gosub number3
elseif b9 = 4 then
gosub number4
elseif b9 = 5 then
gosub number5
elseif b9 = 6 then
gosub number6
elseif b9 = 7 then
gosub number7
elseif b9 = 8 then
gosub number8
elseif b9 = 9 then
gosub number9
endif
next
nap 5

return
;#endrem
