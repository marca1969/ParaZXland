CLS
PRINT
PRINT

DIM x as UInteger = 16384
DIM y,z,y1,y2 as ULong
POKE x, 207 
POKE x + 1, 203 
POKE x + 2, 128 
POKE x + 3, 0

PRINT PEEK(ULong, x)

y=PEEK(ULong, x)
y1 = peek x + 2^8*peek (x+1) + 2^16*peek (x+2) + 2^24*peek(x+3) ' little endian => PEEK(ULong, x)
y2 = 2^24*peek x + 2^16*peek (x+1) + 2^8*peek (x+2) + peek(x+3) ' big endian

z = y2 >> 1
p0=z>>24 & $00ff
p1 = z >>16 & $00ff
p2 = z >>8 & $00ff
p3 = z & $00ff

poke x+512,p0
poke x+512+1,p1
poke x+512+2,p2
poke x+512+3,p3

print "p0 = ";p0
print "p1 = ";p1
print "p2 = ";p2
print "p3 = ";p3





