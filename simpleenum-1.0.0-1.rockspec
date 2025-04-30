package = "simpleenum"
version = "1.0.0-1"
source = {
    url = "https://raw.githubusercontent.com/bartek1009x/SimpleEnum/main/simple_enum.lua",
    file = "simple_enum.lua"
}
description = {
   summary = "A simple enum implementation in Lua.",
   detailed = [[
        A simple enum implementation in Lua
        inspired by Java enums and the JavaScript implementation
        by @herb-ert (https://github.com/herb-ert).
    ]],
   homepage = "https://github.com/bartek1009x/SimpleEnum",
   license = "MIT"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        simpleenum = "simple_enum.lua"
    }
}