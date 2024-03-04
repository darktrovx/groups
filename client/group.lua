local GROUP_MEMBERS = {}
local GROUP_STATE = 'WAITING'

local pendingRequests = {}

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
    if not groupID then return false end

    if pendingRequests[groupID] then
        util.notify({title = "Groups", description = "You have already requested to join this group", type = "error"})
        return false
    end

    pendingRequests[groupID] = true
    util.notify({title = "Groups", description = "Join request sent", type = "success"})

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
    return true
end
exports('AcceptRequest', AcceptRequest)

local function DenyRequest(requestID)
    TriggerServerEvent("groups:DenyRequest", requestID)
    return true
end
exports('DenyRequest', DenyRequest)

local function GetMembers()
    local members = lib.callback.await('groups:GetMembers', false)
    return members
end
exports('GetMembers', GetMembers)

local function Kick(id)
    TriggerServerEvent("groups:Kick", id)
    return true
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

local function GetCurrentStep()
    return task.GetCurrentStep()
end
exports('GetCurrentStep', GetCurrentStep)

local function IsOwner()
    return LocalPlayer.state.groupOwner
end
exports('IsOwner', IsOwner)

-- EVENTS

RegisterNetEvent("groups:GroupJoinEvent", function()
    if shared.standaloneUI then
        SendNUIMessage({  type = "groupJoined"  })
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
    GROUP_MEMBERS = nil
    GROUP_STATE = 'WAITING'
    task.Cleanup()
    blips.ClearAll()
end)

RegisterNetEvent("groups:GroupCreateEvent", function()

end)

RegisterNetEvent("groups:GroupDeleteEvent", function(groupID)
    if LocalPlayer.state.groupID == groupID then
        LocalPlayer.state.groupID = nil
    end

    if shared.standaloneUI then
        SendNUIMessage({
            type = "groupDeleted",
            groupID = groupID
        })
    end
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

RegisterNetEvent('groups:requestUpdate', function(groupID, success)
    if success then
        util.notify({title = "Groups", description = "Your request to join the group was accepted", type = "success"})
    else
        util.notify({title = "Groups", description = "Your request to join the group was denied", type = "error"})
    end
    pendingRequests[groupID] = nil
end)

RegisterNetEvent("groups:BlipCreate", function(name, data)
    blips.Create(name, data)
end)

RegisterNetEvent("groups:BlipDelete", function(name)
    blips.DeleteByName(name)
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