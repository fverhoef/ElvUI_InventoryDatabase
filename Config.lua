local addonName, addonTable = ...
local Addon = addonTable[1]
local E, L, V, P, G = unpack(ElvUI)

P[addonName] = {
    tooltips = {
        enabled = true
    }
}

if E.db[addonName] == nil then
    E.db[addonName] = P[addonName]
end

function Addon:InsertOptions()
    local options = {
        order = 100,
        type = "group",
        name = Addon.title,
        childGroups = "tab",
        args = {
            name = {order = 1, type = "header", name = Addon.title},
            tooltips = {
                order = 10,
                type = "group",
                name = L["Tooltips"],
                inline = true,
                args = {
                    enabled = {
                        type = "toggle",
                        name = L["Enabled"],
                        order = 1,
                        get = function(info)
                            return E.db[addonName].tooltips.enabled
                        end,
                        set = function(info, value)
                            E.db[addonName].tooltips.enabled = value
                        end
                    }
                }
            }
        }
    }

    E.Options.args[addonName] = options
end
