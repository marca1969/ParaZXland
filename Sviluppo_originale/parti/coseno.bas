dim x,xmin,y,xmax as uinteger
xmin=1000
xmax=0
x=50+rnd*150
y=190
do
    x=x+cast(integer,(int(0.5+7*sin(y/9.4))))
    if x<xmin then xmin=x
    if x>xmax then xmax=x
    plot x,y
    print at 0,0;x,y;" "
    y=y-2
loop until y=0

plot xmin,0
draw 0,190
plot xmax,0
draw 0,190