declare sub DefineUDG
' Bug correction
' Required only for the nex file
' It can be deleted for direct compiling with zxb'
ASM
    ld iy,$5c3a
end ASM
' end of bug correction'

DefineUDG
paper 7
border 7
ink 0
cls
dim bytecontent as ulong
dim addr as uinteger

'bytecontent=(bin 0111111000000000)
'print bytecontent,
'bytecontent=bytecontent >> 1
'print bytecontent

'poke (uinteger,16384,bin 0111111000000000)
'poke (uinteger,16384,bytecontent)
'print peek (uinteger,16384)




print at 0,0; chr$ 146;chr$ 147;chr$ 148
print "A"
print "--"
while inkey$="":wend
for rep=1 to 8
print at 3,0
for addr=16384 to (16384+7*256) step 256
    bytecontent=cast(ulong,(peek (uinteger,addr)))
    
    print bytecontent,
    bytecontent=cast(ulong,bytecontent) >> 1
    print bytecontent
    poke (ulong,addr,bytecontent)
    pause 50
next
next




while inkey$=""
wend

end



sub DefineUDG
    dim n,m,k as ubyte
    restore UdgGame
    for n=code "a" to code "v"
        for m=0 to 7
            read k
            poke uinteger usr chr$ n+m,k
        next m
    next n
    UdgGame:
    data 003,000,063,000,255,000,007,000: rem A, 144, wind left
    data 028,162,050,004,248,000,224,016: rem B, 145, wind right
    data 192,192,255,255,000,000,000,000: rem C, 146, helicopter left
    data 008,254,255,255,255,125,063,015: rem D, 147, helicopter center
    data 000,000,192,112,120,255,252,024: rem E, 148, helicopter right
    data 024,060,126,255,126,090,153,024: rem F, 149, mine
    data 017,068,168,148,067,041,074,129: rem G, 150, explosion
    data 000,066,024,102,129,038,089,130: rem H, 151, splash
    data 128,128,128,192,192,224,248,255: rem I, 152, left bottom corner
    data 001,001,001,003,003,007,031,255: rem J, 153, right bottom corner
    data 255,248,224,192,192,128,128,128: rem K, 154, left top corner
    data 255,031,007,003,003,001,001,001: rem L, 155, right top corner
    data 000,007,120,243,246,112,063,012: rem M, 156, clowd left
    data 127,254,056,187,185,188,063,103: rem N, 157, clowd center
    data 000,240,088,110,207,031,254,120: rem O, 158, clowd bottom
    data 000,000,000,016,120,120,254,251: rem P, 159, top island
    data 000,000,000,000,000,024,060,126: rem Q, 160, top island
    data 001,003,003,007,007,014,059,118: rem R, 161, bottom island left
    data 153,161,012,034,050,078,065,248: rem S, 162, bottom island center left
    data 239,195,171,012,087,034,074,034: rem T, 163, bottom island center right
    data 032,112,240,216,252,252,127,247: rem U, 164, bottom island right
end sub