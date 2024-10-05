/' ParaZXland 
   Boriel ZX Basic version 
   2023 -- By Massimiliano Arca
 
   ParaZXland only uses built-in functions without ASM commands

   No parachutists have been harmed during the development of this game
   
   Rev. 27/10/2023
'/

'Subroutines
declare sub bang         (random as ubyte,color as ubyte)
declare sub beeth5       (octave as byte)
declare sub blip
declare sub draw15       (yc as ubyte,xc as ubyte)
declare sub draw50       (yc as ubyte,xc as ubyte)
declare sub drawheart    (yc as ubyte,xc as ubyte)
declare sub drawpara
declare sub frame        (x as ubyte, length as ubyte)
declare sub heli
declare sub newgame
declare sub keylmode
declare sub paraman      (newtype as ubyte,oldtype as ubyte,x as ubyte,y as ubyte,ox as ubyte,oy as ubyte,char as ubyte)
declare sub printeffect  (y as ubyte,x as ubyte,text as string)
declare sub sinclair
declare sub wait
'Functions
declare function asktext (row as ubyte,col as ubyte,maxlength as ubyte) as string
declare function author$(type as string) as string
declare function codify$ (score as ulong) as string
declare function decodify(score$ as string) as ulong
declare function liveup (lives as ubyte) as ubyte
declare function revert  (n$ as string) as string

'Constants

'Memory addresses & system variables
const ScreenMem  as uinteger = $4000
const AttrMem    as uinteger = $5800
const LastK      as uinteger = $5C08
const Chars      as uinteger = $5C36
const UDGs       as uinteger = $5C7B 
const Mode       as uinteger = $5C41
const Flags      as uinteger = $5C3B
const Flags2     as uinteger = $5C6A
const JoyPort    as ubyte    = $1f
'Keys
const enter      as ubyte    = 13
const delete     as ubyte    = 12
const cursorup   as ubyte    = 11
const cursordown as ubyte    = 10
'Joystick directions
const joyup      as ubyte    = 8
const joydown    as ubyte    = 4
const joyleft    as ubyte    = 2
const joyright   as ubyte    = 1
const joyfire    as ubyte    = 16
const joyfireup  as ubyte    = 24
'Colours
const black      as ubyte    = 0
const blue       as ubyte    = 1
const red        as ubyte    = 2
const magenta    as ubyte    = 3
const green      as ubyte    = 4
const cyan       as ubyte    = 5
const yellow     as ubyte    = 6
const white      as ubyte    = 7

'Variables
'UDGs used for the intro screen
dim UDGIntro (95) as ubyte => {_
    001,003,007,015,031,063,127,255,_ 'A, 144, half-filled diagonal
    064,064,113,074,074,074,113,000,_ 'B, 145, boriel1
    000,000,140,082,080,080,144,000,_ 'C, 146, boriel2
    129,001,153,165,185,161,156,000,_ 'D, 147, boriel3
    000,000,000,000,000,000,128,000,_ 'E, 148, boriel4
    000,001,000,000,000,000,001,001,_ 'F, 149, zx1
    000,244,018,033,064,129,002,244,_ 'G, 150, zx2
    000,016,032,064,128,064,032,016,_ 'H, 151, zx3
    000,241,138,138,243,138,138,242,_ 'I, 152, basic1
    000,199,040,040,231,032,032,047,_ 'J, 153, basic2
    000,167,040,040,040,168,168,039,_ 'K, 154, basic3
    000,128,000,000,000,000,000,128 _ 'L, 155, basic4
}
'UDGs used within the game
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
'Binnacle font (https://damieng.com/typography/zx-origins/binnacle/)
dim FontBinnacle (767) as ubyte => {_
    $00, $00, $00, $00, $00, $00, $00, $00 ,_  ' 
    $10, $10, $10, $10, $00, $10, $10, $00 ,_  '!
    $24, $24, $00, $00, $00, $00, $00, $00 ,_  '"
    $24, $24, $7e, $24, $7e, $24, $24, $00 ,_  '#
    $08, $3e, $40, $7e, $02, $7c, $10, $00 ,_  '$
    $20, $52, $24, $08, $12, $25, $02, $00 ,_  '%
    $18, $20, $20, $3a, $44, $42, $3d, $00 ,_  '$
    $08, $08, $00, $00, $00, $00, $00, $00 ,_  ''
    $08, $10, $20, $20, $20, $10, $08, $00 ,_  '(
    $10, $08, $04, $04, $04, $08, $10, $00 ,_  ')
    $00, $08, $2a, $1c, $2a, $08, $00, $00 ,_  '*
    $00, $08, $08, $3e, $08, $08, $00, $00 ,_  '+
    $00, $00, $00, $00, $00, $08, $08, $10 ,_  ',
    $00, $00, $00, $7e, $00, $00, $00, $00 ,_  '-
    $00, $00, $00, $00, $00, $10, $10, $00 ,_  '.
    $01, $02, $04, $08, $10, $20, $40, $00 ,_  '/
    $1c, $22, $41, $41, $41, $22, $1c, $00 ,_  '0
    $0c, $14, $04, $04, $04, $04, $04, $00 ,_  '1
    $3e, $41, $01, $0e, $30, $40, $7f, $00 ,_  '2
    $7f, $02, $04, $1e, $01, $41, $3e, $00 ,_  '3
    $0e, $12, $22, $42, $7f, $02, $02, $00 ,_  '4
    $7f, $40, $40, $7e, $01, $41, $3e, $00 ,_  '5
    $3e, $41, $40, $7e, $41, $41, $3e, $00 ,_  '6
    $3f, $41, $02, $04, $08, $10, $20, $00 ,_  '7
    $3e, $41, $41, $3e, $41, $41, $3e, $00 ,_  '8
    $3e, $41, $41, $3f, $01, $41, $3e, $00 ,_  '9
    $00, $00, $08, $08, $00, $08, $08, $00 ,_  ':
    $00, $00, $08, $08, $00, $08, $08, $10 ,_  ',
    $04, $08, $10, $20, $10, $08, $04, $00 ,_  '<
    $00, $00, $7e, $00, $7e, $00, $00, $00 ,_  '=
    $20, $10, $08, $04, $08, $10, $20, $00 ,_  '>
    $3e, $41, $01, $0e, $00, $08, $08, $00 ,_  '?
    $1e, $21, $4f, $51, $4f, $20, $1f, $00 ,_  '@
    $3e, $41, $41, $41, $7f, $41, $41, $00 ,_  'A
    $7e, $41, $41, $7e, $41, $41, $7e, $00 ,_  'B
    $3e, $41, $40, $40, $40, $41, $3e, $00 ,_  'C
    $7c, $42, $41, $41, $41, $42, $7c, $00 ,_  'D
    $7f, $40, $40, $7e, $40, $40, $7f, $00 ,_  'E
    $7f, $40, $40, $7e, $40, $40, $40, $00 ,_  'F
    $3e, $41, $40, $4f, $41, $41, $3f, $00 ,_  'G
    $41, $41, $41, $7f, $41, $41, $41, $00 ,_  'H
    $1c, $08, $08, $08, $08, $08, $1c, $00 ,_  'I
    $01, $01, $01, $01, $01, $41, $3e, $00 ,_  'J
    $41, $41, $42, $7c, $42, $41, $41, $00 ,_  'K
    $40, $40, $40, $40, $40, $41, $3e, $00 ,_  'L
    $77, $49, $49, $49, $49, $49, $49, $00 ,_  'M
    $7e, $41, $41, $41, $41, $41, $41, $00 ,_  'N
    $3e, $41, $41, $41, $41, $41, $3e, $00 ,_  'O
    $7e, $41, $41, $7e, $40, $40, $40, $00 ,_  'P
    $3e, $41, $41, $41, $45, $42, $3d, $00 ,_  'Q
    $7e, $41, $41, $7e, $48, $44, $43, $00 ,_  'R
    $3e, $41, $40, $3e, $01, $41, $3e, $00 ,_  'S
    $7f, $08, $08, $08, $08, $08, $08, $00 ,_  'T
    $41, $41, $41, $41, $41, $41, $3e, $00 ,_  'U
    $41, $41, $41, $42, $44, $48, $30, $00 ,_  'V
    $49, $49, $49, $49, $49, $49, $77, $00 ,_  'W
    $41, $41, $22, $1c, $22, $41, $41, $00 ,_  'X
    $41, $41, $41, $3f, $01, $41, $3e, $00 ,_  'Y
    $7f, $02, $04, $08, $10, $20, $7f, $00 ,_  'Z
    $1c, $10, $10, $10, $10, $10, $1c, $00 ,_  '[
    $40, $20, $10, $08, $04, $02, $01, $00 ,_  '\
    $1c, $04, $04, $04, $04, $04, $1c, $00 ,_  ']
    $10, $38, $38, $54, $10, $10, $10, $00 ,_  '^
    $00, $00, $00, $00, $00, $00, $00, $ff ,_  '_
    $1f, $20, $20, $7c, $20, $21, $7e, $00 ,_  '£
    $00, $00, $3e, $42, $42, $42, $3d, $00 ,_  'a
    $40, $40, $7c, $42, $42, $42, $7c, $00 ,_  'b
    $00, $00, $3e, $40, $40, $40, $3e, $00 ,_  'c
    $02, $02, $3e, $42, $42, $42, $3e, $00 ,_  'd
    $00, $00, $3c, $42, $7e, $40, $3e, $00 ,_  'e
    $0e, $10, $10, $7c, $10, $10, $10, $00 ,_  'f
    $00, $00, $3e, $42, $42, $3e, $02, $3c ,_  'g
    $40, $40, $7c, $42, $42, $42, $42, $00 ,_  'h
    $10, $00, $10, $10, $10, $10, $0c, $00 ,_  'i
    $04, $00, $04, $04, $04, $04, $44, $38 ,_  'j
    $20, $20, $22, $24, $38, $24, $22, $00 ,_  'k
    $10, $10, $10, $10, $10, $10, $0c, $00 ,_  'l
    $00, $00, $77, $49, $49, $49, $49, $00 ,_  'm
    $00, $00, $7c, $42, $42, $42, $42, $00 ,_  'n
    $00, $00, $3c, $42, $42, $42, $3c, $00 ,_  'o
    $00, $00, $7c, $42, $42, $7c, $40, $40 ,_  'p
    $00, $00, $3e, $42, $42, $3e, $02, $02 ,_  'q
    $00, $00, $7c, $42, $40, $40, $40, $00 ,_  'r
    $00, $00, $3e, $40, $3c, $02, $7c, $00 ,_  's
    $10, $10, $7c, $10, $10, $10, $0e, $00 ,_  't
    $00, $00, $42, $42, $42, $42, $3c, $00 ,_  'u
    $00, $00, $42, $42, $44, $48, $30, $00 ,_  'v
    $00, $00, $49, $49, $49, $49, $77, $00 ,_  'w
    $00, $00, $42, $24, $18, $24, $42, $00 ,_  'x
    $00, $00, $42, $42, $42, $3e, $02, $3c ,_  'y
    $00, $00, $7e, $04, $18, $20, $7e, $00 ,_  'z
    $06, $08, $08, $30, $08, $08, $06, $00 ,_  '{
    $08, $08, $08, $08, $08, $08, $08, $00 ,_  '|
    $30, $08, $08, $06, $08, $08, $30, $00 ,_  '}
    $00, $14, $28, $00, $00, $00, $00, $00 ,_  '~
    $3c, $42, $99, $a1, $a1, $99, $42, $3c _   '©
}
'Invitation Sans font (https://damieng.com/typography/zx-origins/invitation/)
dim FontInvitation (767) as ubyte => {_ 
    $00, $00, $00, $00, $00, $00, $00, $00 ,_ '
    $0c, $08, $08, $10, $00, $30, $30, $00 ,_ '!
    $24, $24, $48, $00, $00, $00, $00, $00 ,_ '"
    $00, $14, $7e, $28, $fc, $50, $00, $00 ,_ '#
    $04, $1e, $34, $18, $2c, $78, $20, $00 ,_ '$
    $60, $a4, $c8, $10, $26, $4a, $0c, $00 ,_ '%
    $08, $14, $10, $32, $4c, $44, $3e, $00 ,_ '$
    $08, $08, $10, $00, $00, $00, $00, $00 ,_ ''
    $08, $10, $20, $20, $20, $10, $08, $00 ,_ '(
    $20, $10, $08, $08, $08, $10, $20, $00 ,_ ')
    $00, $08, $2a, $3c, $54, $10, $00, $00 ,_ '*
    $00, $08, $08, $3c, $10, $10, $00, $00 ,_ '+
    $00, $00, $00, $00, $00, $10, $10, $20 ,_ ',
    $00, $00, $00, $7c, $00, $00, $00, $00 ,_ '-
    $00, $00, $00, $00, $00, $10, $10, $00 ,_ '.
    $02, $04, $08, $10, $20, $40, $80, $00 ,_ '/
    $1c, $22, $42, $54, $84, $88, $70, $00 ,_ '0
    $04, $1c, $08, $08, $10, $10, $7c, $00 ,_ '1
    $1c, $22, $02, $0c, $30, $40, $7c, $00 ,_ '2
    $1c, $22, $02, $1c, $02, $42, $3c, $00 ,_ '3
    $0e, $12, $24, $44, $3e, $08, $08, $00 ,_ '4
    $1e, $10, $20, $3c, $02, $42, $3c, $00 ,_ '5
    $04, $08, $10, $3c, $42, $42, $3c, $00 ,_ '6
    $3e, $42, $04, $08, $10, $20, $40, $00 ,_ '7
    $1c, $22, $22, $3c, $42, $42, $3c, $00 ,_ '8
    $3c, $42, $42, $3c, $04, $08, $30, $00 ,_ '9
    $00, $00, $08, $08, $00, $10, $10, $00 ,_ ':
    $00, $00, $08, $08, $00, $10, $10, $20 ,_ ';
    $00, $08, $10, $20, $10, $08, $00, $00 ,_ '<
    $00, $00, $00, $7c, $00, $7c, $00, $00 ,_ '=
    $00, $10, $08, $04, $08, $10, $00, $00 ,_ '>
    $38, $44, $04, $18, $00, $30, $30, $00 ,_ '?
    $1c, $22, $4a, $54, $9c, $80, $78, $00 ,_ '@
    $1c, $22, $42, $7c, $84, $88, $88, $00 ,_ 'A
    $1c, $22, $22, $3c, $42, $42, $7c, $00 ,_ 'B
    $1c, $22, $40, $40, $80, $84, $78, $00 ,_ 'C
    $38, $24, $42, $42, $82, $84, $f8, $00 ,_ 'D
    $3e, $20, $40, $78, $80, $80, $fc, $00 ,_ 'E
    $3e, $20, $40, $78, $80, $80, $80, $00 ,_ 'F
    $1c, $22, $40, $4e, $82, $84, $78, $00 ,_ 'G
    $22, $22, $44, $7c, $88, $88, $88, $00 ,_ 'H
    $3e, $08, $10, $10, $20, $20, $f8, $00 ,_ 'I
    $0e, $04, $04, $08, $88, $90, $60, $00 ,_ 'J
    $22, $24, $48, $70, $90, $88, $84, $00 ,_ 'K
    $10, $10, $20, $20, $40, $40, $7c, $00 ,_ 'L
    $21, $23, $56, $5a, $94, $84, $84, $00 ,_ 'M
    $22, $22, $54, $54, $88, $88, $88, $00 ,_ 'N
    $1c, $22, $42, $44, $84, $88, $70, $00 ,_ 'O
    $3c, $22, $42, $7c, $40, $80, $80, $00 ,_ 'P
    $1c, $22, $42, $44, $94, $88, $74, $00 ,_ 'Q
    $3c, $22, $42, $7c, $48, $84, $82, $00 ,_ 'R
    $1c, $22, $20, $18, $04, $84, $78, $00 ,_ 'S
    $7e, $08, $10, $10, $20, $20, $40, $00 ,_ 'T
    $22, $22, $42, $44, $84, $88, $70, $00 ,_ 'U
    $42, $42, $44, $44, $48, $50, $60, $00 ,_ 'V
    $21, $21, $4a, $5a, $6a, $c4, $84, $00 ,_ 'W
    $42, $24, $28, $10, $28, $48, $84, $00 ,_ 'X
    $42, $24, $28, $10, $10, $20, $20, $00 ,_ 'Y
    $3e, $04, $08, $10, $20, $40, $7c, $00 ,_ 'Z
    $1c, $10, $20, $20, $40, $40, $70, $00 ,_ '[
    $20, $10, $10, $08, $08, $04, $04, $00 ,_ '\
    $1c, $04, $08, $08, $10, $10, $70, $00 ,_ ']
    $08, $14, $24, $00, $00, $00, $00, $00 ,_ '^
    $00, $00, $00, $00, $00, $00, $00, $fe ,_ '_
    $0c, $12, $10, $7c, $20, $20, $7e, $00 ,_ '£
    $00, $00, $1e, $22, $42, $4c, $34, $00 ,_ 'a
    $10, $10, $2c, $32, $42, $44, $78, $00 ,_ 'b
    $00, $00, $1c, $22, $40, $44, $38, $00 ,_ 'c
    $02, $02, $3c, $44, $84, $88, $74, $00 ,_ 'd
    $00, $00, $1c, $22, $7c, $40, $3c, $00 ,_ 'e
    $0c, $12, $20, $38, $20, $40, $40, $00 ,_ 'f
    $00, $00, $1e, $22, $42, $3c, $04, $78 ,_ 'g
    $10, $10, $2c, $32, $42, $44, $44, $00 ,_ 'h
    $08, $00, $30, $10, $20, $24, $18, $00 ,_ 'i
    $02, $00, $04, $04, $08, $08, $10, $60 ,_ 'j
    $10, $10, $22, $24, $38, $44, $44, $00 ,_ 'k
    $18, $08, $10, $10, $20, $24, $18, $00 ,_ 'l
    $00, $00, $36, $49, $49, $92, $92, $00 ,_ 'm
    $00, $00, $2c, $32, $22, $44, $44, $00 ,_ 'n
    $00, $00, $1c, $22, $42, $44, $38, $00 ,_ 'o
    $00, $00, $1c, $22, $22, $64, $58, $80 ,_ 'p
    $00, $00, $1e, $22, $42, $4c, $34, $04 ,_ 'q
    $00, $00, $2c, $32, $20, $40, $40, $00 ,_ 'r
    $00, $00, $1c, $22, $18, $44, $38, $00 ,_ 's
    $04, $08, $3c, $10, $20, $20, $1c, $00 ,_ 't
    $00, $00, $22, $22, $44, $4c, $32, $00 ,_ 'u
    $00, $00, $42, $44, $48, $50, $20, $00 ,_ 'v
    $00, $00, $41, $41, $92, $92, $6c, $00 ,_ 'w
    $00, $00, $22, $14, $18, $28, $44, $00 ,_ 'x
    $00, $00, $22, $44, $44, $38, $08, $70 ,_ 'y
    $00, $00, $3e, $04, $18, $20, $7c, $00 ,_ 'z
    $0c, $10, $10, $60, $20, $20, $18, $00 ,_ '{
    $08, $08, $10, $10, $20, $20, $20, $00 ,_ '|
    $18, $04, $04, $06, $08, $08, $30, $00 ,_ '}
    $00, $32, $54, $98, $00, $00, $00, $00 ,_ '~
    $1c, $22, $4d, $91, $a5, $ba, $44, $38 _  '©
}
'Outrunner Outline font (https://damieng.com/typography/zx-origins/outrunner/)
dim FontOutrunner (767) as ubyte => {_ 
    $00,$00,$00,$00,$00,$00,$00,$00 ,_ ' 
    $18,$24,$24,$24,$28,$30,$48,$30 ,_ '!
    $ff,$99,$99,$dd,$7f,$00,$00,$00 ,_ '"
    $7e,$db,$81,$db,$db,$81,$db,$7e ,_ '#
    $1c,$76,$c2,$b7,$c3,$ed,$83,$fe ,_ '$
    $73,$8d,$aa,$96,$69,$55,$b1,$ce ,_ '%
    $38,$44,$54,$68,$94,$9a,$45,$3a ,_ '$
    $3c,$24,$24,$34,$1c,$00,$00,$00 ,_ ''
    $1c,$24,$4c,$48,$48,$4c,$24,$1c ,_ '(
    $70,$48,$64,$24,$24,$64,$48,$70 ,_ ')
    $3c,$ee,$aa,$c6,$6c,$c6,$aa,$7c ,_ '*
    $38,$28,$ee,$82,$ee,$28,$38,$00 ,_ '+
    $00,$00,$00,$3c,$24,$64,$4c,$78 ,_ ',
    $00,$00,$7c,$82,$7c,$00,$00,$00 ,_ '-
    $00,$00,$00,$00,$3c,$24,$24,$3c ,_ '.
    $03,$05,$0a,$14,$28,$50,$a0,$c0 ,_ '/
    $3c,$42,$99,$99,$99,$99,$42,$3c ,_ '0
    $3c,$64,$44,$64,$24,$66,$42,$7c ,_ '1
    $3c,$42,$99,$99,$72,$cf,$81,$ff ,_ '2
    $3c,$42,$99,$72,$79,$99,$42,$3c ,_ '3
    $0e,$12,$22,$52,$b3,$81,$f3,$1e ,_ '4
    $fe,$82,$9e,$83,$f9,$99,$42,$3c ,_ '5
    $3e,$42,$9e,$83,$99,$99,$42,$3c ,_ '6
    $ff,$81,$99,$f6,$24,$24,$24,$3c ,_ '7
    $3c,$42,$99,$42,$99,$99,$42,$3c ,_ '8
    $3c,$42,$99,$99,$c1,$79,$42,$7c ,_ '9
    $00,$3c,$24,$24,$3c,$24,$24,$3c ,_ ':
    $3c,$24,$24,$3c,$24,$64,$4c,$78 ,_ ',
    $1e,$32,$66,$4c,$66,$32,$1e,$00 ,_ '<
    $00,$fe,$82,$fe,$82,$fe,$00,$00 ,_ '=
    $78,$4c,$66,$32,$66,$4c,$78,$00 ,_ '>
    $7e,$c3,$b9,$f3,$26,$3c,$24,$3c ,_ '?
    $7e,$c3,$99,$91,$91,$9f,$c2,$7e ,_ '@
    $7e,$c3,$9d,$9d,$9d,$81,$9d,$f7 ,_ 'A
    $fe,$83,$9d,$83,$9d,$9d,$83,$fe ,_ 'B
    $7e,$c3,$99,$9f,$9f,$99,$c3,$7e ,_ 'C
    $fe,$83,$9d,$9d,$9d,$9d,$83,$fe ,_ 'D
    $ff,$81,$9f,$82,$9e,$9f,$81,$ff ,_ 'E
    $ff,$81,$9f,$9a,$82,$9a,$9e,$f0 ,_ 'F
    $7e,$c3,$9d,$9f,$91,$9d,$c3,$7e ,_ 'G
    $f7,$95,$9d,$81,$9d,$95,$95,$f7 ,_ 'H
    $7e,$42,$66,$24,$24,$66,$42,$7e ,_ 'I
    $3f,$21,$33,$12,$f2,$b2,$c6,$7c ,_ 'J
    $f7,$9d,$9b,$86,$96,$9b,$9d,$f7 ,_ 'K
    $f0,$90,$90,$90,$97,$9d,$81,$ff ,_ 'L
    $f7,$9d,$89,$95,$9d,$95,$95,$f7 ,_ 'M
    $f7,$9d,$8d,$95,$99,$9d,$95,$f7 ,_ 'N
    $7e,$c3,$9d,$9d,$9d,$9d,$c3,$7e ,_ 'O
    $fe,$83,$9d,$9d,$83,$9e,$90,$f0 ,_ 'P
    $7e,$c3,$9d,$9d,$95,$99,$c1,$7f ,_ 'Q
    $fe,$83,$9d,$9d,$83,$9b,$9d,$f7 ,_ 'R
    $7e,$c3,$9d,$c6,$7b,$9d,$c3,$7e ,_ 'S
    $ff,$81,$e7,$24,$24,$24,$24,$3c ,_ 'T
    $f7,$95,$95,$95,$95,$9d,$c3,$7e ,_ 'U
    $f7,$95,$95,$95,$9d,$cb,$66,$3c ,_ 'V
    $f7,$9d,$95,$95,$95,$95,$cb,$7e ,_ 'W
    $f7,$8d,$cb,$46,$62,$d3,$b1,$ef ,_ 'X
    $f7,$95,$9d,$cb,$66,$24,$24,$3c ,_ 'Y
    $ff,$81,$fb,$46,$62,$df,$81,$ff ,_ 'Z
    $7e,$42,$4e,$48,$48,$4e,$42,$7e ,_ '[
    $c0,$a0,$50,$28,$14,$0a,$05,$03 ,_ '\
    $7e,$42,$72,$12,$12,$72,$42,$7e ,_ ']
    $38,$6c,$c6,$9a,$fe,$00,$00,$00 ,_ '^
    $00,$00,$00,$00,$00,$ff,$81,$ff ,_ '_
    $3e,$63,$4d,$cf,$84,$cf,$81,$ff ,_ '£
    $00,$7e,$43,$79,$c1,$b9,$c1,$7f ,_ 'a
    $f0,$90,$9e,$83,$9d,$9d,$83,$fe ,_ 'b
    $00,$7e,$c3,$99,$9f,$99,$c3,$7e ,_ 'c
    $0f,$09,$79,$c1,$b9,$b9,$c1,$7f ,_ 'd
    $00,$7e,$c3,$9d,$81,$9f,$c3,$7e ,_ 'e
    $00,$3f,$61,$cf,$82,$ce,$48,$78 ,_ 'f
    $00,$7f,$c1,$b9,$c1,$f9,$83,$fe ,_ 'g
    $f0,$90,$9e,$83,$9d,$95,$95,$f7 ,_ 'h
    $3c,$24,$7c,$44,$64,$66,$42,$7e ,_ 'i
    $1e,$12,$1e,$12,$12,$72,$46,$7c ,_ 'j
    $f0,$97,$9d,$9b,$86,$9b,$9d,$f7 ,_ 'k
    $7c,$44,$64,$24,$24,$66,$42,$7e ,_ 'l
    $00,$fe,$8b,$95,$95,$95,$9d,$f7 ,_ 'm
    $00,$fe,$83,$9d,$95,$95,$95,$f7 ,_ 'n
    $00,$7e,$c3,$9d,$9d,$9d,$c3,$7e ,_ 'o
    $00,$fe,$83,$9d,$9d,$83,$9e,$f0 ,_ 'p
    $00,$7f,$c1,$b9,$b9,$c1,$79,$0f ,_ 'q
    $00,$fe,$83,$9d,$97,$90,$90,$f0 ,_ 'r
    $00,$7e,$c2,$9e,$c3,$fd,$83,$fe ,_ 's
    $78,$ce,$82,$ce,$48,$4e,$62,$3e ,_ 't
    $00,$f7,$95,$95,$95,$9d,$c3,$7e ,_ 'u
    $00,$f7,$95,$95,$9d,$cb,$66,$3c ,_ 'v
    $00,$f7,$9d,$95,$95,$c3,$4a,$7e ,_ 'w
    $00,$f7,$9d,$cb,$66,$d3,$b9,$ef ,_ 'x
    $00,$ef,$a9,$b9,$c1,$f9,$83,$fe ,_ 'y
    $00,$fe,$82,$f6,$44,$de,$82,$fe ,_ 'z
    $3f,$21,$e7,$8c,$e4,$27,$21,$3f ,_ '{
    $3c,$24,$24,$24,$24,$24,$24,$3c ,_ '|
    $fc,$84,$e7,$31,$27,$e4,$84,$fc ,_ '}
    $7b,$cd,$a5,$b3,$de,$00,$00,$00 ,_ '~
    $00,$3c,$66,$5e,$5e,$66,$3c,$00  _ '©
}

dim option,n,m,UserInput,PressedJoy,y,oy,counter       as ubyte
dim sound                                               as ubyte = 1
dim kempston                                            as ubyte = 0
dim i                                                   as byte
dim x,ox                                                as uinteger
dim highscore                                           as ulong 'In order to be potentially larger than 65535
dim sc$,text$,infokey$,title$                           as string
dim keys(2)                                             as ubyte => {111,112,113} 
/' keys(0) = left
   keys(1) = right
   keys(2) = pause '/
dim CharSet         as uinteger at Chars    'Pointer to the font address  
dim UDGSet          as uinteger at UDGs     'Pointer to the UDG address
dim AttrScreen(767) as ubyte    at AttrMem  'Direct mapping of the attr area
dim LastKeyPressed  as ubyte    at LastK

'Data Section
mine:
data    024,060,126,255,126,090,153,024
email:
data    639,650,709,650,647,658,656,640,650,639,691,658,656,641,658,709,644,645,658,650,647,650,646,650,640,640,658,646,0
name:
data    704,705,707,705,723,658,656,641,690,723,644,645,658,650,647,650,646,650,640,640,658,678,0
parapicture:
data    0,1,255,192,0,0,0,63,136,33,4,8,8,0,30,227,22,132,12,6,8,0,34,102,217,39,15,254,_
        0,1,168,163,223,140,0,0,0,15,239,252,0,0,0,0,0,252,0,0,0,0,0,0,248,0,0,0,0,6,26,127,128,0,0,_
        127,12,33,4,24,14,0,10,97,12,134,24,12,12,0,27,54,81,36,191,248,0,0,252,163,215,184,0,_
        0,0,7,199,248,0,0,0,0,6,204,0,0,0,0,0,1,248,0,0,0,0,120,16,64,240,0,0,78,12,33,8,32,17,128,_
        5,33,104,131,16,16,4,0,27,182,209,36,127,248,0,0,116,130,174,112,0,0,0,3,199,240,0,0,_
        0,0,7,166,0,0,0,0,0,1,188,0,0,0,1,240,48,64,140,0,0,254,12,33,16,32,96,192,3,16,184,134,224,96,30,_
        0,29,178,209,108,191,240,0,0,127,130,190,64,0,0,0,1,255,128,0,0,0,0,7,196,0,0,0,_
        0,0,1,156,0,0,0,3,240,32,129,3,0,0,254,12,33,48,64,64,64,1,144,152,136,208,128,54,_
        0,6,146,241,105,159,192,0,0,63,130,253,128,0,0,0,1,255,0,0,0,0,0,1,196,0,0,0,0,0,1,156,0,0,0,_
        7,240,32,129,3,128,0,255,4,59,32,129,128,112,0,216,184,136,145,128,127,0,7,18,225,125,54,64,_
        0,0,63,195,255,128,0,0,0,1,207,0,0,0,0,0,1,204,0,0,0,0,0,1,24,0,0,0,31,248,32,130,2,96,0,_
        123,255,255,193,3,0,208,0,236,106,137,45,1,255,0,3,64,225,118,97,128,0,0,31,195,255,0,0,_
        0,0,1,198,0,0,0,0,0,0,207,128,0,0,0,0,1,8,0,0,0,63,232,33,4,4,24,0,96,66,19,179,2,1,152,_
        0,102,106,137,38,3,255,0,1,232,161,89,206,0,0,0,15,255,254,0,0,0,0,1,246,0,0,0,_
        0,0,0,248,0,0,0,0,0,0,0,0,0,0
skull:
data    56,124,146,146,254,108,56,56
sounddata:
data    1,7,1,7,1,7,3,3,0,8,1,5,1,5,1,5,3,2
TNT:
data    7,56,76,214,206,214,76,56
'End of data section

poke Flags, peek Flags bOR 8
sc$="00000"
title$=author$("name")

'Main loop
do
    CharSet=$3C00
    paper black
    ink cyan
    border black
    cls
    drawpara
    sinclair
    ink white
    print at 0,5;bold 1;title$
    print at 0,5;over 1;title$
    CharSet=@FontInvitation(0)-$100
    print at 2,10;bold 1;bright 1;"ParaZXland"
    CharSet=@FontBinnacle(0)-$100
    option=0
    print at 13,8;"Hi score ";
    CharSet=@FontOutrunner(0)-$100
    print sc$(1 to (5-len(str$(highscore))));highscore
    CharSet=@FontBinnacle(0)-$100
    print at 14,8;"Code  ";codify$(highscore)
    for i=20 to 0 step -1
        CharSet=@FontBinnacle(0)-$100+i
        print at  5,7;"0 Play"
        print at  6,7;"1 Define keys:"
        print at  7,7;"2 Enter hi score code"
        print at  8,7;"3 Instructions"
        print at  9,7;"4 Sound "
        print at 10,7;"5 Joystick "
    next i
    if sound=1 then print at 9,15;"ON " else print at 9,15;"OFF"
    if kempston=1 then print at 10,18;"ON " else print at 10,18;"OFF"
    x=20
    y=174
    ox=255
    oy=200
    do
        ink white
        print at 5+option,5;inverse 1;">"
        ink blue
        keylmode
        infokey$="left """+chr$(keys(0))+""", right """+chr$(keys(1))+""", pause """+chr$(keys(2))+""", "
        counter=0
        do
            if counter<(len(infokey$)-5) then
                print at 6,22;ink white;infokey$(counter to counter+5)
            else
                print at 6,22;ink white;infokey$(counter to);infokey$(0 to 5-len(infokey$)+counter)
            end if
            counter=(counter+1) mod (len(infokey$)-1) 
            poke LastK,0
            paraman(1,1,x,y,ox,oy,2)
            paraman(1,1,x+218,y,ox+218,oy,2)
            ox=x
            oy=y
            y=y-2
            x=int(0.5+x+cos(y/10))
            if y=30 then 
                y=174
                x=20
            end if
            PressedJoy=0
            UserInput=LastKeyPressed
            if kempston=1 then PressedJoy=in JoyPort
            if PressedJoy=joyup then UserInput=cursorup
            if PressedJoy=joydown then UserInput=cursordown
            if PressedJoy=joyfire then UserInput=enter
        loop until UserInput
        'A key has been pressed
        if sound=1 then 
            if (UserInput>48 and UserInput<57) or UserInput=enter or UserInput=cursordown or UserInput=cursorup then
                beep .05,-15
            end if
        end if
        print at 5+option,5;" "
        if UserInput=54 or UserInput=cursordown  then
            if option<5 then option=option+1
        end if
        if UserInput=55 or UserInput=cursorup  then
            if option>0 then option=option-1
        end if
        if UserInput>47 then
            if UserInput<54 then
                'Number keys
                ink white
                print at 5+option,5;" "
                option=UserInput-48
                UserInput=enter
            end if
        end if
        if UserInput=enter  then
            ink white
            print at 5+option,5;inverse 1;">"
            'Menu option 1
            if option=1 then
            'Redefine keys
                ink white
                bright 1
                print at 6,9,"            "
                print at 6,9;"Left  :"
                text$=asktext(6,16,1)
                keys(0)=code text$
                do
                    print at 6,9;"Right :"
                    text$=asktext(6,16,1)
                    keys(1)=code text$
                loop until keys(1)<>keys(0)
                do
                    print at 6,9;"Pause :"
                    text$=asktext(6,16,1)
                    keys(2)=code text$
                loop until keys(2)<>keys(1) and keys(2)<>keys(0)
                for n=0 to 2
                    if keys(n)>64 and keys(n)<91 then 
                        'Lower case
                        keys(n)=keys(n)+32
                    end if
                next n
                bright 0
                infokey$="left """+chr$(keys(0))+""", right """+chr$(keys(1))+""", pause """+chr$(keys(2))+""", "
                counter=0
                print at  6,7;"1 Define keys:"
            end if
            'Menu option 2
            if option=2 then 
            'Enter code to set high score
                ink white
                bright 1
                print at 14,8;"Code "
                print at 14,14;"        "
                text$=asktext(14,14,8)
                if highscore<decodify(text$) then highscore=decodify(text$)
                'Es. ef#-abdi = 00150
                bright 0
                print at 14,8;"Code "
                CharSet=@FontOutrunner(0)-$100
                print at 13,17;sc$(1 to (5-len(str$(highscore))));highscore
                CharSet=@FontBinnacle(0)-$100
                print at 14,14;codify$(highscore)
            end if      
            'Menu option 4   
            if option=4 then
                if sound=0 then 
                    sound=1
                    beep .05,-15
                    print at 9,15;"ON "
                else
                    sound=0
                    print at 9,15;"OFF"
                endif
            end if
            'Menu option 5
            if option=5 then
                if kempston=0 then 
                    kempston=1
                    print at 10,18;"ON " 
                else
                    kempston=0
                    print at 10,18;"OFF"
                end if
            end if
        end if
    loop until (UserInput=enter and (option=0 or option=3))
    'Menu option 3: instructions
    if option=3 then
        paraman(1,1,255,200,ox,oy,2)
        paraman(1,1,255,200,ox+218,oy,2)
        for m=4 to 22
            print at m,0,,," "
        next m
        sinclair
        CharSet=@FontInvitation(0)-$100
        print at 4,0;"Our hero is  parachuted  from  a"; 
        print        "helicopter  onto a small  island";
        print        "in the middle of the ocean, from";
        print        "where  he will -what else?- save";
        print        "the world. Unfortunately, strong";
        print        "oceanic winds make it impossible";
        print        "to  safely direct the  launch to";
        print        "the target and an evil enemy has";
        print        "suspended numerous flying mines.";
        print        "The parachutist will have to try";
        print        "to counteract the  winds,  avoid";
        print        "the mines,  and eventually  land";
        print        "on the tiny island to accomplish";
        print        "the mission. Will he succeed?   ";
        CharSet=@FontBinnacle(0)-$100
        flash 1
        if kempston=1 then 
            printeffect 21,5,"Press any key or fire"
        else
            printeffect 21,9,"Press any key"
        end if
        flash 0
        wait
        CharSet=@FontInvitation(0)-$100
        print at 4,0;"The game  starts with the option";   
        print        "0. The parachute can be directed";
        print        "with  the  default keys O and P,";
        print        "which  can be  freely  redefined";
        print        "(option  1).  The  longest   our";
        print        "hero survives,  the  highest the";
        print        "score. To the hi-score a code is";
        print        "associated,so that it can be re-";
        print        "entered in later gameplays (opti";
        print        "ion 2).  Options 4 and 5  switch";
        print        "ON / OFF sound and Kempston joy-";
        print        "stick.                          ";
        print        "For queries and complains, email";
        print        "                                ";
        CharSet=@FontBinnacle(0)-$100
        print        "  ";author$("email");"  ";
        
        flash 1
        if kempston=1 then 
            printeffect 21,5,"Press any key or fire"
        else
            printeffect 21,9,"Press any key"
        end if
        flash 0
        wait
    else
    'Menu option 0: play a new game
        newgame
    end if
loop
'End

'Subroutines
sub bang(random as ubyte,color as ubyte)
    dim counter1, counter2 as ubyte
    for counter1=1 to 20 step 2
        out 254,color+(counter2*8)*(blue+rnd*random)
        counter2=counter1
    next counter1
    out 254,color
end sub

sub blip
    'Small sound generated when a heart is hit
    dim counter1,counter2 as ubyte
    do 
        out 254,counter1*8+red
        counter1=counter2
        do 
            counter1=counter1+16
        loop until counter1 > 200
        counter2=counter2+1
    loop until counter2 = 100
    out 254,cyan
end sub

sub beeth5(octave as byte)
    'Tune adapted from Beethoven symphony no. 5 - royalty free
    restore sounddata
    dim dur as float
    dim pitch,multiplier,counter as ubyte
    dur=0.22
    for counter=1 to 9
        read multiplier,pitch
        if pitch<>0 then
            beep dur*multiplier,pitch-5*octave
        else
            pause dur*multiplier
        endif
    next
end sub

sub draw15(yc as ubyte,xc as ubyte)
    'x,y coords are provided as chars coordinates (origin top left)
    'and immediately switched and translated in pixel coordinates (origin bottom left)
    y=191-yc*8 'vertical   coordinate
    x=xc*8     'horizontal coordinate
    if x>247 then x=247
    plot x,y-2
    plot x+1,y-2
    plot x+2,y-2
    plot x+1,y-1
    plot x+1,y-3
    plot x+4,y
    plot x+4,y-1
    plot x+4,y-2
    plot x+4,y-3
    plot x+4,y-4
    plot x+6,y
    plot x+7,y
    plot x+8,y
    plot x+6,y-1
    plot x+6,y-2
    plot x+7,y-2
    plot x+8,y-2
    plot x+8,y-3
    plot x+6,y-4
    plot x+7,y-4
    plot x+8,y-4
end sub

sub draw50(yc as ubyte,xc as ubyte)
    'x,y coords are provided as chars coordinates (origin top left)
    'and immediately switched and translated in pixel coordinates (origin bottom left)
    y=191-yc*8 'vertical   coordinate
    x=xc*8     'horizontal coordinate
    if x>246 then x=246
    plot x-1,y-2
    plot x,y-2
    plot x+1,y-2
    plot x,y-1
    plot x,y-3
    plot x+3,y-1
    plot x+4,y
    plot x+5,y
    plot x+4,y-2
    plot x+5,y-2
    plot x+5,y-3
    plot x+3,y-4
    plot x+4,y-4
    plot x+5,y-4
    plot x+3,y
    plot x+3,y-2
    plot x+8,y
    plot x+7,y-1
    plot x+9,y-1
    plot x+7,y-2
    plot x+9,y-2
    plot x+7,y-3
    plot x+9,y-3
    plot x+8,y-4
end sub

sub drawheart(yc as ubyte,xc as ubyte)
    'x,y coords are provided as chars coordinates (origin top left)
    'and immediately switched and translated in pixel coordinates (origin bottom left)
    y=191-yc*8 'vertical   coordinate
    x=xc*8     'horizontal coordinate
    plot x+3,y-1
    plot x+5,y-1
    plot x+2,y-2
    plot x+3,y-2
    plot x+4,y-2
    plot x+5,y-2
    plot x+6,y-2
    plot x+1,y-3
    plot x+2,y-3
    plot x+3,y-3
    plot x+4,y-3
    plot x+5,y-3
    plot x+6,y-3
    plot x+7,y-3
    plot x+1,y-4
    plot x+2,y-4
    plot x+3,y-4
    plot x+4,y-4
    plot x+5,y-4
    plot x+6,y-4
    plot x+7,y-4
    plot x+2,y-5
    plot x+3,y-5
    plot x+4,y-5
    plot x+5,y-5
    plot x+6,y-5
    plot x+3,y-6
    plot x+4,y-6
    plot x+5,y-6
    plot x+4,y-7
end sub

sub drawpara
    'Parachute artwork
    dim n,m as ubyte
    dim counter as uinteger
    restore parapicture
    for counter=20480 to 22496 step 32
        for m=1 to 7
            read n
            poke counter+m+12,n
        next m
    next counter
end sub

sub frame (x as ubyte, length as ubyte)
    print at 11,x;"\K";tab x+length-1;"\L"
    print at 12,x;" ";tab x+length-1;" "
    print at 13,x;"\I";tab x+length-1;"\J"
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

sub heli
    'helicopter sound
    dim counter as ubyte
    for counter=16 to 88 step 4
        out 254,8*(cast(ubyte,counter/24))+cyan
    next counter
end sub

sub keylmode
    'Set mode "L" on the keyboard
    poke Mode,0 
    poke Flags2,0 
end sub

sub newgame
    /'Rules:
    Points: < 10000
                        Descent increase			+10
                        Heart collection            +15
                        Landing			            +1000
    Points > 10000
                        Descent increase			+30
                        Heart collection            +50
                        Landing         			+2000
    Points = 20000		Extra life
    Points > 30000
                        Descent increase			+50
                        Heart collection            +50
                        Landing         			+3000
    Points = 50000		Extra life

    For each successful landing the number of mines increases by 4 (up to a maximum of 30).
    '/

    'Game variables
    'x,y coordinates in pixel units; origin = top left corner
    dim x,oldx,y,oldy,counter,helx,lives,nmines,nhearts,cloudx,row  as ubyte
    dim oldtype,newtype                                             as ubyte
    dim increase,islandscore,currentaddr,addr                       as uinteger
    dim score,byteval                                               as ulong 
    dim wind                                                        as fixed
    dim t$                                                          as string
    dim mineslocation (30,2)                                        as uinteger
    dim islandlocation(7,2)                                         as uinteger
    dim heartslocation (6,2)                                        as uinteger
    do
        'Creative CLS black2cyan
        AttrScreen(rnd*767)=45
        increase=increase+1
        border cyan
        out 254,black
    loop until increase=600
    paper cyan
    border cyan
    cls
    UDGSet=@UDGGame(0)
    lives=3
    score=0
    increase=10
    islandscore=1000
    nmines=4
    nhearts=1
    'Sea
    paper blue
    ink white
    print at 22,0;tab 31;" "
    print at 23,0;tab 31;" ";
    ink cyan
    randomize
    for counter=1 to 20
        plot ink cyan;rnd*256,12+rnd*4
        draw ink cyan;1+rnd*2,0
        plot ink white;rnd*256,12+rnd*4
        draw ink white;1+rnd*2,0
    next counter
    'Bottom lines
    ink white
    CharSet=$3C00
    print at 23,1;bold 1;"Score";at 23,23;"Hi"
    print at 23,13;"\A";"\B"   
    keylmode
    do
    'Repeat while lives>0
    /' This section redefines the bomb udg based on the current score 
       Basic bomb shape   :   up to 10000   kpoints
       TNT bomb           :   10000 – 30000 kpoints
       Frightening skulls :   over 30000    kpoints '/
        oldtype=1 'Plain parachutist
        newtype=1 'Plain parachutist
        if score<10000 then 
                restore mine
        else
            if score>29999 then
                increase=50
                islandscore=3000
                'Defines skull
                restore skull
            else
                '29999 > Score > 9999
                increase=30
                islandscore=2000
                'Defines TNT
                restore TNT  
            end if
        end if
        'Define current bomb shape
        for counter=0 to 7
            read UDGGame(40+counter)
        next counter
        print at 23,0;paper blue;ink cyan;"\I";at 23,31;"\J";
        border cyan
        paper cyan
        'Island
        x=int(rnd*29)
        print at 20,x+1;"\P"+"\Q"
        print at 21,x;"\R"+"\S"+"\T"+"\U"
        for counter=0 to 7
            islandlocation (counter,0)=20-(1 and counter>3)
            islandlocation (counter,1)=x+counter mod 4
            islandlocation (counter,2)=AttrMem+32*(islandlocation(counter,0))+islandlocation(counter,1)
            poke islandlocation (counter,2),41
        next counter
        poke islandlocation(5,2),33
        poke islandlocation(6,2),33
        'Clowd
        cloudx=1+rnd*27
        print at 1,cloudx;ink white;paper cyan;"\M"+"\N"+"\O"
        'Mines (danger!)
        ink magenta
        for counter=0 to nmines
            mineslocation (counter,0)=3+rnd*16
            mineslocation (counter,1)=rnd*32
            mineslocation (counter,2)=AttrMem+32*(mineslocation(counter,0))+mineslocation(counter,1)
            print at mineslocation(counter,0),mineslocation(counter,1);"\F"
        next counter
        'Hearts (extra points)
        ink red
        nhearts=int(0.5+nmines/5)
        for counter=0 to nhearts
            heartslocation (counter,0)=3+rnd*16
            do
                heartslocation (counter,1)=rnd*32
                heartslocation (counter,2)=AttrMem+32*(heartslocation(counter,0))+heartslocation(counter,1)
                'In case a heart overlaps a mine its vertical coord is recalculated
            loop while peek(heartslocation(counter,2))=43
            drawheart heartslocation(counter,0),heartslocation(counter,1)
        next counter
        'Bottom lines
        wind=int(rnd*11)-5
        ink white
        paper blue
        CharSet=@FontOutrunner(0)-$100
        print at 23,7;sc$(1 to (5-len(str$(score))));score
        print at 23,26;sc$(1 to (5-len(str$(highscore))));highscore
        print at 23,13;"\A"+"\B";abs(wind);
        if wind>0 then print ">";
        if wind<0 then print "<";
        if wind=0 then print "-";
        print "      "
        for counter=1 to lives
            paraman 1,1,136+8*counter,0,200,200,0
        next counter
        t$="Undef"
        CharSet=@FontInvitation(0)-$100
        paper blue
        ink cyan
        if kempston=1 then 
            frame 5,22
            ink white
            printeffect 12,6,"Press fire to launch"
        else
            frame 4,25
            ink white
            printeffect 12,5,"Press any key to launch"
        end if
        paper cyan
        ink black
        'Let the helicopter enter
        paper cyan           
        print at 0,1;"\C"+"\D"+"\E"
        counter=0
        do
            AttrScreen(32+counter)=47  'cloud white on cyan
            AttrScreen(counter)=40     'helicopter black on cyan
            counter=counter+1
        loop until counter=32
        addr=ScreenMem+1
        PressedJoy=0
        helx=0
        'Helicopter flight
        plot 12,191
        draw 8,0
        do
            counter=0
            poke LastK,0
            do 
                currentaddr=addr
                row=0
                do
                    'xth row of the char'
                    '1 - read the 32 bit value in big-endian format
                    byteval=cast(ulong,peek(currentaddr)*2^24+peek(currentaddr+1)*2^16+peek(currentaddr+2)*2^8+peek(currentaddr+3))  
                    '2 - bit shift
                    byteval=byteval>>1
                    '3 - poke new values
                    poke currentaddr,  byteval >>24
                    poke currentaddr+1,byteval >>16 
                    poke currentaddr+2,byteval >> 8 
                    poke currentaddr+3,byteval      
                    row=row+1                   'Next line
                    currentaddr=currentaddr+256
                loop until row=8
                counter=counter+1               'Next shift
                if (counter mod 3)=0 then
                    over 1
                    plot 8*helx+counter+12,191
                    draw 16,0
                    over 0
                    if sound=1 then heli
                end if
                UserInput=LastKeyPressed
                if kempston=1 then PressedJoy=in JoyPort
                if PressedJoy=joyfire then UserInput=1
                if UserInput then exit do
            loop until counter=8
            if sound=1 then heli
            addr=addr+1               'Next 4-byte shift
            helx=helx+1
            if UserInput then exit do
        loop until helx=27
        helx=8*helx+counter 'Chars to pixels
        for x=11 to 13
            print at x,0;paper cyan;" ";tab 31;" "
            for counter=0 to nmines
                if mineslocation(counter,0)=x then 
                    print at x,mineslocation(counter,1);"\F"
                    poke mineslocation(counter,2),43
                end if
            next counter
            for counter=0 to nhearts
                if heartslocation(counter,0)=x then 
                    drawheart x,heartslocation(counter,1)
                    poke heartslocation(counter,2),42
                end if
            next counter
        next x
        x=helx+14
        y=166
        'Parachutist
        paraman oldtype,oldtype,x,y,255,200,2
        'Main game loop
        randomize
        poke LastK,0
        CharSet=@FontOutrunner(0)-$100
        'Set the REPDEL and REPPER system variables
        poke uinteger (LastK+1),257
        do
            'Main loop
            'Helicopter rotor (pass 1)
            over 1
            plot helx+4,191
            draw 16,0
            over 0
            'Updates score
            print at 23,7;paper blue;ink white;sc$(1 to (5-len(str$(score))));score;
            oldx=x
            oldy=y
            oldtype=newtype
            y=y-2
            x=x+int(0.5+cos(y/9.4))+wind/4 'Co-sinusoidal oscillation & wind effect
            'Command input section
            if x<6 then x=6
            if x>244 then x=244
            UserInput=LastKeyPressed
            PressedJoy=0
            if kempston=1 then PressedJoy=in JoyPort
            'Keyboard
            if UserInput=keys(0) or PressedJoy=joyleft then
                'Left
                if x>4 then x=x-2
            else if UserInput=keys(1) or PressedJoy=joyright then
                'Right
                if x<244 then x=x+2
            else if UserInput=keys(2) or PressedJoy=joyfireup then
                'Pause
                paraman newtype,newtype,255,200,oldx,oldy,2
                CharSet=@FontInvitation(0)-$100
                paper blue
                ink cyan
                frame 12,8
                ink white
                printeffect 12,13,"Paused"
                paper cyan
                wait
                for row=11 to 13
                    print at row,12,"        "
                    ink magenta
                    for counter=0 to nmines
                        if mineslocation(counter,0)=row then print at row,mineslocation(counter,1);"\F"
                    next counter    
                    for counter=0 to nhearts
                        if heartslocation(counter,0)=row then 
                            drawheart(row,heartslocation(counter,1))
                            poke heartslocation(counter,2),42
                        end if
                    next counter    
                next row
                ink black
                CharSet=@FontOutrunner(0)-$100
                paraman newtype,newtype,oldx,oldy,255,200,2
            end if
            'Reset keys
            poke LastK,0
            'Cloud (attributes)
            if y>151 then 
                print at 1,cloudx;ink white;paper cyan;"\M"+"\N"+"\O"
                AttrScreen(32+cloudx)  =47
                AttrScreen(32+cloudx+1)=47
                AttrScreen(32+cloudx+2)=47
                AttrScreen(32+cloudx+3)=47
            else
                if (y mod 15)=0 then
                    'Cloud movement every 15 descent steps of the parachutist
                    currentaddr=ScreenMem+32+cloudx 
                    row=0
                    do
                        'xth row of the char'
                        '1 - read the 32 bit value in big-endian format
                        byteval=cast(ulong,peek(currentaddr)*2^24+peek(currentaddr+1)*2^16+peek(currentaddr+2)*2^8+peek(currentaddr+3))  
                        '2 - bit shift
                        byteval=byteval>>1
                        '3 - poke new values
                        poke currentaddr,  byteval >> 24
                        poke currentaddr+1,byteval >> 16 
                        poke currentaddr+2,byteval >>  8 
                        poke currentaddr+3,byteval      
                        row=row+1                   'Next line
                        currentaddr=currentaddr+256
                    loop until row=8
                end if
            end if
            'Mine collision
            for counter=0 to nmines
                if peek(mineslocation(counter,2))<>43 then 
                    t$="Bang!"
                    CharSet=@FontInvitation(0)-$100
                    print at mineslocation(counter,0),mineslocation(counter,1);ink red;"\G"
                    CharSet=@FontOutrunner(0)-$100
                    exit do
                end if
            next counter
            'Heart collision
            counter=0
            do
                if peek(heartslocation(counter,2))<>42 then 
                    over 1
                    drawheart heartslocation(counter,0),heartslocation(counter,1)
                    'Delete the hit heart
                    'if sound=1 then beep .001,.3
                    if sound=1 then blip 
                    if score<10000 then
                        score=score+15
                        draw15 heartslocation(counter,0),heartslocation(counter,1)
                    else
                        score=score+50
                        draw50 heartslocation(counter,0),heartslocation(counter,1)
                    end if
                    heartslocation(counter,2)=24
                    'In a ZX Spectrum 48k/128k/+2/+3 rom, peek(24)=42. This will prevent 
                    'the heart(counter) to be checked again
                    over 0
                    exit do
                end if
                counter=counter+1
            loop until counter=nhearts+1
            'Island landing
            if peek(islandlocation(1,2))<>41 or peek(islandlocation(2,2))<>41 or peek(islandlocation(4,2))<>41 or peek(islandlocation(7,2))<>41 then
                t$="Landed!"
                'Re-position Paruchist (check in order of island quote)        
                if peek(islandlocation(7,2))<>41 then 
                    x=islandlocation(7,1)*8
                    y=22
                elseif peek(islandlocation(4,2))<>41 then 
                    x=islandlocation(4,1)*8
                    y=18
                elseif peek(islandlocation(2,2))<>41 then 
                    x=islandlocation(2,1)*8
                    y=26
                elseif peek(islandlocation(1,2))<>41 then 
                    x=islandlocation(1,1)*8
                    y=27 
                endif
                if score>(20000-islandscore) then
                    if score<20001 then lives=liveup(lives)
                end if
                if int(score/50000)<int((score+islandscore)/50000) then lives=liveup(lives)
                score=score+islandscore
                exit do
            end if
            'If no collisions occur, the parachutist is re-drawn        
            if x>oldx then 
                newtype=2 'The parachutist is shifting to the right
            else if x<oldx then 
                newtype=3 'The parachutist is shifting to the left
            else    
                newtype=1 'The parachutist is not shifting significantly
            end if
            'Parachutist
            paraman newtype,oldtype,x,y,oldx,oldy,2
            if score>(20000-increase) then
                if score<20001 then lives=liveup(lives)
            end if
            if int(score/50000)<int((score+increase)/50000) then lives=liveup(lives)
            score=score+increase
        loop while y>16
        'Game over
        plot helx+4,191
        draw 16,0
        ink white
        paper blue
        print at 23,0;" ";at 23,31;" ";
        print at 23, 7;sc$(1 to (5-len(str$(score))));str$(score)
        ink black
        paper cyan
        if t$="Undef" then 
            'The parachutist reached the last line
            'Hence, it is on the sea
            CharSet=@FontInvitation(0)-$100
            t$="Splash!"
            paraman newtype,oldtype,x,y,255,200,2
            print over 1;at 22,x/8;ink white;paper blue;"\H"
        end if
        counter=0
        if t$="Bang!" then 
            'Explosion
            paraman newtype,oldtype,255,200,oldx,oldy,2
            ink red
            for counter=1 to 10
                plot x+rnd*10-5,y+rnd*10-5
                if sound then bang(1,blue)       
            next counter  
        end if
        ink blue
        paper cyan
        border blue
        print at 0,0;"\K"
        print at 0,31;"\L"
        ink black
        if t$="Landed!"
            paraman 1,oldtype,255,200,oldx,oldy,2
            paraman 1,oldtype,x,y,255,200,0
        else
            'Bang or splash
            'Erase current live
            over 0
            paper blue
            ink blue
            paraman 1,1,136+8*lives,0,255,200,0
            pause 10
            ink green
            paraman 1,1,136+8*lives,0,255,200,0
            pause 10
            ink cyan
            paraman 1,1,136+8*lives,0,255,200,0
            pause 10
            lives=lives-1
        end if
        if score>highscore then 
            highscore=score
            if highscore>99999 then highscore=99999
            CharSet=@FontOutrunner(0)-$100
            print ink white;paper blue;at 23,26;sc$(1 to (5-len(str$(highscore))));str$(highscore)
        end if
        border blue
        paper blue
        ink white
        CharSet=@FontInvitation(0)-$100
        ink cyan
        paper blue
        frame (32-len t$)/2+1,2+len t$
        ink white
        printeffect 12,(32-len t$)/2+2,t$
        paper cyan
        ink black
        if sound=1 then
            if t$<>"Landed!" then
                beeth5(-1*(t$="Bang!"))
            else
                'Play -cccf-a--cccf-a--
                'Tune adapted from La Cucaracha - royalty free
                for counter=1 to 2
                    beep 0.17,0
                    beep 0.17,0
                    beep 0.17,0
                    beep 0.34,5
                    beep 0.34,9
                next counter
                'Play ffeedd-c
                pause 8
                beep 0.17,5
                beep 0.17,5
                beep 0.17,4
                beep 0.17,4
                beep 0.17,2
                beep 0.17,2
                beep 0.17,0
            end if
        end if
        if lives>0 then 
            counter=0
            over 1
            plot helx+4,191
            draw 8,0
            poke LastK,0
            do
                if (counter mod 16)=0 then
                    plot helx+4,191
                    draw 16,0
                    pause 5
                end if
                counter=counter+1
                PressedJoy=0
                UserInput=LastKeyPressed
                if kempston=1 then PressedJoy=in JoyPort
                if PressedJoy=joyfire then UserInput=1
            loop until UserInput
            over 0
            'Clear screen
            for counter=0 to 21
                print at counter,0;tab 31;" ";
            next counter
            if t$="Splash!" then
                'Restore the sea
                print over 1;at 22,x/8;paper blue;ink white;"\H"
            end if
            if t$="Landed!" then 
                'Raise the diffuculty level only in case of successful landing
                nmines=nmines+4
                if nmines>30 then nmines=30 'Enough is enough
            end if
        else
            pause 100
            paper black
            ink cyan
            frame 10,12
            ink white            
            bright 1
            printeffect 12,11,"GAME  OVER"
            bright 0
            wait
            exit do 
        end if
    loop 
    increase=0
    AttrScreen(0)=0
    AttrScreen(31)=0
    do
        'Creative CLS cyan2black
        AttrScreen(1+rnd*766)=0
        increase=increase+1
        border black
        out 254,cyan
    loop until increase=600
end sub

sub paraman(newtype as ubyte,oldtype as ubyte,x as ubyte,y as ubyte,ox as ubyte,oy as ubyte,char as ubyte)
    /'Drawing routine
      if oy or y > 191 then the character will not be drawn
      Char =    0 --> man
                1 --> para
                2 --> both
      This routines delete and redraw the parachist as fast as possible
      It is designed to be more efficient than stylish 
      This is the reason for the long list of plot commands '/
    over 1
    if char=0 or char=2 then 
        'Man 
        'Step 1 - Delete
        if oldtype=1 then
            'Erase
            plot ox+2,oy
            plot ox+4,oy
            plot ox+2,oy+1
            plot ox+4,oy+1
            plot ox+2,oy+2
            plot ox+4,oy+2
            plot ox+2,oy+3
            plot ox+4,oy+3
            plot ox+3,oy+3
            plot ox+2,oy+4
            plot ox+1,oy+4
            plot ox+3,oy+4
            plot ox+5,oy+4
            plot ox+4,oy+4
            plot ox+1,oy+5
            plot ox+5,oy+5
            plot ox,oy+5
            plot ox+3,oy+5
            plot ox+6,oy+5
            plot ox,oy+6
            plot ox+2,oy+6
            plot ox+3,oy+6
            plot ox+4,oy+6
            plot ox+6,oy+6
            plot ox,oy+7
            plot ox+2,oy+7
            plot ox+3,oy+7
            plot ox+4,oy+7
            plot ox+6,oy+7         
        elseif oldtype=2 then
            plot ox,oy
            plot ox+2,oy
            plot ox,oy+1
            plot ox+2,oy+1
            plot ox,oy+2
            plot ox+1,oy+2
            plot ox+2,oy+2
            plot ox+3,oy+2
            plot ox+3,oy+3
            plot ox+4,oy+3
            plot ox+2,oy+4
            plot ox+3,oy+4
            plot ox+4,oy+4
            plot ox+5,oy+4
            plot ox+1,oy+5
            plot ox+4,oy+5
            plot ox+5,oy+5
            plot ox+6,oy+5
            plot ox+7,oy+5
            plot ox+1,oy+6
            plot ox+3,oy+6
            plot ox+4,oy+6
            plot ox+5,oy+6
            plot ox+7,oy+6
            plot ox,oy+7
            plot ox+3,oy+7
            plot ox+4,oy+7
            plot ox+5,oy+7
            plot ox+7,oy+7
        else
            plot ox+7,oy
            plot ox+5,oy
            plot ox+7,oy+1
            plot ox+5,oy+1
            plot ox+7,oy+2
            plot ox+6,oy+2
            plot ox+5,oy+2
            plot ox+4,oy+2
            plot ox+4,oy+3
            plot ox+3,oy+3
            plot ox+2,oy+4           
            plot ox+3,oy+4
            plot ox+4,oy+4
            plot ox+5,oy+4            
            plot ox+6,oy+5            
            plot ox,oy+5
            plot ox+1,oy+5
            plot ox+2,oy+5
            plot ox+3,oy+5
            plot ox+6,oy+6
            plot ox+4,oy+6
            plot ox+3,oy+6
            plot ox+2,oy+6
            plot ox,oy+6            
            plot ox+6,oy+7
            plot ox+4,oy+7
            plot ox+3,oy+7
            plot ox+2,oy+7
            plot ox,oy+7 
        end if
        'Step 2 Draw
        if newtype=1 then
            'No horizontal shift
            plot x+2,y
            plot x+4,y
            plot x+2,y+1
            plot x+4,y+1
            plot x+2,y+2
            plot x+4,y+2 
            plot x+2,y+3
            plot x+4,y+3         
            plot x+3,y+3         
            plot x+1,y+4
            plot x+2,y+4
            plot x+3,y+4    
            plot x+4,y+4            
            plot x+5,y+4
            plot x+1,y+5
            plot x+5,y+5            
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
        elseif newtype=2 then
            'right shift
            plot x,y
            plot x+2,y
            plot x,y+1
            plot x+2,y+1
            plot x,y+2
            plot x+1,y+2
            plot x+2,y+2
            plot x+3,y+2
            plot x+3,y+3
            plot x+4,y+3
            plot x+2,y+4
            plot x+3,y+4
            plot x+4,y+4
            plot x+5,y+4
            plot x+1,y+5
            plot x+4,y+5
            plot x+5,y+5
            plot x+6,y+5
            plot x+7,y+5
            plot x+1,y+6
            plot x+3,y+6
            plot x+4,y+6
            plot x+5,y+6
            plot x+7,y+6
            plot x,y+7
            plot x+3,y+7
            plot x+4,y+7
            plot x+5,y+7
            plot x+7,y+7
        else
            'left shift
            plot x+7,y
            plot x+5,y
            plot x+7,y+1
            plot x+5,y+1
            plot x+7,y+2
            plot x+6,y+2
            plot x+5,y+2
            plot x+4,y+2
            plot x+4,y+3
            plot x+3,y+3
            plot x+2,y+4           
            plot x+3,y+4
            plot x+4,y+4
            plot x+5,y+4            
            plot x+6,y+5            
            plot x,y+5
            plot x+1,y+5
            plot x+2,y+5
            plot x+3,y+5
            plot x+6,y+6
            plot x+4,y+6
            plot x+3,y+6
            plot x+2,y+6
            plot x,y+6            
            plot x+6,y+7
            plot x+4,y+7
            plot x+3,y+7
            plot x+2,y+7
            plot x,y+7
        endif
    end if
    if char then 
        'Parachute 
        oy=oy+8
        y=y+8
        plot ox-1,oy 
        plot x-1,y
        plot ox+7,oy 
        plot x+7,y
        plot ox-2,oy+1
        plot x-2,y+1
        plot ox+8,oy+1
        plot x+8,y+1
        plot ox-3,oy+2
        plot x-3,y+2
        plot ox+9,oy+2
        plot x+9,y+2
        plot ox-3,oy+3
        plot x-3,y+3
        plot ox-2,oy+3
        plot x-2,y+3
        plot ox+8,oy+3
        plot x+8,y+3
        plot ox+9,oy+3
        plot x+9,y+3
        plot ox-4,oy+4
        plot x-4,y+4
        plot ox-1,oy+4
        plot x-1,y+4
        plot ox,oy+4
        plot x,y+4
        plot ox+6,oy+4
        plot x+6,y+4
        plot ox+7,oy+4
        plot x+7,y+4
        plot ox+10,oy+4
        plot x+10,y+4
        plot ox-4,oy+5
        plot x-4,y+5
        plot ox-1,oy+5
        plot x-1,y+5
        plot ox+1,oy+5
        plot x+1,y+5
        plot ox+2,oy+5
        plot x+2,y+5
        plot ox+3,oy+5
        plot x+3,y+5
        plot ox+4,oy+5
        plot x+4,y+5
        plot ox+5,oy+5
        plot x+5,y+5
        plot ox+7,oy+5
        plot x+7,y+5
        plot ox+10,oy+5
        plot x+10,y+5
        plot ox-3,oy+6
        plot x-3,y+6
        plot ox-2,oy+6
        plot x-2,y+6
        plot ox+1,oy+6
        plot x+1,y+6
        plot ox+5,oy+6
        plot x+5,y+6
        plot ox+8,oy+6
        plot x+8,y+6
        plot ox+9,oy+6
        plot x+9,y+6      
        plot ox-1,oy+7
        plot x-1,y+7
        plot ox,oy+7
        plot x,y+7
        plot ox+6,oy+7
        plot x+6,y+7
        plot ox+7,oy+7
        plot x+7,y+7
        plot ox+1,oy+8
        plot x+1,y+8
        plot ox+2,oy+8
        plot x+2,y+8
        plot ox+3,oy+8
        plot x+3,y+8
        plot ox+4,oy+8
        plot x+4,y+8
        plot ox+5,oy+8
        plot x+5,y+8      
    end if
    over 0
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

sub sinclair
    dim colors(6) as ubyte => {0,2,6,4,5,0,0}
    dim n,m       as ubyte
    UDGSet=@UDGIntro(0)
    for n=0 to 5
        for m=0 to n
            paper colors(m)
            ink colors(m+1)
            print at 18+n,31-n+m;"\A";
        next m
    next n
    paper black
    ink red
    print at 21,0;"\B"+"\C"+"\D"+"\E"   'boriel
    ink white
    print at 22,0;"\F"+"\G"+"\H"        ' ZX
    print at 23,0;"\I"+"\J"+"\K"+"\L"   'basic'
end sub

sub wait
    /'  This routine waits for the user to press
        any key or to press the fire button on
        a Kempston joystick '/
    poke LastK,0
    do 
        PressedJoy=0
        UserInput=LastKeyPressed
        if kempston=1 then PressedJoy=in JoyPort
        if PressedJoy=joyfire then UserInput=1
    loop until UserInput
end sub

'Functions
function asktext(row as ubyte,col as ubyte,maxlength as ubyte) as string
    /' row, col = text coordinates
       maxlength = max length of the text
       Characters between code 33(!) and 126 (~) are allowed '/
    dim UserInput as integer
    dim condition,InputText as integer
    dim n$ as string
    print at row,col;flash 1;inverse 1;" "
    InputText=-1
    condition=0
    n$=""
    border black
    poke uinteger (LastK+1),1315
    'Restore the REPDEL and REPPER system variables
    do
        poke LastK,0
        do 
            UserInput=LastKeyPressed
        loop until UserInput
        if sound=1 then beep .01,-2
        if UserInput>32 then 
            if UserInput<127 then
                if len n$<maxlength then 
                    n$=n$+chr$(UserInput)
                    InputText=InputText+1
                end if
            end if
        end if  
        'DELETE was pressed
        if UserInput=delete then 
            if len n$>0 then 
                n$=n$(to len n$-2)
                if n$="" then InputText=-1
            end if
        end if   
        'ENTER was pressed
        if UserInput=enter then 
            if len n$>0 then 
                condition=1
            else
                out 254,red
                if sound=1 then beep .2,-10
                out 254,black
            end if
        end if
        print at row,col;n$;inverse 1;flash 1;" ";flash 0;inverse 0;" "
    loop until condition=1
    print at row,col;n$;" ";
    return n$
end function

function author$(type$ as string) as string
    'Returns author's name or email address
    dim coded$,codedrev$ as string
    dim number as integer
    if type$="name" then
        restore name
    elseif type$="email" then
        restore email
    else 
        return ""
    end if
    coded$=""
    codedrev$=""
    do
        read number
        if number<>0 then coded$=coded$+chr$(755-number)
    loop until number=0
    for number=len coded$ to 0 step -1
        codedrev$=codedrev$+coded$(number)
    next number
    return codedrev$
end function

function codify$(score as ulong) as string
    /' This function ransforms a number in a crypted sequence
       In the codified string:
       chars 1 to 5 are calculated based on the original digits of the number
       char 6 is a random char used to encrypt the numbers
       char 7 is a control code calculated based on chars 1 to 5 (implicitly including the encrypting char)
       char 8 is "-"
       The codified string is reverted so to have the final form: xxx-yyyy '/
    dim n as ubyte 
    dim random,length as ubyte
    dim seccode as uinteger
    dim hiscore$,codified$,seccod$ as string
    sc$="00000"
    hiscore$=str$ score
    hiscore$=sc$(0 to 4-len(hiscore$))+hiscore$
    length=len hiscore$
    codified$=""
    random=int(rnd*8)
    for n=0 to length-1
        codified$=codified$+chr$(49+random+n+code(hiscore$(n)))
    next n
    codified$=codified$+chr$(random+102)
    seccode=0
    for n=0 to length
        seccode=seccode+code(codified$(n))
    next n
    'Security code generation
    seccod$=str$(seccode)
    return revert(codified$+chr$(32+val(seccod$(1 to 2)))+"-")
end function

function decodify(score$ as string) as ulong
    dim n as ubyte 
    dim random,length as ubyte
    dim seccode as uinteger
    dim nil$,verif$,decodified$,seccod$ as string
    nil$="bcdefg#-" 'i.e. 00000, with random=1 and seccode = 603 (char #)
    length=len score$
    'Two security steps
    'Step 1: score$ must be 8 char-long & the 4th char must be "-"
    if length=8 and score$(3)="-" then 
        score$=revert(score$)
    else
        score$=nil$ 
    end if
    'Step 2: verify security code (7th char)
    seccode=0
    for n=0 to 5
        seccode=seccode+code(score$(n))
    next n
    'Security code generation
    seccod$=str$(seccode)
    verif$=chr$(32+val(seccod$(1 to 2)))
    'Security code verification
    if verif$<>score$(6) then 
        score$=nil$
    end if
    random=code(score$(5))-102
    if random<0 or random>8 then 
        score$=nil$  
        random=1
    end if
    'If all previous tests were passed score$ can be analysed
    decodified$=""
    for n=0 to 4
        decodified$=decodified$+chr$((code(score$(n))-49-n-random))
    next n
    return val decodified$
end function

function liveup(lives as ubyte) as ubyte
    if lives<4 then 
        border green
        if sound then
            beep .05,.1
            beep .05,1.9
        end if
        lives=lives+1
        paper blue          
        ink white
        paraman 1,1,136+8*lives,0,255,200,0
        paper cyan
        ink black
        border cyan
    end if
    return lives
end function

function revert (n$ as string) as string
    if len(n$)=8 then 
        n$=n$(4 to 7)+n$(0 to 3)   
    end if
    return n$
end function