GROUPS = {}
TASKS = {}
IDENTIFIERS = {}

local shared = require 'config.shared'
local util = require 'server.util'

function Debug(area, text)
    if not shared.debug then return end
    area = area or 'groups'
    print(string.format('%s: %s', area, text))
end

AddEventHandler("onResourceStart", function(name)
    if name ~= GetCurrentResourceName() then return end
    local players = GetPlayers()

    for _, player in pairs(players) do
        Debug('ResourceStart', string.format("Setting groupID to false for %s", player))
        Player(player).state.groupID = false
        local citizenid = util.getPlayerCID(tonumber(player))
        IDENTIFIERS[player] = citizenid
    end
end)

AddEventHandler("onResourceStop", function(name)
    if name ~= GetCurrentResourceName() then return end
    for groupID,v in pairs(GROUPS) do
        Debug('ResourceStop', "groupID: "..groupID)
        group.Delete(groupID)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    local ps = Player(src).state
    if ps.groupID then
        group.RemovePlayer(ps.groupID, src)
    end
end)

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    local src = source
    local citizenid = exports.qbx_core:GetPlayer(src).PlayerData.citizenid
    IDENTIFIERS[src] = citizenid
    Player(src).state.groupID = false
end)