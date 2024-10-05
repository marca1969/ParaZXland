#include <attr.bas>
paper 7
do
CLS
x=5+rnd*250
y=5+rnd*185
ink 2:man x,y:para x,y+8
poke 22528+32*int((192-y)/8)+int(x+4)/8,43
poke 22528+32*int((192-y-8)/8)+int(x+4)/8,43
poke 22528+32*int((192-y-12)/8)+int(x+4)/8,43

do
loop while inkey$=""
loop

sub para(x as ubyte,y as ubyte)
plot x,y
plot x+2,y
plot x+4,y
plot x+6,y

plot x+1,y+1
plot x+2,y+1
plot x+4,y+1
plot x+5,y+1

plot x+1,y+2
plot x+5,y+2

plot x,y+3
plot x+1,y+3
plot x+2,y+3
plot x+3,y+3
plot x+4,y+3
plot x+5,y+3
plot x+6,y+3

plot x,y+4
plot x+1,y+4
plot x+2,y+4
plot x+3,y+4
plot x+4,y+4
plot x+5,y+4
plot x+6,y+4

plot x+1,y+5
plot x+2,y+5
plot x+3,y+5
plot x+4,y+5
plot x+5,y+5

plot x+2,y+6
plot x+3,y+6
plot x+4,y+6

plot x+3,y+7



end sub

sub man(x as ubyte,y as ubyte)
    plot x+2,y
    plot x+4,y
    plot x+2,y+1
    plot x+4,y+1
    plot x+2,y+2
    plot x+4,y+2
    plot x+3,y+3
    plot x+1,y+4
    plot x+2,y+4
    plot x+3,y+4
    plot x+4,y+4
    plot x+5,y+4
    plot x,y+5
    plot x+3,y+5
    plot x+6,y+5
    plot x,y+6
    plot x+2,y+6
    plot x+3,y+6
    plot x+4,y+6
    plot x+6,y+6
    plot x,y+7
    plot x+2,y+7
    plot x+3,y+7
    plot x+4,y+7
    plot x+6,y+7
end sub
end
