declare function author$(type as string) as string

print author$("name")
print author$("email")

/'
text$="2023"
for x=len text$ -1 to 0 step -1
    print (code text$(x)),755-code(text$(x))
next x
restore antidump_name:
coded$=""
do
    read x
    if x<>0 then coded$=coded$+chr$(755-x)
loop until x=0

for x=len coded$ to 0 step -1
    print coded$(x);
next x 
'/

function author$(type as string) as string
    dim coded$,codedrev$ as string
    dim number as integer
    if type="name" then
        restore antidump_name
    elseif type="email" then
        restore antidump_email
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
    antidump_email:
    data 639,650,709,650,647,658,656,640,650,639,691,658,656,641,658,709,644,645,658,650,647,650,646,650,640,640,658,646,0
    antidump_name:
    data 704,705,707,705,723,658,656,641,690,723,644,645,658,650,647,650,646,650,640,640,658,678,0
end function
    