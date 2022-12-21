function typex(ptr)
    local typ = type(ptr)
    if typ == "userdata" then
        typ = tostring(ptr):match("([^\037s]+):")
        if typ == nil then
            typ = "userdata"
        end
    elseif typ == "number" then
        if  tostring(ptr):match("([^\037s]+).") then return "real" else return "int" end
    end
    return typ
end


---@param bool boolean 
---@return integer
function B2I( bool )
    if bool then return 1 end
    return 0
end

---@param index integer
---@return any
function CaseValue( index, ... )
    local values = {...}
    return values[index]
end

---@param value any, defaultValue any
---@return any
function Default( value, defaultValue )
    if not value then
        return defaultValue
    end
    return value
end

---@param msg string
---@param line string
---@param reason string
---@param isRU boolean
function Error( ... )
    local msg, line, reason, isRU = ...

    if isRU then 
        if msg then print("|cffff2815Ошибка:|" .. msg ) end
        if line then print("|cffffa010Линия:|r".. line ) end
        if reason then print("|cffffa010Причина:|r\n".. reason ) end
    else
        if msg then print("|cffff2815Error:|" .. msg ) end
        if line then print("|cffffa010Line:|r".. line ) end
        if reason then print("|cffffa010Reason:|r\n".. reason ) end
    end

end

---@param object table
function DeleteObject( object )
    
    if object.isHero or object.isItem then
        object.bonus.herostats = nil
    end

    object.userdata = nil
    object.bonus    = nil

end

function class()
    local a_class = {}
    local m_class = {__index = a_class}
    
    function a_class.instance()
        return setmetatable({}, m_class)
    end
    return a_class
end

objects = class()

function objects.x(self,...)
    local x = ...
    if x then
        if self.type == "unit" then SetUnitX( self.object, x ) end
        if self.type == "item" then SetItemPosition( self.object, x, GetWidgetY(self.object) ) end
        return x
    end
    return GetWidgetX( self.object )
end

function objects.y(self,...)
    local y = ...
    if y then
        if self.type == "unit" then SetUnitY( self.object, y ) end
        if self.type == "item" then SetItemPosition( self.object, GetWidgetY(self.object), y  ) end
        return y
    end
    return GetWidgetY( self.object )
end

function objects.name( self, ... )
    local name = ...
    local nameof
    local nameset 
    if self.type == "" then
        nameof  =   GetUnitName 
        nameset =   BlzSetUnitName
    elseif self.type == "item" then
        nameof  =   GetItemName
        nameset =   BlzSetItemName
    end
    if name then
        nameset( self.object, name )
        return name
    end
    return nameof(self.object)
end

function objects.heroname( self, ... )
    local prop = ...
    if prop then
        BlzSetHeroProperName( self.object, prop )
        return prop
    end
    return GetHeroProperName( self.object )
end

function objects.boostHP( self, ...)
    local hp, minus = ...
    hp = math.tointeger( math.floor( hp ) )
    if minus then
        if BlzGetUnitMaxHP( self.object ) > hp then
            BlzSetUnitMaxHP( self.object, BlzGetUnitMaxHP( self.object ) - hp )
            self.bonus.hp = self.bonus.hp - hp
        end
    else
        if ( BlzGetUnitMaxHP( self.object ) + hp ) < 2000000000 then
            BlzSetUnitMaxHP( self.object, BlzGetUnitMaxHP( self.object ) + hp )
            self.bonus.hp = self.bonus.hp + hp
        end
    end
end

function objects.boostMP( self, ... )
    local mp, minus = ...
    mp = math.tointeger( math.floor( mp ) )
    if minus then
        if BlzGetUnitMaxMana( self.object ) >= mp then
            BlzGetUnitMaxMana( self.object, BlzGetUnitMaxMana( self.object ) - mp )
            self.bonus.mp = self.bonus.mp - mp
        end
    else
        if ( BlzGetUnitMaxMana( self.object ) + mp ) < 2000000000 then
            BlzGetUnitMaxMana( self.object, BlzGetUnitMaxMana( self.object ) + mp )
            self.bonus.mp = self.bonus.mp + mp
        end
    end
end

function objects.maxMP(self)
    return BlzGetUnitMaxMana( self.object )
end

function objects.maxHP(self)
    return BlzGetUnitMaxHP( self.object )
end

function objects.object( ... )
    local object = objects.instance()
    
    local parameterWidget, parameterName = ...

    
    object.name = Default( parameterName, "Unnamed" )

    object.type     = extratype(parameterWidget)
    object.object   = parameterWidget

    if object.type == "unit" then
        object.isHero = IsUnitType(object.object, UNIT_TYPE_HERO )
    elseif object.type == "item" then 
        object.isItem = true
    end

    object.userdata = {}

    object.bonus = {}

    if object.isHero or object.isItem then
        object.bonus.herostats = {}
    end

    object.bonus.attack         = 0
    object.bonus.armor          = 0
    object.bonus.attackspeed    = 0

    object.bonus.hp             = 0
    object.bonus.mp             = 0

    object.resist   = 0.0
    object.mresist  = 0.0   -- manaburn resistance

    return object
end


---@param x real
---@param y real
---@param r real 
function gfletch( x, y, r, ... )
    local forSquad = ...
    GroupEnumUnitsInRange( Game.Squad, x, y, r, nil )
    if forSquad and type(forSquad) == "function" then
        forSquad()
    end
end

function bootCore()
    Map.World = GetWorldBounds()

    const.fix_xx = GetRectMaxX(Map.World) - 100.0
    const.fix_xy = GetRectMaxY(Map.World) - 100.0
    const.fix_mx = GetRectMinX(Map.World) + 100.0
    const.fix_my = GetRectMinY(Map.World) + 100.0

    Game.Squad  = CreateGroup()
    Game.Xash   = InitHashtable()
    
end
