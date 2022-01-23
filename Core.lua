local addonName, addonTable = ...
local Addon = addonTable[1]
local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local B = E:GetModule("Bags")

function Addon:Initialize()
    EP:RegisterPlugin(addonName, Addon.InsertOptions)
    Addon:RegisterEvent("BAG_SLOT_FLAGS_UPDATED", Addon.Update)
    Addon:RegisterEvent("BAG_UPDATE", Addon.Update)
    Addon:RegisterEvent("BAG_UPDATE_COOLDOWN", Addon.Update)
    Addon:RegisterEvent("BAG_NEW_ITEMS_UPDATED", Addon.Update)
    Addon:RegisterEvent("QUEST_ACCEPTED", Addon.Update)
    Addon:RegisterEvent("QUEST_REMOVED", Addon.Update)
    Addon:RegisterEvent("PLAYER_MONEY", Addon.Update)
    Addon:RegisterEvent("PLAYER_TRADE_MONEY", Addon.Update)
    Addon:RegisterEvent("BANKFRAME_OPENED", Addon.Update)
    Addon:RegisterEvent("BANKFRAME_CLOSED", Addon.Update)
    Addon:RegisterEvent("PLAYERBANKBAGSLOTS_CHANGED", Addon.Update)
    Addon:Update()
end

function Addon:Update()
    local db = Addon:GetCharacterDatabase()
    db.money = GetMoney()

    db.equipped = {}
    local slots = {
        "HeadSlot",
        "NeckSlot",
        "ShoulderSlot",
        "BackSlot",
        "ChestSlot",
        "ShirtSlot",
        "TabardSlot",
        "WristSlot",
        "HandsSlot",
        "WaistSlot",
        "LegsSlot",
        "FeetSlot",
        "Finger0Slot",
        "Finger1Slot",
        "Trinket0Slot",
        "Trinket1Slot",
        "MainHandSlot",
        "SecondaryHandSlot"
    }

    if Addon.isClassic or Addon.isTbc then
        table.insert(slots, "RangedSlot")
    end

    for i, slot in next, slots do
        local link = GetInventoryItemLink("player", GetInventorySlotInfo(slot))
        if link then
            local itemId = Addon:GetItemIdFromLink(link)
            if itemId then
                db.equipped["" .. itemId] = 1
            end
        end
    end

    db.bags = {}
    Addon:StoreContainerContents(db, false)
    Addon:StoreContainerContents(db, true)
end

function Addon:GetCharacterDatabase(name)
    name = name or E.myname

    ElvDB = ElvDB or {}
    ElvDB.items = ElvDB.items or {}
    ElvDB.items.realm = ElvDB.items.realm or {}
    ElvDB.items.realm[E.myrealm] = ElvDB.items.realm[E.myrealm] or {}
    ElvDB.items.realm[E.myrealm].character = ElvDB.items.realm[E.myrealm].character or {}
    ElvDB.items.realm[E.myrealm].character[name] = ElvDB.items.realm[E.myrealm].character[name] or {}

    local db = ElvDB.items.realm[E.myrealm].character[name]
    db.class = db.class or E.myclass
    db.bags = db.bags or {}
    db.bank = db.bank or {}
    db.equipped = db.equipped or {}

    return db
end

function Addon:UpdateItemCount(itemId, db)
    if not itemId then
        return
    end
    db = db or Addon:GetCharacterDatabase()

    local equippedCount = db.equipped["" .. itemId] or 0
    local inventoryCount = GetItemCount(itemId, false) - equippedCount
    local allCount = GetItemCount(itemId, true) - equippedCount
    local bankCount = allCount - inventoryCount

    db.bags["" .. itemId] = inventoryCount
    db.bank["" .. itemId] = bankCount
end

function Addon:StoreContainerContents(db, isBank)
    local f = B:GetContainerFrame(isBank)
    if not f then
        return
    end

    for i, bagID in ipairs(f.BagIDs) do
        local numSlots = GetContainerNumSlots(bagID)
        for slotID = 1, numSlots do
            local itemId = select(10, GetContainerItemInfo(bagID, slotID))
            Addon:UpdateItemCount(itemId, db)
        end
    end
end
