local addonName, addonTable = ...
local Addon = addonTable[1]
local E, L, V, P, G = unpack(ElvUI)

local function Hex(r, g, b)
    if (type(r) == "table") then
        if (r.r) then
            r, g, b = r.r, r.g, r.b
        else
            r, g, b = unpack(r)
        end
    end

    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function GetItemId(tooltip)
    local link = tooltip and select(2, tooltip:GetItem())    
    local itemLink = link and select(2, GetItemInfo(link))
    return Addon:GetItemIdFromLink(itemLink)
end

local function HookSetItem(tip)
    tip:HookScript("OnTooltipSetItem", function(tooltip)
        if not E.db[addonName].tooltips.enabled then
            return
        end
    
        -- disable built-in item counts
        E.db.tooltip.itemCount = "NONE"

        local itemId = GetItemId(tooltip)            
        if itemId then
            local counts = Addon:GetItemCounts(itemId)
            for name, count in next, counts do
                local value = ""
                if count.equipped > 0 then
                    value = L["Equipped"] .. ": " .. count.equipped
                end
                if count.bags > 0 then
                    if value ~= "" then
                        value = value .. " | "
                    end
                    value = value .. L["Bags"] .. ": " .. count.bags
                end
                if count.bank > 0 then
                    if value ~= "" then
                        value = value .. " | "
                    end
                    value = value .. L["Bank"] .. ": " .. count.bank
                end
        
                tooltip:AddDoubleLine(Hex(_G.RAID_CLASS_COLORS[count.class or "PRIEST"]) .. name .. "|r:", value)
            end

            tooltip:Show()
        end
    end)
end

function Addon:HookTooltips()
    HookSetItem(_G.GameTooltip)
    HookSetItem(_G.ItemRefTooltip)
end