' Bug correction
' Required only for the nex file
' It can be deleted for direct compiling with zxb'
ASM
    ld iy,$5c3a
END ASM
' End of bug correction'
const LastK     as UINTEGER = $5c08
dim PressedKey as ubyte
dim option as float
paper 0:ink 7
option=1





do
        print at 3+option,5;">"
        PressedKey=code inkey
        print at 3+option,5;" "
        option=option+((1 and ((PressedKey=54) and (option <5))))-((1 and ((PressedKey=55) and (option >1))))
       
loop 