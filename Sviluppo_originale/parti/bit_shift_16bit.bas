paper 7
border 7
ink 0
CLS
'Variables'
dim b(1 to 8) as ulong
dim coordx as ubyte
dim direction as byte
dim x as ubyte
dim baseaddr,addr as uinteger
' Start'
coordx=80
print at 0,coordx/8;"Z "
do
    print at 19,1;"Premi O o P..."
    do
        k$=inkey$
    loop while k$=""
    if k$="p" then direction=1
    if k$="o" then direction=-1
    coordx=coordx+direction
    ' Address: 16384+int(column/8)+32*row
    ' Add 2048 for block 2 and 4096 for block 3'
    'baseaddr=16384+int(0.5+coordx/8)
    baseaddr=16384+int(0.5+coordx/8)
    shift direction,baseaddr
loop

sub shift (direction as byte,addr as uinteger)
' 2-byte single bit-shift
    dim currentaddr as uinteger
    dim byteval as ulong
    dim row as ubyte  
    for row=1 to 8
        'xth row of the char'
        ' 1 - reads the 16 bit value'
        currentaddr=addr+256*(row-1)
        byteval=256*peek(currentaddr)+peek(currentaddr+1)
        ' 2 - shifts   
        if direction=1 then 
            byteval=byteval>>1
        elseif direction=-1 then 
            byteval=byteval<<1
        endif
        ' 3 - pokes new values'
        poke currentaddr,byteval >> 8 
        poke (currentaddr+1),byteval 
    next row
end sub
end