
asm
    ld iy,$5c3a
end asm 

FUNCTION t() as uLong
asm 
    LD DE,(23674)
    LD D,0
    LD HL,(23672)
end asm
end function

'Memory addresses & system variables
const ScreenMem  as uinteger = $4000
const AttrMem    as uinteger = $5800
const UDGs       as uinteger = $5C7B 

dim UDGGame (167) as ubyte => {_
    003,000,063,000,255,000,007,000,_ 'A, 144, wind left
    028,162,050,004,248,000,224,016,_ 'B, 145, wind right
    192,192,255,255,000,000,000,000,_ 'C, 146, helicopter left
    008,254,255,255,255,125,063,015,_ 'D, 147, helicopter center
    000,000,192,112,120,255,252,024,_ 'E, 148, helicopter right
    024,060,126,255,126,090,153,024,_ 'F, 149, mine
    017,068,168,148,067,041,074,129,_ 'G, 150, explosion
    000,066,024,102,129,038,089,130,_ 'H, 151, splash
    128,128,128,192,192,224,248,255,_ 'I, 152, left bottom corner
    001,001,001,003,003,007,031,255,_ 'J, 153, right bottom corner
    255,248,224,192,192,128,128,128,_ 'K, 154, left top corner
    255,031,007,003,003,001,001,001,_ 'L, 155, right top corner
    000,007,120,243,246,112,063,012,_ 'M, 156, clowd left
    127,254,056,187,185,188,063,103,_ 'N, 157, clowd center
    000,240,088,110,207,031,254,120,_ 'O, 158, clowd bottom
    000,000,000,016,120,120,254,251,_ 'P, 159, top island
    000,000,000,000,000,024,060,126,_ 'Q, 160, top island
    001,003,003,007,007,014,059,118,_ 'R, 161, bottom island left
    153,161,012,034,050,078,065,248,_ 'S, 162, bottom island center left
    239,195,171,012,087,034,074,034,_ 'T, 163, bottom island center right
    032,112,240,216,252,252,127,247 _ 'U, 164, bottom island right
}

dim UDGSet          as uinteger at UDGs     'Pointer to the UDG address
UDGSet=@UDGGame(0)
cls
print at 0,1;"\C"+"\D"+"\E"
over 0
plot 12,191
draw 8,0

print at 0,0;"*";at 0,31;"*"

dim time as long
dim addr as uinteger = $4000+1
dim currentaddr as uinteger 
dim byteval as ulong
dim row as ubyte
dim counter1,counter2,p0 as ubyte
border 1
pause 2000
time=t()
do
    counter2=0   
    do       
        currentaddr=addr
        row=0
        do
            '1 - reads the 32 bit value
            byteval=peek(currentaddr)*2^24+peek(currentaddr+1)*2^16+peek(currentaddr+2)*2^8+peek(currentaddr+3)
            '2 - shifts   
            byteval=byteval>>1
            '3 - pokes new values
            poke currentaddr,byteval   >>24 
            poke currentaddr+1,byteval >>16 
            poke currentaddr+2,byteval >>8  
            poke currentaddr+3,byteval      
            row=row+1
            currentaddr=currentaddr+256
        loop until row=8
        counter2=counter2+1
        if 2*int(counter2/2)=counter2 then 
            over 1
            plot (counter1+1)*8+4+counter2,191
            draw 16,0
            over 0
            heli()
        end if    
    loop until counter2=8 
    heli()
    counter1=counter1+1
    if inkey$<>"" then exit do
    addr=addr+1
loop until counter1=27
newtime=(cast(float,t())-time)/50
print "Elapsed time: ";newtime;" s"
p0=(counter1)*8+(counter2)+4
print
print "Shift = ";p0;" pixel"
print
print "Scroll rate = ";int(0.5+p0/newtime);" pixel/s"
over 1
print at 21,5;flash 1;" Press any key to quit "
do
    plot p0,191
    draw 16,0
loop while inkey$=""

sub heli()
    dim x, y  as uByte
    dim color as uByte = 5
    for x=16 to 88 step 4
        out 254,8*(cast(ubyte,x/24))+color
    next x
end sub
