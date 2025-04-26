# Lua(u) Enum
A simple Enum class implementation for both Lua and Luau, inspired by Java's Enums.

(The Lua version works with Lua 5.1+)

Both implementations are almost the same, with the only differences being that the Luau implementation is fully typed and it prevents enum modification with table.freeze() instead of setting the __newindex of the enum.

# Example usage
Using this module is the same for both Lua and Luau versions.

```lua
local enum = require("Enum")

local DayState = enum.new({
	"DAY",
	"DUSK",
	"NIGHT",
	"DAWN"
}) -- in Luau you could add ":: enum.EnumType" here

local currentDayState = DayState.DAY
print(currentDayState) -- 1

currentDayState = DayState:next(currentDayState)
print(currentDayState) -- 2

print(DayState.NIGHT == currentDayState) -- false
print(DayState:values()) -- DUSK, DAWN, NIGHT, DAY
print(DayState:compare(DayState.DAY, DayState.NIGHT)) -- -2, works the same as Java's compareTo
print(DayState:next(DayState.DUSK)) -- 3
print(DayState:previous(DayState.DUSK)) -- 1
print(DayState:getByOrdinal(4)) -- DAWN
```
