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
paper 5
ink 2
cls
border 5
paper 1
ink 5

frame 4,25
paper 1
ink 7
italic 1

printeffect 12,5,"Press any key to launch"

sub frame (x as ubyte, length as ubyte)
    
    dim currentink,currentpaper as ubyte
    print at 11,x;"\K";tab x+length-1;"\L"
    print at 12,x;" ";tab x+length-1;" "
    print at 13,x;"\I";tab x+length-1;"\J"
    
    currentpaper = peek 23693 >> 3                       ' current paper
    currentink =   peek 23693 bXOR ((peek 23693>>3)<<3)  ' current ink
    
    plot x*8,103
    draw length*8-3,0
    plot x*8,102
    draw length*8-3,0
    
    plot x*8,80
    draw length*8-3,0
    plot x*8,81
    draw length*8-3,0

    plot x*8,101
    draw length*8-3,0
    plot x*8,82
    draw length*8-3,0

    plot x*8,99
    draw length*8-3,0
    plot x*8,84
    draw length*8-3,0
    
end sub

sub printeffect (y as ubyte,x as ubyte,text as string)
    dim m as byte
    dim orig as uinteger
    orig=CharSet
    for m=20 to 0 step -1
        CharSet=orig+m
        pause 1
        print at y,x;text;
    next m
end sub
