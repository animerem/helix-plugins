local PLUGIN = PLUGIN

PLUGIN.name = "Freelook"
PLUGIN.author = "Rem & Darsu"
PLUGIN.description = "Creates rotations like in Rust, Tarkov, etc."

ix.config.Add("FreelookEnabled", true, "Enable or disable a plugin.", nil, {
    category = PLUGIN.name
})

ix.config.Add("FreelookLimV", 65, "The limit of vertical movement of the camera.", nil, {
    data = {min = 5, max = 100, decimals = 1},
    category = PLUGIN.name
})

ix.config.Add("FreelookLimH", 90, "The limit of horizontal movement of the camera.", nil, {
    data = {min = 5, max = 140, decimals = 1},
    category = PLUGIN.name
})

ix.config.Add("FreelookSmooth", 1, "Smoothness of turns.", nil, {
    data = {min = 0.1, max = 3, decimals = 1},
    category = PLUGIN.name
})

ix.config.Add("FreelookBlockADS", true, "Returning the camera when pressing RMB.", nil, {
    category = PLUGIN.name
})

ix.config.Add("FreelookBlockFire", true, "Shot blocking while turning.", nil, {
    category = PLUGIN.name
})

ix.util.Include("cl_plugin.lua")