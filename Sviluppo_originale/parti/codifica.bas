declare function AskNumber(row as ubyte,col as ubyte,min as ubyte,max as ulong) as ulong
declare function AskText(row as ubyte,col as ubyte,maxlenght as ubyte) as string
declare function codify(score as long) as string
declare function decodify(score$) as long
declare function revert (n$) as string

ASM
    ld iy,$5c3a
END ASM

const LastK   as UINTEGER = $5c08
const enter   as UBYTE    = 13
const delete  as UBYTE    = 12
const true    as UBYTE    = 1
const false   as UBYTE    = 0
const black   as UBYTE    = 0
const blue    as UBYTE    = 1
const red     as UBYTE    = 2
const white   as UBYTE    = 7

dim numero    as long
dim highscore as long

randomize
border black
paper black
ink white
cls


'numero=AskNumber(3,0,0,99999)
'print codify(numero)
'do
'testo$=AskText(7,0,8)
'print decodify(testo$)
'cls
'loop

do
    highscore=int(rnd*99999)
    print highscore
    print codify (highscore)
    testo$=codify (highscore)
    print decodify (testo$)
    do 
    loop while inkey$=""
    cls
loop

function revert (n$) as string
    if len(n$)=8 then
        n$=n$(4 to 7)+n$(0 to 3)   
    endif
    return n$
end function

function codify(score as long) as string
    ' Transform a number in a crypted sequence
    ' In the codified string:
    '   chars 1 TO 5 are calculated based on the original digits of the number
    '   char 6 is a random char used to encrypt the numbers
    '   char 7 is a control code calculated based on chars 1 to 5 (implicitly including the encrypting char)
    '   char 8 is "-"
    '   The codified string is reverted so to have the final form: xxx-yyyy
    dim n as ubyte 
    dim random,lenght as ubyte
    dim seccode as uinteger
    sc$="00000"
    hiscore$=str$ score
    hiscore$=sc$(0 to 4-len(hiscore$))+hiscore$
    lenght=len hiscore$
    codified$=""
    random=int(rnd*8)
    for n=0 to lenght-1
        codified$=codified$+chr$(49+random+n+code(hiscore$(n)))
    next n
    codified$=codified$+chr$(random+102)
    seccode=0
    for n=0 to lenght
        seccode=seccode+code(codified$(n))
    next n
    ' Security code generation
    seccod$=str$(seccode)
    return revert(codified$+chr$(32+val(seccod$(1 to 2)))+"-")
end function

function decodify(score$) as long
    dim n as ubyte 
    dim random,lenght as ubyte
    dim seccode as uinteger
    nil$="bcdefg#-" ' i.e. 00000, with random=1 and seccode = 603 (char #)
    lenght=len score$
    ' Two security steps
    ' Step 1: score$ must be 8 char-long & the 4th char must be "-"
    if lenght=8 and score$(3)="-" then 
        score$=revert(score$)
    else
        score$=nil$ 
    endif
    ' Step 2: verify security code (7th char)
    seccode=0
    for n=0 to 5
        seccode=seccode+code(score$(n))
    next n
    ' Security code generation
    seccod$=str$(seccode)
    verif$=chr$(32+val(seccod$(1 to 2)))
    ' Security code verification
    if verif$<>score$(6) then
        score$=nil$
    end if
    random=code(score$(5))-102
    if random<0 or random>8 then 
        score$=nil$  
        random=1
    end if
    ' If all previous tests were passed score$ can be analysed
    decodified$=""
    for n=0 to 4
        decodified$=decodified$+chr$((code(score$(n))-49-n-random))
    next n
    return val decodified$
end function

Function AskNumber(row as ubyte,col as ubyte,min as ubyte,max as ulong) as ulong
    ' AskNumber
    ' row,col = text coordinates
    ' min = minimum value
    ' max = maximum value
    dim PressedKey as integer
    dim InputNumber as ulong
    dim condition as integer
    dim n$ as string
    italic true
    PRINT AT 22,0; INVERSE true;"Type number; ENTER to confirm   "
    n$="Allowed range: "+str(min)+" - "+str(max)
    do
        n$=n$+" "
    loop until len(n$)=31
    print at 23,0;n$ 
    italic false
    PRINT AT row,col; FLASH true; INVERSE true;" "
    InputNumber=-1
    condition=false
    n$=""
    DO
        PAUSE 0
        PressedKey=PEEK(LastK)
        BEEP .01,-2
        IF (PressedKey>47 AND PressedKey<58) THEN n$=n$+CHR$(PressedKey) 
        IF n$<>"" then   
            InputNumber=VAL(n$)
        endif
        
        'Pressed DELETE
        IF PressedKey=delete THEN 
            IF LEN n$>0 THEN 
                n$=n$(TO LEN n$-2)
                IF n$="" THEN InputNumber=-1
            endif
        endif   
        'Pressed ENTER
        IF PressedKey=enter THEN 
            if (InputNumber>=min AND InputNumber<=max) THEN 
                condition=true
            else
                BORDER red
                BEEP .2,-10
                BORDER black
            endif
        endif
        PRINT AT row,col;n$; INVERSE true; FLASH true;" "; FLASH false; INVERSE false;" "
    LOOP until condition=true
    PRINT AT 22,0;"                                "
    PRINT AT 23,0;"                               "
    InputNumber=VAL(n$)
    PRINT AT row,col;InputNumber;" "
    return InputNumber
End Function

Function AskText(row as ubyte,col as ubyte,maxlenght as ubyte) as string
    ' AskText
    ' row,col = text coordinates
    ' maxlenght = max lenght of the text
    ' Characters between code 33(!) and 126 (~) are allowed
    dim PressedKey as integer
    dim condition,InputText as integer
    dim n$ as string
    
    PRINT AT 22,0; INVERSE true;"Type your text; ENTER to confirm   "
    PRINT AT row,col; FLASH true; INVERSE true;" "
    InputText=-1
    condition=false
    n$=""
    DO
        PAUSE 0
        PressedKey=PEEK(LastK)
        BEEP .01,-2
        IF (PressedKey>32 AND PressedKey<127) THEN 
            if len n$ < maxlenght then
                n$=n$+CHR$(PressedKey)
                InputText=InputText+1
            end if
        end if
        
        'Pressed DELETE
        IF PressedKey=delete THEN 
            IF LEN n$>0 THEN 
                n$=n$(TO LEN n$-2)
                IF n$="" THEN InputText=-1
            endif
        endif   

        'Pressed ENTER
        IF PressedKey=enter THEN 
            if len n$ >0 THEN 
                condition=true
            else
                BORDER red
                BEEP .2,-10
                BORDER black
            endif
        endif
        PRINT AT row,col;n$; INVERSE true; FLASH true;" "; FLASH false; INVERSE false;" "
    LOOP until condition=true
    PRINT AT 22,0;"                                "
    PRINT AT 23,0;"                               "
    PRINT AT row,col;n$;" "
    return n$
End Function