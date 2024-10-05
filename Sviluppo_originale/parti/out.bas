REM https://www.boriel.com/forum/portal.php?page=4

do
    'Bang1(0,5)
    heli()
    pause 1
loop while inkey$=""


sub blunero()
    'effetto senza suono
    dim x, y as uByte
    do until x = 255
        out 254,y/8+2
        y=x
        do until y>239
            y=y+16
        loop
        x=x+1
    loop
end sub

sub heli()
    dim x, y  as uByte
    dim color as uByte = 5
    do until x = 250
        out 254,y*8+color
        y=x/4
        do until y>230
            y=y+16
        loop
        x=x+2
    loop
end sub

sub soundBwop()
    dim x, y  as uByte
    dim color as uByte = 5
    do until x = 255
        out 254,y*8+color
        y=x
        do until y>239
            y=y+16
        loop
        x=x+1
    loop
end sub

sub blip
    dim counter1,counter2 as ubyte
    do 
        out 254, (counter1*8+2)
        counter1=counter2
        do 
            counter1=counter1+16
        loop until counter1>200
        counter2=counter2+1
    loop until counter2=100
    out 254,1
end sub

sub Bang(random as ubyte)
    dim x, y as uByte
    do until x = 40
        out 254, 5+(y * 4)*(1+rnd*random)
        let y = x
        do until y > 139
            let y = y + 16
        loop
        let x = x + 2
    loop
end sub

sub Bang1(random as ubyte,color as ubyte)
    dim x, y as uByte
    for x=1 to 20 step 2
        out 254, color+(y * 8)*(1+rnd*random)
        y = x
    next x
end sub
