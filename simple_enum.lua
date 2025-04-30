-- License: https://github.com/bartek1009x/SimpleEnum/blob/main/LICENSE

local simpleenum = {}
simpleenum.__index = simpleenum

local reservedNames = {
    new = true,
    values = true,
    ordinals = true,
    compare = true,
    getByOrdinal = true,
    next = true,
    previous = true,
    nextOrdinal = true,
    previousOrdinal = true
}

local unpack = table.unpack or unpack

-- using do to make a new scope in which _values will be kept as a "private" table
-- that the users won't be able to access or overwrite
do
    local _values = {}

    function simpleenum.new(values)
        assert(values and #values > 0, "Provide the string enum values")
    
        local self = {}
        
        for i, v in ipairs(values) do
            if type(v) ~= "string" then
                error("Only strings are allowed for enums")
            elseif reservedNames[v] then
                error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
            elseif self[v] then
                error("Enum value duplicates are not allowed")
            end
            
            table.insert(_values, v)
            self[v] = i
        end
    
        setmetatable(self, {
            __index = simpleenum,
            __newindex = function()
                error("Enums are immutable")
            end
        })
        
        return self
    end
    
    function simpleenum:values()
        return { unpack(_values) }
    end
    
    function simpleenum:ordinals()
        local ordinals = {}
    
        for i = 1, #_values do
            ordinals[i] = i
        end
    
        return ordinals
    end
    
    function simpleenum:compare(val1, val2)
        assert(type(val1) == "number" and type(val2) == "number", "You need to provide two simpleenum values to compare")
    
        return val1 - val2
    end
    
    function simpleenum:getByOrdinal(ordinal)
        assert(type(ordinal) == "number", "You need to provide the ordinal to get the enum value from")
        assert(ordinal > 0 and ordinal <= #_values, "Trying to get enum value by ordinal " .. ordinal .. ", while the ordinal can be in range 1 to " .. #_values)
    
        return _values[ordinal]
    end
    
    function simpleenum:next(current)
        assert(type(current) == "number", "You need to provide the enum value to get the next one from")
    
        if _values[current + 1] then
            return _values[current + 1]
        end
        return nil
    end
    
    function simpleenum:previous(current)
        assert(type(current) == "number", "You need to provide the enum value to get the previous one from")
        
        if _values[current - 1] then
            return _values[current - 1]
        end
        return nil
    end
    
    function simpleenum:nextOrdinal(current)
        assert(type(current) == "number", "You need to provide the enum value to get the next ordinal from")
    
        if _values[current + 1] then
            return current + 1
        end
        return nil
    end
    
    function simpleenum:previousOrdinal(current)
        assert(type(current) == "number", "You need to provide the enum value to get the previous ordinal from")
        
        if _values[current - 1] then
            return current - 1
        end
        return nil
    end
    
end

return simpleenum