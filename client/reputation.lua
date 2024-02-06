local config = require 'config.client'
local shared = require 'config.shared'
local REPUTATION = {}

local function RequestReputation()
    local rep = lib.callback.await('groups:GetRep', false)
    REPUTATION = rep
    return rep
end

local function GetSingleRep(reputation)
    if REPUTATION[reputation] then
        return REPUTATION[reputation]
    else
        RequestReputation()
        
        if REPUTATION[reputation] then
            return REPUTATION[reputation]
        else
            REPUTATION[reputation] = 0
            return REPUTATION[reputation]
        end
    end
end

-- EVENTS
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    RequestReputation()
end)

AddEventHandler("onResourceStart", function(name)
    if name ~= GetCurrentResourceName() then return end
    RequestReputation()
end)

RegisterNetEvent("groups:reputation:update", function(reputation)
    REPUTATION = reputation
    Debug('Reputation Update', 'Player reputation updated')
end)

-- EXPORTS
local function GetReputation()
    return REPUTATION
end exports('GetReputation', GetReputation)

local function GetReputationFor(reputation)
    return GetSingleRep(reputation)
end exports('GetReputationFor', GetReputationFor)