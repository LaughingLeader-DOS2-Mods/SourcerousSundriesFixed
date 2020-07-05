Ext.Require("Shared.lua")

local function LLSUNDRIES_ModUpdated(past_version,new_version)
    Ext.Print("[SorcerousSundriesFixed:Bootstrap.lua:LLSUNDRIES_ModUpdated] Updated from ("..tostring(past_version)..")  to ("..tostring(new_version)..").")
end

local function LLSUNDRIES_Debug()
    local character = CharacterGetHostCharacter()
    if ObjectGetFlag(character, "LLSUNDRIES_DebugSet") == 0 then
        ItemTemplateAddTo("ec4769e6-bcfc-44e0-9e9c-de62e0bdf407", character, 1, 1)
        ObjectSetFlag(character, "LLSUNDRIES_DebugSet", 0)
    end
    PartyAddGold(character, 30000)
end

local function SessionLoading()
    if _G["LeaderLib_ModUpdater"] ~= nil then
        local update_table = _G["LeaderLib_ModUpdater"]
        update_table["bec8c59f-7ae9-478d-9a9e-f49d22aa520f"] = LLSUNDRIES_ModUpdated
    end

    if _G["LeaderLib_DebugInitCalls"] ~= nil then
        local debug_table = _G["LeaderLib_DebugInitCalls"]
        debug_table[#debug_table+1]= LLSUNDRIES_Debug
    end
end


if Ext.IsDeveloperMode() then
    Ext.RegisterListener("SessionLoading", SessionLoading)
    Ext.RegisterConsoleCommand("sundriestest", function(command, level)
        local host = CharacterGetHostCharacter()
        local x,y,z = GetPosition(host)
        if level == nil then
            level = 1
        end
        -- Azure Flint for weapon upgrades
        ItemTemplateAddTo("b0d72e19-6d37-4582-9008-98a486e0cf64", host, 1, 1)
        
        -- Sword Template
        local sword = CreateItemTemplateAtPosition("374cf6c2-3606-49a9-875b-be0adf103807", x, y, z)
        NRD_ItemCloneBegin(sword)
        --NRD_ItemConstructBegin("374cf6c2-3606-49a9-875b-be0adf103807")
        --NRD_ItemCloneResetProgression()
        NRD_ItemCloneSetString("GenerationStatsId", "WPN_Sword_2H")
        NRD_ItemCloneSetString("StatsEntryName", "WPN_Sword_2H")
        NRD_ItemCloneSetInt("HasGeneratedStats", 1)
        NRD_ItemCloneSetInt("GenerationLevel", level)
        NRD_ItemCloneSetInt("StatsLevel", level)
        NRD_ItemCloneSetInt("IsIdentified", 1)
        NRD_ItemCloneSetString("ItemType", "Divine")
        NRD_ItemCloneSetString("GenerationItemType", "Divine")
        local item = NRD_ItemClone()
        ItemToInventory(item, host, 1, 1, 1)
        NRD_ItemSetIdentified(item, 1)
        
        local itemObj = Ext.GetItem(item).Stats
        print("ComboCategory:", Ext.JsonStringify(itemObj.ComboCategory))
        ItemRemove(sword)
    end)
end