# Lua(u) Enum
A simple Enum class implementation for both Lua and Luau, inspired by Java's Enums and the way [@herb-ert](https://github.com/herb-ert) implemented enums in js.

Both implementations are almost the same, with the only differences being that the Luau implementation is fully typed and replaces some Lua functionality with Luau specific versions (for example the Luau version uses table.freeze instead of setting the __newindex of the enum to ensure immutability).

> [!NOTE]
> The Lua version should work with all 5.1+ Lua versions

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
print(DayState:next(DayState.DUSK)) -- NIGHT
print(DayState:previous(DayState.DUSK)) -- DAY
print(DayState:nextOrdinal(DayState.DUSK)) -- 3
print(DayState:previousOrdinal(DayState.DUSK)) -- 1
print(DayState:getByOrdinal(4)) -- DAWN
```
