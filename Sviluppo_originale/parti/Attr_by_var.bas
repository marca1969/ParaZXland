const ScreenMem  as uinteger = $4000
const AttrMem    as uinteger = $5800

dim AttrScreen(767) as ubyte at AttrMem
dim n as uinteger

border 0 
paper 0
cls

do
    AttrScreen(rnd*767)=45
    n=n+1
    border 5
    out 254,0
loop until n=400

border 5 
paper 5
ink 0
cls

pause 100

n=0
do
    'Creative CLS
    AttrScreen(rnd*767)=7
    n=n+1
    border 0
    out 254,5
loop until n=400
border 0
paper 0
ink 7
cls

