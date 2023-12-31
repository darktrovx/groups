
local function RequestCreateGroup()
    local success = lib.callback.await('groups:CreateGroup', false)
    return success
end
exports('RequestCreateGroup', RequestCreateGroup)

local function RequestGroupsList()
    local groups = lib.callback.await('groups:RequestGroups', false)
    return groups
end
exports('RequestGroupsList', RequestGroupsList)

local function LeaveGroup()
    local success = lib.callback.await('groups:LeaveGroup', false)
    return success
end
exports('LeaveGroup', LeaveGroup)

local function RequestJoin()
    local success = lib.callback.await('groups:JoinGroup', false)
    return success
end
exports('RequestJoin', RequestJoin)

local function GetRequests()
    local success = lib.callback.await('groups:GetRequests', false)
    return success
end
exports('GetRequests', GetRequests)

local function AcceptRequest(requestID)
    TriggerServerEvent("groups:AcceptRequest", requestID)
end
exports('AcceptRequest', AcceptRequest)

local function DenyRequest(requestID)
    TriggerServerEvent("groups:DenyRequest", requestID)
end
exports('DenyRequest', DenyRequest)

local function GetMembers()
    local success = lib.callback.await('groups:GetMembers', false)
    return success
end
exports('GetMembers', GetMembers)

local function Kick(id)
    TriggerServerEvent("groups:KickMember", id)
end
exports('Kick', Kick)

-- EVENTS
RegisterNetEvent("groups:GroupJoinEvent", function()

end)

RegisterNetEvent("groups:GroupLeaveEvent", function()
    task.Cleanup()
    blip.ClearAll()
end)

RegisterNetEvent("groups:GroupCreateEvent", function()

end)

RegisterNetEvent("groups:GroupDeleteEvent", function()

end)

RegisterNetEvent("groups:GroupStateChangeEvent", function()

end)

RegisterNetEvent("groups:GroupUpdateGroups", function(groups)
    if Config.UI then
        SendNUIMessage({
            type = "updateGroups",
            groups = groups
        })
    end
end)

RegisterNetEvent("groups:BlipCreate", function(name, data)
    blips.Create(name, data)
end)

RegisterNetEvent("groups:BlipDelete", function(name)
    blip.Delete(name)
end)

-- NUI CALLBACKS
RegisterNUICallback("CreateGroup", function(data, cb)
    cb(RequestCreateGroup())
end)

RegisterNUICallback("LeaveGroup", function(data, cb)
    cb(LeaveGroup())
end)

RegisterNUICallback("JoinGroup", function(data, cb)
    local success = RequestJoin()
    if success then
        Notify("You have requested to join the group", "success")
    end
end)

RegisterNUICallback("GetRequests", function(data, cb)
    cb(GetRequests())
end)

RegisterNUICallback("Accept", function(data, cb)
    AcceptRequest(data.requestID)
    cb('ok')
end)

RegisterNUICallback("Deny", function(data, cb)
    DenyRequest(data.requestID)
    cb('ok')
end)

RegisterNUICallback("GetMembers", function(data, cb)
    cb(GetMembers())
end)

RegisterNUICallback("Kick", function(data, cb)
    Kick(data.id)
    cb('ok')
end)