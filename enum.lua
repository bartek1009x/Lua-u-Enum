local enum = {}
enum.__index = enum

local reservedNames = {
    new = true,
    values = true,
    compare = true,
    getByOrdinal = true,
    next = true,
    previous = true
}

function enum.new(values)
    local self = {}

    for i, v in ipairs(values) do
        if type(v) ~= "string" then
            error("Only strings are allowed for enums")
        else
            if reservedNames[v] then
                error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
            end
        end
        
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

function enum.values(self)
    local vals = {}
    
    for i, _ in pairs(self) do
        if type(i) == "string" then
            table.insert(vals, i)
        end
    end
    
    local mt = {
        __tostring = function(self)
            local printables = {}
            for _, v in pairs(self) do
                table.insert(printables, v)
            end
            return table.concat(printables, ", ")
        end
    }
    
    setmetatable(vals, mt)
    
    return vals
end

function enum.compare(self, val1, val2)
    return val1 - val2
end

function enum.getByOrdinal(self, ordinal)
    for i, v in pairs(self) do
        if type(i) == "string" and v == ordinal then
            return i
        end
    end
end

function enum.next(self, current)
    for i, v in pairs(self) do
        if type(i) == "string" and v == current + 1 then
            return v
        end
    end
end

function enum.previous(self, current)
    for i, v in pairs(self) do
        if type(i) == "string" and v == current - 1 then
            return v
        end
    end
end

return enum