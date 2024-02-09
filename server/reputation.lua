local reputation = {}
local CACHE = {}

local config = require 'config.server'
local shared = require 'config.shared'
local util = require 'server.util'

function reputation.CheckSaveState(citizenid)
    if config.SaveInterval == 0 then
        reputation.SavePlayerRep(citizenid)
        Debug('CheckSaveState 1', 'Save Interval push ' .. citizenid)
        return
    end

    if CACHE[citizenid].lastSaved then
        if CACHE[citizenid].lastSaved + config.SaveInterval <= os.time() then
            reputation.SavePlayerRep(citizenid)
            Debug('CheckSaveState 2', 'Save Interval push ' .. citizenid)
        end
    else
        CACHE[citizenid].lastSaved = os.time()
        reputation.SavePlayerRep(citizenid)
        Debug('CheckSaveState 3', 'Save Interval push ' .. citizenid)
    end
end

function reputation.GetPlayerRep(citizenid)
    local rep = MySQL.single.await("SELECT reputation FROM group_rep WHERE citizenid = ? LIMIT 1", { citizenid })
    if not rep then
        return {}
    else
        return json.decode(rep.reputation)
    end
end

function reputation.SavePlayerRep(citizenid)
    MySQL.Async.execute("INSERT INTO group_rep (citizenid, reputation) VALUES (@citizenid, @reputation) ON DUPLICATE KEY UPDATE reputation = @reputation", {
        ['@citizenid'] = citizenid,
        ['@reputation'] = json.encode(CACHE[citizenid].reputations),
    })
    Debug('CheckSaveState', 'Saved reputation for ' .. citizenid)
end

function reputation.GetAllRep(citizenid)
    if CACHE[citizenid] then
        return CACHE[citizenid].reputations
    else
        CACHE[citizenid] = {}
        CACHE[citizenid].lastSaved = os.time()
        CACHE[citizenid].reputations = reputation.GetPlayerRep(citizenid)
        return CACHE[citizenid].reputations
    end
end

function reputation.GetRep(citizenid, name)
    if CACHE[citizenid] then
        if CACHE[citizenid].reputations[name] then
            return CACHE[citizenid].reputations[name]
        else
            reputation.SetRep(citizenid, name, 0)
            return CACHE[citizenid].reputations[name]
        end
    else
        local rep = reputation.GetPlayerRep(citizenid)
        if rep then
            CACHE[citizenid] = rep
            if CACHE[citizenid].reputations[name] then
                return CACHE[citizenid].reputations[name]
            else
                reputation.SetRep(citizenid, name, 0)
                return CACHE[citizenid].reputations[name]
            end
        else
            reputation.SetRep(citizenid, name, 0)
            return CACHE[citizenid].reputations[name]
        end
    end
end

function reputation.SetRep(citizenid, name, value)
    Debug('SetRep 1', 'Request set reputation for ' .. citizenid .. ' to ' .. value .. ' for ' .. name)
    if CACHE[citizenid] then
        CACHE[citizenid].reputations[name] = value
        Debug('SetRep 2', 'Check save reputation for ' .. citizenid .. ' to ' .. value .. ' for ' .. name)
        reputation.CheckSaveState(citizenid)
    else
        local rep = reputation.GetPlayerRep(citizenid)
        if rep.reputations then
            CACHE[citizenid] = rep
            CACHE[citizenid].reputations[name] = value
            Debug('SetRep 3', 'Check save  reputation for ' .. citizenid .. ' to ' .. value .. ' for ' .. name)
            reputation.CheckSaveState(citizenid)
        else
            CACHE[citizenid] = {}
            CACHE[citizenid].reputations = {}
            CACHE[citizenid].reputations[name] = value
            CACHE[citizenid].lastSaved = os.time()
            Debug('SetRep 4', 'Force saved reputation for ' .. citizenid .. ' to ' .. value .. ' for ' .. name)
            reputation.SavePlayerRep(citizenid)
        end
    end
end

function reputation.AddRep(citizenid, name, value)
    Debug('AddRep 1', 'Request add of ' .. value .. ' reputation from ' .. citizenid .. ' for ' .. name)
    if CACHE[citizenid] then
        CACHE[citizenid].reputations[name] = CACHE[citizenid].reputations[name] or 0
        local amount = CACHE[citizenid].reputations[name] += value
        Debug('AddRep 2', 'Request add of ' .. value .. ' reputation from ' .. citizenid .. ' for ' .. name)
        reputation.SetRep(citizenid, name, amount)
    else
        local rep = reputation.GetPlayerRep(citizenid)
        CACHE[citizenid] = {}
        CACHE[citizenid].reputations = {}
        if rep then
            CACHE[citizenid].reputations = rep
            CACHE[citizenid].reputations[name] = CACHE[citizenid].reputations[name] or 0
            local amount = CACHE[citizenid].reputations[name] += value
            Debug('AddRep 3', 'Request add of ' .. value .. ' reputation from ' .. citizenid .. ' for ' .. name)
            reputation.SetRep(citizenid, name, amount)
        else
            Debug('AddRep 4', 'Request add of 0 reputation from ' .. citizenid .. ' for ' .. name)
            reputation.SetRep(citizenid, name, 0)
        end
    end
    local src = exports.qbx_core:GetPlayerByCitizenId(citizenid).PlayerData.source
    TriggerClientEvent('groups:reputation:update', src, CACHE[citizenid].reputations)
end

function reputation.AddMultipleRep(citizenid, reputations)
    for name, value in pairs(reputations) do
        reputation.AddRep(citizenid, name, value)
    end
end

function reputation.RemoveRep(citizenid, name, value)
    if CACHE[citizenid] then
        CACHE[citizenid].reputations[name] = CACHE[citizenid].reputations[name] or 0
        local amount = CACHE[citizenid].reputations[name] -= value
        if amount < 0 then amount = 0 end
        Debug('RemoveRep 1', 'Request removal of ' .. value .. ' reputation from ' .. citizenid .. ' for ' .. name)
        reputation.SetRep(citizenid, name, amount)
    else
        local rep = reputation.GetPlayerRep(citizenid)
        CACHE[citizenid] = {}
        CACHE[citizenid].reputations = {}
        if rep then
            CACHE[citizenid].reputations[name] = CACHE[citizenid].reputations[name] or 0
            local amount = CACHE[citizenid].reputations[name] -= value
            if amount < 0 then amount = 0 end
            Debug('RemoveRep 2', 'Request removal of ' .. value .. ' reputation from ' .. citizenid .. ' for ' .. name)
            reputation.SetRep(citizenid, name, amount)
        else
            Debug('RemoveRep 3', 'Setting reputation for ' .. citizenid .. ' to 0 for ' .. name)
            reputation.SetRep(citizenid, name, 0)
        end
    end
end

function reputation.RemoveMultipleRep(citizenid, reputations)
    for name, value in pairs(reputations) do
        reputation.RemoveRep(citizenid, name, value)
    end
end

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    local src = source
    local citizenid = exports.qbx_core:GetPlayer(src).PlayerData.citizenid
    local rep = reputation.GetAllRep(citizenid)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if IDENTIFIERS[src] then
        reputation.SavePlayerRep(IDENTIFIERS[src])
    end
end)

AddEventHandler('onResourceStart', function(name)
    if name ~= GetCurrentResourceName() then return end
end)

AddEventHandler('onResourceStop', function()
    if name ~= GetCurrentResourceName() then return end
    for k,v in pairs(CACHE) do
        reputation.SavePlayerRep(k)
    end
end)

lib.callback.register('groups:GetRep', function(source)
    local citizenid = util.getPlayerCID(source)
    return reputation.GetAllRep(citizenid)
end)

-- EXPORTS

local function GetAllRep(citizenid, name)
    return reputation.GetAllRep(citizenid)
end
exports('GetAllRep', GetAllRep)

local function GetRep(citizenid, name)
    return reputation.GetRep(citizenid, name)
end
exports('GetRep', GetRep)

local function SetRep(citizenid, name, amount)
    reputation.SetRep(citizenid, name, amount)
end
exports('SetRep', SetRep)

local function RemoveRep(citizenid, name, amount)
    reputation.RemoveRep(citizenid, name, amount)
end
exports('RemoveRep', RemoveRep)

local function AddRep(citizenid, name, amount)
    reputation.AddRep(citizenid, name, amount)
end
exports('AddRep', AddRep)

local function AddMultipleRep(citizenid, reputations)
    reputation.AddMultipleRep(citizenid, reputations)
end
exports('AddMultipleRep', AddMultipleRep)

local function RemoveMultipleRep(citizenid, reputations)
    reputation.RemoveMultipleRep(citizenid, reputations)
end
exports('RemoveMultipleRep', RemoveMultipleRep)

return reputation