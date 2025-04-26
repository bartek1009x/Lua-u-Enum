--!strict

export type EnumType = {
	new: ({string}) -> (EnumType),
	values: (EnumType) -> ({string}),
	compare: (EnumType, number, number) -> (number),
	getByOrdinal: (EnumType, number) -> (string?),
	next: (EnumType, number) -> (number?),
	previous: (EnumType, number) -> (number?),
	
	[string] : number
}

local enum = {}
enum.__index = enum

local reservedNames = {
	new = true, 
	values = true,
	compare = true, 
	getByOrdinal = true, 
	next = true,
	previous = true
} :: {[string] : boolean}

function enum.new(values: {string}) : EnumType
	local self = {}

	for i, v in ipairs(values) do
		if typeof(v) ~= "string" then
			error("Only strings are allowed for enums")
		elseif reservedNames[v] then
			error("\"" .. v .. "\" is a reserved keyword and isn't allowed for enums")
		end

		self[v] = i
	end

	setmetatable(self, enum)
	
	return table.freeze(self) :: EnumType
end

function enum.values(self: EnumType) : {string}
	local vals = {}

	for i, _ in pairs(self) do
		if typeof(i) == "string" then
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

function enum.compare(self: EnumType, val1: number, val2: number) : number
	return val1 - val2
end

function enum.getByOrdinal(self: EnumType, ordinal: number) : string?
	for i, v in pairs(self) do
		if typeof(i) == "string" and v == ordinal then
			return i
		end
	end
	return nil
end

function enum.next(self: EnumType, current: number) : number?
	for i, v in pairs(self) do
		if typeof(i) == "string" and v == current + 1 then
			return v :: number
		end
	end
	return nil
end

function enum.previous(self: EnumType, current: number) : number?
	for i, v in pairs(self) do
		if typeof(i) == "string" and v == current - 1 then
			return v :: number
		end
	end
	return nil
end

return table.freeze(enum) :: typeof(enum)