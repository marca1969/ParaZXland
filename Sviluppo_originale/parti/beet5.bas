restore beeth5
dur=0.35
for counter=1 to 9
    read multiplier,pitch
    if pitch<>0 then
        beep dur*multiplier,pitch-5
    Else
        pause dur*multiplier
    endif
next
:beeth5
data 1,7,1,7,1,7,2,3,0,8,1,5,1,5,1,5,2,2

