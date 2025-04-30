local enum = {}
enum.__index = enum

local reservedNames = {
    new = true,
    values = true,
    ordinals = true,
    _values = true,
    compare = true,
    getByOrdinal = true,
    next = true,
    previous = true,
    nextOrdinal = true,
    previousOrdinal = true
}

local unpack = table.unpack or unpack

function enum.new(values)
	assert(values and #values > 0, "Provide the string enum values")

    local self = {}

    self._values = {}

    for i, v in ipairs(values) do
        if type(v) ~= "string" then
            error("Only strings are allowed for enums")
        elseif reservedNames[v] then
            error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
        end
        
        table.insert(self._values, v)
        self[v] = i
    end

    local mt = {
        __index = enum,
        __newindex = function()
            error("Enums are immutable")
        end
    }

    setmetatable(self, mt)
    
    return self
end

function enum:values()
    return { unpack(self._values) }
end

function enum:ordinals()
    local ordinals = {}

    for i = 1, #self._values do
        ordinals[i] = i
    end

    return ordinals
end

function enum:compare(val1, val2)
	assert(type(val1) == "number" and type(val2) == "number", "You need to provide two enum values to compare")

    return val1 - val2
end

function enum:getByOrdinal(ordinal)
	assert(type(ordinal) == "number", "You need to provide the ordinal to get the enum value from")
    assert(ordinal > 0 and ordinal <= #self._values, "Trying to get enum value by ordinal " .. ordinal .. ", while the ordinal can be in range 1 to " .. #self._values)

    return self._values[ordinal]
end

function enum:next(current)
	assert(type(current) == "number", "You need to provide the enum value to get the next one from")

    if self._values[current + 1] then
        return self._values[current + 1]
    end
    return nil
end

function enum:previous(current)
	assert(type(current) == "number", "You need to provide the enum value to get the previous one from")
    
    if self._values[current - 1] then
        return self._values[current - 1]
    end
    return nil
end

function enum:nextOrdinal(current)
	assert(type(current) == "number", "You need to provide the enum value to get the next ordinal from")

    if self._values[current + 1] then
        return current + 1
    end
    return nil
end

function enum:previousOrdinal(current)
	assert(type(current) == "number", "You need to provide the enum value to get the previous ordinal from")
    
    if self._values[current - 1] then
        return current - 1
    end
    return nil
end

return enum