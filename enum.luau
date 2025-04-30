--!strict

export type EnumType = {
	new: ({string}) -> (EnumType),
	values: (EnumType) -> ({string}),
	compare: (EnumType, number, number) -> (number),
	getByOrdinal: (EnumType, number) -> (string?),
	next: (EnumType, number) -> (string?),
	previous: (EnumType, number) -> (string?),
	nextOrdinal: (EnumType, number) -> (number?),
	previousOrdinal: (EnumType, number) -> (number?),
	_values: {string},

	[string] : number
}

local enum = {}
enum.__index = enum

local reservedNames = {
	new = true, 
	values = true,
	_values = true,
	compare = true, 
	getByOrdinal = true, 
	next = true,
	previous = true,
	nextOrdinal = true,
	previousOrdinal = true
} :: {[string] : boolean}

function enum.new(values: {string}) : EnumType
	assert(values and #values > 0, "Provide the string enum values")

	local self = {}

	self._values = {}

	for i, v in ipairs(values) do
		if typeof(v) ~= "string" then
			error("Only strings are allowed for enums")
		elseif reservedNames[v] then
			error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
		end

		table.insert(self._values, v)
		self[v] = i
	end

	setmetatable(self, enum)
	
	return table.freeze(self) :: EnumType
end

function enum:values() : {string}
	return { table.unpack(self._values) }
end

function enum:compare(val1: number, val2: number) : number
	assert(typeof(val1) == "number" and typeof(val2) == "number", "You need to provide two enum values to compare")

	return val1 - val2
end

function enum:getByOrdinal(ordinal: number) : string?
	assert(typeof(ordinal) == "number", "You need to provide the ordinal to get the enum value from")
    assert(ordinal > 0 and ordinal <= #self._values, "Trying to get enum value by ordinal " .. ordinal .. ", while the ordinal can be in range 1 to " .. #self._values)

    return self._values[ordinal]
end

function enum:next(current: number) : string?
	assert(typeof(current) == "number", "You need to provide the enum value to get the next one from")

    if self._values[current + 1] then
        return self._values[current + 1]
    end
    return nil
end

function enum:previous(current: number) : string?
	assert(typeof(current) == "number", "You need to provide the enum value to get the previous one from")

	if self._values[current - 1] then
        return self._values[current - 1]
    end
    return nil
end

function enum:nextOrdinal(current: number) : number?
	assert(typeof(current) == "number", "You need to provide the enum value to get the next ordinal from")

    if self._values[current + 1] then
        return current + 1
    end
    return nil
end

function enum:previousOrdinal(current: number) : number?
	assert(typeof(current) == "number", "You need to provide the enum value to get the previous ordinal from")

	if self._values[current - 1] then
        return current - 1
    end
    return nil
end

return table.freeze(enum) :: typeof(enum)