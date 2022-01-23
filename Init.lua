local addonName, addonTable = ...
local E, L, V, P, G = unpack(ElvUI) -- Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local EP = LibStub("LibElvUIPlugin-1.0")
local LSM = LibStub("LibSharedMedia-3.0")

local Addon = E:NewModule(addonName, "AceEvent-3.0")
Addon.name = "ElvUI Inventory Database"
Addon.title = "|cff1784d1ElvUI|r |cffb50568Inventory Database|r"
Addon.version = GetAddOnMetadata(addonName, "Version")

local build = select(4, GetBuildInfo())
Addon.isClassic = build < 20000
Addon.isTbc = build < 30000
Addon.isWotlk = build < 40000
Addon.isRetail = build > 40000

addonTable[1] = Addon
_G[addonName] = Addon

E:RegisterModule(Addon:GetName())