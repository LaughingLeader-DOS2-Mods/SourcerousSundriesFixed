local giftBagFiles = {
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Armor.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Armor.txt",
    --["Public/CMP_LevelUpEquipment/Stats/Generated/Data/ItemProgressionVisuals.txt"] = "",
    --["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Object.txt"] = "",
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Shield.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Shield.txt",
    ["Public/CMP_LevelUpEquipment/Stats/Generated/Data/Weapon.txt"] = "Public/SorcerousSundriesFixed_bec8c59f-7ae9-478d-9a9e-f49d22aa520f/Stats/Generated/Data/LLSUNDRIES_Weapon.txt",
}

local function LLSUNDRIES_RemoveGiftBagOverrides()
    for file,override in pairs(giftBagFiles) do
        Ext.AddPathOverride(file, override)
        Ext.Print("[SorcerousSundriesFixed:Shared.lua] Overriding gift bag file ("..file..") with ("..override..").")
    end
end

--LLSUNDRIES_RemoveGiftBagOverrides()
Ext.RegisterListener("ModuleResume", LLSUNDRIES_RemoveGiftBagOverrides)

local BLACKLIST = {
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
    return string.sub(target,0,string.len(str))==str
end

local function IgnoreWeapon(stat)
    local itemgroup = Ext.StatGetAttribute(stat, "ItemGroup")
    if itemgroup == nil or itemgroup == "" then
        return true
    end
    for word,b in pairs(WEAPON_PREFIX_BLACKLIST) do
        if b == true then
            --if string.find(stat, word) then return true end
            if StartsWith(stat, word) then return true end
        end
	end
	return false
end

local function IgnoreStat(stat, statType)
    if string.sub(stat, 1, 1) == "_" or BLACKLIST[stat] == true then
        return true
    end
    local modifierType = Ext.StatGetAttribute(stat, "ModifierType")
    if modifierType ~= nil and modifierType ~= "Item" then -- Ignore Boost, Skill, etc
        return true
    end
    if statType == "Weapon" and IgnoreWeapon(stat) then
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

local function ModuleLoading_AddComboCategory()
    LLSUNDRIES_RemoveGiftBagOverrides()
	Ext.Print("===================================================================")
	Ext.Print("[SorcerousSundriesFixed:Bootstrap.lua] Adding crafting categories to all non-NPC equipment stats.")
    local totalOverrides = 0
    for statType,v in pairs(comboCategories) do
        local stats = Ext.GetStatEntries(statType)
        for i,stat in pairs(stats) do
            if not IgnoreStat(stat, statType) then
                local addCategory = nil
                if type(v) == "table" then
                    local slot = Ext.StatGetAttribute(stat, "Slot")
                    addCategory = v[slot]
                else
                    addCategory = v
                end
                if addCategory ~= nil then
                    local combocategory = Ext.StatGetAttribute(stat, "ComboCategory")
                    if not HasComboCategory(combocategory, addCategory) then
                        if combocategory ~= nil and combocategory ~= "" then
                            combocategory[#combocategory+1] = addCategory
                            Ext.StatSetAttribute(stat, "ComboCategory", combocategory)
                            --Ext.Print("[SorcerousSundriesFixed:Shared.lua] Added "..addCategory.." to ("..stat..").")
                            --Ext.Print(Ext.JsonStringify(combocategory))
                            totalOverrides = totalOverrides + 1
                        else
                            Ext.StatSetAttribute(stat, "ComboCategory", {addCategory})
                            --Ext.Print("[SorcerousSundriesFixed:Shared.lua] Set ComboCategory for ("..stat..") to ("..addCategory..").")
                            totalOverrides = totalOverrides + 1
                        end
                    end
                end
            end
        end
    end
	Ext.Print("[SorcerousSundriesFixed:Bootstrap.lua] Added upgrade categories to ("..tostring(totalOverrides)..") stats.")
    Ext.Print("===================================================================")

    Ext.Print("_Swords check:")
    Ext.Print(Ext.StatGetAttribute("_Swords", "WeaponType"))
end

Ext.RegisterListener("ModuleLoading", ModuleLoading_AddComboCategory)