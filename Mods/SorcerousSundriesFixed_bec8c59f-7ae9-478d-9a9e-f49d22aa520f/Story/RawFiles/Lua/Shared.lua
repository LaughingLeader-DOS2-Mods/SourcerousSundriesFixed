local giftBagTextFiles = {
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Armor.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Armor.txt",
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Shield.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Shield.txt",
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Weapon.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Weapon.txt",
}

--- Reverts all of the Sundries overrides to all weapon/armor/shield stat files.
--- Sundries overrides everything, including NPC stats, to add combo categories.
--- We can just add the categories with the extender to maintain compatibility instead.
for file,override in pairs(giftBagTextFiles) do
    Ext.IO.AddPathOverride(file, override)
    --Ext.Print("[SorcerousSundriesFixed:Shared.lua] Overriding gift bag file ("..file..") with ("..override..").")
end

Ext.Events.SessionLoaded:Subscribe(function (e)
    if Mods.LeaderLib and Mods.LeaderLib.Vars and Mods.LeaderLib.Vars.GetModInfoIgnoredMods then
        --Unignore Sorcerous Sundries since we got rid of all the stat overrides
        Mods.LeaderLib.Vars.GetModInfoIgnoredMods["a945eefa-530c-4bca-a29c-a51450f8e181"] = false
    end
end)

local STAT_BLACKLIST = {
    NoWeapon = true,
    NoShield = true,
}

local WEAPON_PREFIX_BLACKLIST = {
    Damage_ = true,
    DamageSurface_ = true,
    Status_ = true,
    Skill_ = true,
}

local comboCategories = {
    Armor = {
        Helmet = "UpgradeArmour",
        Breast = "UpgradeArmour",
        Leggings = "UpgradeArmour",
        Boots = "UpgradeArmour",
        Gloves = "UpgradeArmour",
        Ring = "UpgradeJewellery",
        Ring2 = "UpgradeJewellery",
        Belt = "UpgradeJewellery",
        Amulet = "UpgradeJewellery",
    },
    Weapon = "UpgradeWeapon",
    Shield = "UpgradeShield"
}

local function StartsWith(target,str)
    return string.sub(target,1,string.len(str))==str
end

---@param statID string
---@param stat StatEntryWeapon
local function IgnoreWeapon(statID, stat)
    local itemgroup = stat.ItemGroup
    if itemgroup == nil or itemgroup == "" then
        return true
    end
    for word,b in pairs(WEAPON_PREFIX_BLACKLIST) do
        if b == true then
            --if string.find(stat, word) then return true end
            if StartsWith(statID, word) then return true end
        end
	end
	return false
end

---@param statID string
---@param stat StatEntryWeapon
---@param statType string
local function IgnoreStat(statID, stat, statType)
    if string.sub(statID, 1, 1) == "_" or STAT_BLACKLIST[statID] == true then -- Ignore NPC weapons
        return true
    end
    local modifierType = stat.ModifierType
    if modifierType ~= nil and modifierType ~= "Item" then -- Ignore Boost, Skill, etc
        return true
    end
    if statType == "Weapon" and IgnoreWeapon(statID, stat) then
        return true
    end
    return false
end

local function HasComboCategory(categoryTable, category)
    if categoryTable == nil then return false end
    for i,v in pairs(categoryTable) do
        if v == category then return true end
    end
    return false
end

local function AddComboCategories()
	--Ext.Print("===================================================================")
	--Ext.Print("[SorcerousSundriesFixed] Adding crafting categories to all non-NPC equipment stats.")
    local totalOverrides = 0
    for statType,v in pairs(comboCategories) do
        local stats = Ext.Stats.GetStats(statType)
        for i,statID in pairs(stats) do
            local stat = Ext.Stats.Get(statID, nil, false)
            if not IgnoreStat(statID, stat, statType) then
                local addCategory = nil
                if type(v) == "table" then
                    local slot = stat.Slot
                    addCategory = v[slot]
                else
                    addCategory = v
                end
                if addCategory ~= nil then
                    local combocategory = stat.ComboCategory
                    if not HasComboCategory(combocategory, addCategory) then
                        if type(combocategory) == "table" then
                            combocategory[#combocategory+1] = addCategory
                            stat.ComboCategory = combocategory
                            totalOverrides = totalOverrides + 1
                        else
                            stat.ComboCategory = {addCategory}
                            totalOverrides = totalOverrides + 1
                        end
                    end
                end
            end
        end
    end
	Ext.Utils.Print("[SorcerousSundriesFixed] Added upgrade categories to ("..tostring(totalOverrides)..") stats.")
    --Ext.Print("===================================================================")
end

Ext.Events.StatsLoaded:Subscribe(AddComboCategories)
--Ext.RegisterListener("ModuleResume", AddComboCategories)
--Ext.RegisterListener("ModuleLoading", AddComboCategories)