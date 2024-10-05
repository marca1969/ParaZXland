dim x,y as uinteger
paper 7
border 7
ink 0
cls
x=0
y=4
print at y,x;"XYZ"
dim addr as uinteger
do
    x=x+1
    y=4
    ' Address: 16384+int(column_pixel/8)+32*row
    ' Add 2048 for block 2 and 4096 for block 3'
    addr=16384+int(x/8)+32*y
    shift 1,addr,2
    if x=256 then
        print at y,0;"XYZ"
        print at y+1,0;"   "
        x=0
    end if 
loop while inkey$=""

sub shift (direction as byte,addr as uinteger,nbytes as ubyte)
' 8 to 24-bit bit shift
    dim currentaddr as uinteger
    dim bytecontent(1 to 8) as ulong
    dim row,i as ubyte  
    dim exps(1 to 4) as ulong
    for i=1 to nbytes
        exps(i)=2^(8*(i-1))
        'print at 10+i,0;i;" ";exps(i);" "
    next i
    
    for row=1 to 8
        'row of the char (1 to 8)
        ' 1 - read the 16 bit value'
        currentaddr=addr+256*(row-1)
        bytecontent(row)=0
        for i=0 to nbytes-1
            'bytecontent(row)=bytecontent(row)+peek(currentaddr+i-1)*exps(5-i)
            bytecontent(row)=bytecontent(row)+peek(currentaddr+i)*256^(3-i)
            'bytecontent(row)=peek(currentaddr)*2^24+peek (currentaddr+1)*65536+peek(currentaddr+2)*256+peek(currentaddr+3)'
        next i
        ' 2 - shifts   
        if direction=1 then 
            bytecontent(row)=bytecontent(row) SHR 1
        endif
        if direction=-1 then 
            bytecontent(row)=bytecontent(row) SHL 1
        endif
        ' 3 - pokes new values'
        
            poke currentaddr+0,int( bytecontent(row)                                                                                          ) /exps(4)
            poke currentaddr+1,int( bytecontent(row) - exps(4)*peek(currentaddr+0)                                                            ) /exps(3)
            poke currentaddr+2,int( bytecontent(row) - exps(4)*peek(currentaddr+0) - exps(3)*peek(currentaddr+1)                              ) /exps(2)
            poke currentaddr+3,int( bytecontent(row) - exps(4)*peek(currentaddr+0) - exps(3)*peek(currentaddr+1) - exps(2)*peek(currentaddr+2)) /exps(1)

     next row
end sub
end