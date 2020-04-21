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

Ext.RegisterListener("SessionLoading", SessionLoading)