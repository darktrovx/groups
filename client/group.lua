local GROUP_MEMBERS = {}

local shared = require 'config.shared'
local util = require 'client.util'
local blips = require 'client.blips'
local task = require 'client.task'

local function CreateGroup()
    local success = lib.callback.await('groups:CreateGroup', false)
    return success
end
exports('CreateGroup', CreateGroup)

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

local function RequestJoin(groupID)
    local success = lib.callback.await('groups:RequestJoin', false, groupID)
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
    if #GROUP_MEMBERS ~= 0 then return GROUP_MEMBERS end
    local success = lib.callback.await('groups:GetMembers', false)
    return success
end
exports('GetMembers', GetMembers)

local function Kick(id)
    TriggerServerEvent("groups:KickMember", id)
end
exports('Kick', Kick)

local function GetGroupID()
    return LocalPlayer.state.groupID
end
exports('GetGroupID', GetGroupID)

local function GetTaskData()
    return task.GetTaskData()
end
exports('GetTaskData', GetTaskData)

local function IsOwner()
    return LocalPlayer.state.groupOwner
end
exports('IsOwner', IsOwner)

-- EVENTS

RegisterNetEvent("groups:GroupJoinEvent", function()
    if shared.standaloneUI then
        SendNUIMessage({
            type = "groupJoined"
        })
    end
end)

RegisterNetEvent("groups:GroupMembersUpdate", function(members)
    GROUP_MEMBERS = members
    if shared.standaloneUI then
        SendNUIMessage({
            type = "groupJoined",
            members = members
        })
    end
end)

RegisterNetEvent("groups:GroupMemberLeaveEvent", function(id)
    GROUP_MEMBERS[id] = nil
end)

RegisterNetEvent("groups:GroupLeaveEvent", function()
    task.Cleanup()
    blips.ClearAll()
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
    blips.Delete(name)
end)

-- NUI CALLBACKS
RegisterNUICallback("CreateGroup", function(data, cb)
    cb(CreateGroup())
end)

RegisterNUICallback("LeaveGroup", function(data, cb)
    cb(LeaveGroup())
end)

RegisterNUICallback("JoinGroup", function(data, cb)
    local success = RequestJoin()
    if success then
        util.notify("You have requested to join the group", "success")
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

RegisterNUICallback("RequestMembers", function(data, cb)
    cb(GetMembers())
end)

RegisterNUICallback("Kick", function(data, cb)
    Kick(data.id)
    cb('ok')
end)