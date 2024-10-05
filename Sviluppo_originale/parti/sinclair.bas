declare sub sinclair

const black as UBYTE = 0
const blue as UBYTE = 1
const red as UBYTE = 2
const magenta as UBYTE = 3
const green as UBYTE = 4
const cyan as UBYTE = 5
const yellow as UBYTE = 6
const white as UBYTE = 7

paper black
ink white
out 254,1
cls
sinclair
pause 0

sub sinclair
    restore UdgIntro
    FOR n=code "a" to code "m"
    FOR m=0 to 7
    read k
    poke uinteger usr chr$ n+m,k
    NEXT m
    NEXT n
    UdgIntro:
    DATA 001,003,007,015,031,063,127,255: rem A, chr$ 144, half-filled diagonal
    DATA 064,064,113,074,074,074,113,000: rem B, chr$ 145, boriel1
    DATA 000,000,140,082,080,080,144,000: rem C, chr$ 146, boriel2
    DATA 129,001,153,165,185,161,156,000: rem D, chr$ 147, boriel3
    DATA 000,000,000,000,000,000,128,000: rem E, chr$ 148, boriel4
    DATA 000,001,000,000,000,000,001,001: rem F, chr$ 149, zx1
    DATA 000,244,018,033,064,129,002,244: rem G, chr$ 150, zx2
    DATA 000,016,032,064,128,064,032,016: rem H, chr$ 151,zx3
    DATA 000,241,138,138,243,138,138,242:rem I, chr$ 152, basic1
    DATA 000,199,040,040,231,032,032,047: rem K, chr$ 153, basic2
    DATA 000,167,040,040,040,168,168,039: rem L,chr$ 154, basic3
    DATA 000,128,000,000,000,000,000,128: rem M, chr$ 155, basic4
    ''
    DIM colors(6) as ubyte => {0,2,6,4,5,0,0}   
    for n=0 to 5
        for m=0 to n
            paper colors(m)
            ink colors(m+1)
            print at 18+n,31-n+m;chr$ 144;
        next m
    next n
    paper black
    ink red
    print at 21,0;chr$ 145 + chr$ 146 + chr$ 147+chr$ 148 ' boriel
    ink white
    print at 22,0;chr$ 149 + chr$ 150 + chr$ 151 ' ZX
    print at 23,0;chr$ 152 + chr$ 153 + chr$ 154 + chr$ 155
end sub

