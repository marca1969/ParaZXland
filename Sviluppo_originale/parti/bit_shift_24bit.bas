paper 7
border 7
ink 0
cls
for z=0 to 20:print at z,0;z:next
dim xiniz,x,y as ubyte
dim addr as uinteger
dim bit as ubyte

xiniz=12*2
x=xiniz
y=4
print at y,x/8;"XY"

do
    bit=0
    addr=16384+int(x/8)+32*y
    ' Address: 16384+int(column_pixel/8)+32*row
    ' Add 2048 for block 2 and 4096 for block 3
    do
        shift 1,addr
        bit=bit+1
    loop until bit=8
    x=x+8
    if x>230 then 
        x=xiniz
        print at y,x/8;"XY"
    endif
loop 


sub shift (direction as byte,addr as uinteger)
' 3-byte single bit-shift
    dim currentaddr as ulong
    dim byteval as ulong
    dim row,p0,p1,p2 as ubyte
    row=0  
    do
        'xth row of the char'
        ' 1 - reads the 24 bit value'
        currentaddr=addr+256*(row-1)
        byteval=peek(currentaddr)*65536+256*peek(currentaddr+1)+peek(currentaddr+2)
        ' 2 - shifts   
        if direction=1 then 
            byteval=byteval SHR 1
        endif
        if direction=-1 then 
            byteval=byteval SHL 1
        endif
        ' 3 - pokes new values'
        'p0=cast(ubyte,int(0.5+byteval/65536))
        'p1=cast(ubyte,(byteval/256-256*p0))
        'p2=cast(ubyte,byteval-256*(p1-p0*256))
        p0 = byteval >>16 
        p1 = byteval >>8 
        p2 = byteval 
        poke currentaddr,p0
        poke currentaddr+1,p1
        poke currentaddr+2,p2
        row=row+1
    loop until row=8
end sub
end