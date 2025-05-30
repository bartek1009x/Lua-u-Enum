-- License: https://github.com/bartek1009x/SimpleEnum/blob/main/LICENSE

--!strict

export type EnumType = {
	new: (values: {string}) -> (EnumType),
	values: (self: EnumType) -> ({string}),
	ordinals: (self: EnumType) -> ({number}),
	compare: (self: EnumType, enumValue1: number, enumValue2: number) -> (number),
	getByOrdinal: (self: EnumType, ordinal: number) -> (string?),
	next: (self: EnumType, enumValue: number) -> (string?),
	previous: (self: EnumType, enumValue: number) -> (string?),
	nextOrdinal: (self: EnumType, enumValue: number) -> (number?),
	previousOrdinal: (self: EnumType, enumValue: number) -> (number?),

	[string] : number
}

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
} :: {[string] : boolean}

-- using do to make a new scope in which _values will be kept as a "private" table
-- that the users won't be able to access or overwrite
do
	local _values = {} :: {string}

	function simpleenum.new(values: {string}) : EnumType
		assert(typeof(values) == "table" and #values > 0, "Provide the string enum values")
	
		local self = {} :: any
		
		for i, v in ipairs(values) do
			if typeof(v) ~= "string" then
				error("Only strings are allowed for enums")
			elseif reservedNames[v] then
				error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
			elseif self[v] then
				error("Enum value duplicates are not allowed")
			end
	
			table.insert(_values, v)
			self[v] = i
		end
	
		setmetatable(self, simpleenum)
		
		return table.freeze(self) :: EnumType
	end
	
	function simpleenum:values() : {string}
		return { table.unpack(_values) }
	end
	
	function simpleenum:ordinals() : {number}
		local ordinals = {}
	
		for i = 1, #_values do
			ordinals[i] = i
		end
	
		return ordinals
	end
	
	function simpleenum:compare(val1: number, val2: number) : number
		assert(typeof(val1) == "number" and typeof(val2) == "number", "You need to provide two enum values to compare")
	
		return val1 - val2
	end
	
	function simpleenum:getByOrdinal(ordinal: number) : string?
		assert(typeof(ordinal) == "number", "You need to provide the ordinal to get the enum value from")
		assert(ordinal > 0 and ordinal <= #_values, "Trying to get enum value by ordinal " .. ordinal .. ", while the ordinal can be in range 1 to " .. #_values)
	
		return _values[ordinal]
	end
	
	function simpleenum:next(current: number) : string?
		assert(typeof(current) == "number", "You need to provide the enum value to get the next one from")
	
		if _values[current + 1] then
			return _values[current + 1]
		end
		return nil
	end
	
	function simpleenum:previous(current: number) : string?
		assert(typeof(current) == "number", "You need to provide the enum value to get the previous one from")
	
		if _values[current - 1] then
			return _values[current - 1]
		end
		return nil
	end
	
	function simpleenum:nextOrdinal(current: number) : number?
		assert(typeof(current) == "number", "You need to provide the enum value to get the next ordinal from")
	
		if _values[current + 1] then
			return current + 1
		end
		return nil
	end
	
	function simpleenum:previousOrdinal(current: number) : number?
		assert(typeof(current) == "number", "You need to provide the enum value to get the previous ordinal from")
	
		if _values[current - 1] then
			return current - 1
		end
		return nil
	end
	
end

return table.freeze(simpleenum) :: typeof(simpleenum)