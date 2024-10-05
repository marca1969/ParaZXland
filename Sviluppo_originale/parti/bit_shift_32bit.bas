paper 7
border 7
ink 0
cls
print at 0,0;"XYZ"
dim addr as uinteger
dim x as uinteger
const pix as ubyte = 1
do
    ' Address: 16384+int(column_pixel/8)+32*row
    ' Add 2048 for block 2 and 4096 for block 3'
   addr=16384+int(x/8)+32*0
   shift pix,addr
   x=x+pix
   if x>=255 then
       print at 0,0;"XYZ"
       print at 1,0;"   "
       x=0
   end if 
loop while inkey$=""

sub shift (direction as byte,addr as uinteger)
' 4-byte single-bit shift
    dim currentaddr as ulong
    dim bytecontent(7) as ulong
    dim row,p0,p1,p2,p3 as ubyte
    dim shift as ubyte
    shift=cast(ubyte,direction)    
    row=0
    do
        '1 - reads the 32 bit value
        currentaddr=cast(ulong,addr+256*row)
        byteval=cast(ulong,peek(currentaddr)*2^24+peek(currentaddr+1)*2^16+peek(currentaddr+2)*2^8+peek(currentaddr+3))
        '2 - shifts   
        if direction>0 then 
            byteval=byteval SHR shift
        else
        byteval=byteval SHL shift
        endif
        '3 - pokes new values
        'p0=cast(ubyte,int(0.5+bytecontent(row)/2^24))
        'p1=cast(ubyte,int(0.5+bytecontent(row)/2^16)-2^8*p0)
        'p2=cast(ubyte,int(0.5+bytecontent(row)/2^8)-2^8*(2^8*p0+p1))
        'p3=cast(ubyte,bytecontent(row)-2^8*(2^16*p0+2^8*p1+p2))
        'poke currentaddr,p0
        'poke currentaddr+1,p1
        'poke currentaddr+2,p2
        'poke currentaddr+3,p3
        poke currentaddr,byteval>>24 
        poke currentaddr+1,byteval >>16 
        poke currentaddr+2,byteval >>8 
        poke currentaddr+3,byteval
        row=row+1
    loop until row=8
end sub
end