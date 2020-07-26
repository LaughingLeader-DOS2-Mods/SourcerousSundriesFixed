Ext.Require("Shared.lua")

if Ext.IsDeveloperMode() then
    Ext.RegisterConsoleCommand("sundriestest", function(command, level)
        local host = CharacterGetHostCharacter()
        local x,y,z = GetPosition(host)
        if level == nil then
            level = 1
        end
        -- Azure Flint for weapon upgrades
        ItemTemplateAddTo("b0d72e19-6d37-4582-9008-98a486e0cf64", host, 1, 1)
        
        -- Sword Template
        --local sword = CreateItemTemplateAtPosition("374cf6c2-3606-49a9-875b-be0adf103807", x, y, z)
        --NRD_ItemCloneBegin(sword)
        NRD_ItemConstructBegin("374cf6c2-3606-49a9-875b-be0adf103807")
        --NRD_ItemCloneResetProgression()
        NRD_ItemCloneSetString("GenerationStatsId", "WPN_Sword_2H")
        NRD_ItemCloneSetString("StatsEntryName", "WPN_Sword_2H")
        NRD_ItemCloneSetInt("HasGeneratedStats", 1)
        NRD_ItemCloneSetInt("GenerationLevel", level)
        NRD_ItemCloneSetInt("StatsLevel", level)
        NRD_ItemCloneSetInt("IsIdentified", 1)
        NRD_ItemCloneSetString("ItemType", "Divine")
        NRD_ItemCloneSetString("GenerationItemType", "Epic")
        local item = NRD_ItemClone()
        ItemToInventory(item, host, 1, 1, 1)
        --NRD_ItemSetIdentified(item, 1)
        
        local itemObj = Ext.GetItem(item).Stats
        print("ComboCategory:", Ext.JsonStringify(itemObj.ComboCategory))
        --ItemRemove(sword)
    end)
    local recipes = {
        "UpgradeWeapon_Common_LUE_Azure_Flint",
        "UpgradeWeapon_Uncommon_LUE_Azure_Flint",
        "UpgradeWeapon_Rare_LUE_Azure_Flint",
        "UpgradeWeapon_Epic_LUE_Azure_Flint",
        "UpgradeWeapon_Divine_LUE_Azure_Flint",
        "UpgradeWeapon_Legendary_LUE_Azure_Flint",
        "UpgradeWeapon_Unique_LUE_Azure_Flint",
        "UpgradeShield_Common_LUE_Diamond_Dust",
        "UpgradeShield_Uncommon_LUE_Diamond_Dust",
        "UpgradeShield_Rare_LUE_Diamond_Dust",
        "UpgradeShield_Epic_LUE_Diamond_Dust",
        "UpgradeShield_Divine_LUE_Diamond_Dust",
        "UpgradeShield_Legendary_LUE_Diamond_Dust",
        "UpgradeShield_Unique_LUE_Diamond_Dust",
        "UpgradeArmour_Common_LUE_Diamond_Dust",
        "UpgradeArmour_Uncommon_LUE_Diamond_Dust",
        "UpgradeArmour_Rare_LUE_Diamond_Dust",
        "UpgradeArmour_Epic_LUE_Diamond_Dust",
        "UpgradeArmour_Divine_LUE_Diamond_Dust",
        "UpgradeArmour_Legendary_LUE_Diamond_Dust",
        "UpgradeArmour_Unique_LUE_Diamond_Dust",
        "UpgradeJewelry_Common_LUE_Quicksilver",
        "UpgradeJewelry_Uncommon_LUE_Quicksilver",
        "UpgradeJewelry_Rare_LUE_Quicksilver",
        "UpgradeJewelry_Epic_LUE_Quicksilver",
        "UpgradeJewelry_Divine_LUE_Quicksilver",
        "UpgradeJewelry_Legendary_LUE_Quicksilver",
        "UpgradeJewelry_Unique_LUE_Quicksilver",
    }
    Ext.RegisterConsoleCommand("sundriesrecipes", function(command)
        local host = CharacterGetHostCharacter()
        for _,recipe in ipairs(recipes) do
            CharacterUnlockRecipe(host, recipe, 1)
        end
    end)
end