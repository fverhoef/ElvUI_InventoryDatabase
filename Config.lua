local addonName, addonTable = ...
local Addon = addonTable[1]
local E, L, V, P, G = unpack(ElvUI)

function Addon:InsertOptions()
    local options = {
        order = 100,
        type = "group",
        name = Addon.title,
        childGroups = "tab",
        args = {
            name = {order = 1, type = "header", name = Addon.title}
        }
    }

    E.Options.args[addonName] = options
end
