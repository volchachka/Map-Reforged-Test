function ToHex(v)

    local hex = "0123456789ABCDEF"
    local z = v
    local m = 0
    local str = ""
    
    if z == 0 then return "0" end
        
    while z > 0 do
        m = ( z % 16 ) + 1
        z = math.floor(z / 16)
        str = string.sub(hex,m,m) .. str
    end
    
    return str
end


function RV2I(r)
   if string.len(r) == 4  then
       local int = string.byte(r,4,4) + string.byte(r,3,3) * 256 + string.byte(r,2,2) * 65536 + string.byte(r,1,1) * 16777216
       return int
   end
    return 0
end

function RV2X(r)
    if string.len(r) == 4  then
        local int = string.byte(r,4,4) + string.byte(r,3,3) * 256 + string.byte(r,2,2) * 65536 + string.byte(r,1,1) * 16777216
        return ToHex(r)
    end
     return 0
end

function callback( time, ... )
    local isRepeat = time < 0
    local timeout  = isRepeat and time * (-1) or time
    local code, timer = ...
        if not timer then
            timer = CreateTimer()
        end
    if code then
        TimerStart(timer, timeout, isRepeat, code )
    else
        TimerStart( timer, timeout, isRepeat, nil )
    end 

    return timer
end