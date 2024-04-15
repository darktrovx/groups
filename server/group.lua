group = {}

local shared = require 'config.shared'
local util = require 'server.util'
local task = require 'server.task'
local blip = require 'server.blips'

function group.Create(source)
    Debug('[Create]', string.format("Group Create requested. SOURCE:  %s", source))
    local ps = Player(source).state
    if ps.groupID then
        Debug('[Create]', string.format("PlayerID: %s already has a group. GroupID: %s", source, ps.groupID))
        lib.logger(source, 'create', string.format("PlayerID: %s already has a group. GroupID: %s", source, ps.groupID))
        return false
    end

    local id = #GROUPS + 1

    GROUPS[id] = {
        state = "WAITING",
        groupOwner = source,
        task = {},
        members = {},
        requests = {},
    }

    ps.groupOwner = true
    Debug('[Create]', string.format("PlayerID: %s set groupOwner for groupID: %s", source, id))
    lib.logger(source, 'create', string.format("PlayerID: %s set groupOwner for groupID: %s", source, id))

    group.AddPlayer(id, source)

    return true
end

function group.Delete(groupID)
    if not GROUPS[groupID] then
        Debug('[Delete]', "Group does not exist.")
        lib.logger(0, 'delete', "Group does not exist.")
        return false
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        group.RemovePlayer(groupID, members[i].id)
    end

    TriggerClientEvent('groups:GroupDeleteEvent', -1, groupID)
    GROUPS[groupID] = nil
    return true
end

function group.GetGroups()
    local temp = {}
    for groupID,_ in pairs(GROUPS) do
        if GROUPS[groupID].members[1] ~= nil then
            temp[#temp + 1] = {
                id = groupID,
                name = GROUPS[groupID].members[1].name,
                members = #GROUPS[groupID].members,
            }
        end
    end
    return temp
end

function group.AddPlayer(groupID, source)
    local ps = Player(source).state
    if ps.groupID then
        Debug('[AddPlayer]', string.format("PlayerID: %s already has a group. GroupID: %s", source, ps.groupID))
        lib.logger(source, 'add', string.format("PlayerID: %s already has a group. GroupID: %s", source, ps.groupID))
        util.notify(source, "You are already in a group", "error")
        return false
    end

    if not GROUPS[groupID] then
        Debug('[AddPlayer]', string.format("GroupID: %s does not exist", groupID))
        lib.logger(source, 'add', string.format("GroupID: %s does not exist", groupID))
        return false
    end

    if #group.GetMembers(groupID) >= shared.groupMaxSize then
        Debug('[AddPlayer]', string.format("GroupID: %s is full", groupID))
        lib.logger(source, 'add', string.format("GroupID: %s is full", groupID))
        util.notify(source, "Group is full", "error")
        return false
    end

    if GROUPS[groupID].state ~= "WAITING" then
        Debug('[AddPlayer]', string.format("GroupID: %s is already active", groupID))
        lib.logger(source, 'add', string.format("GroupID: %s is already active", groupID))
        util.notify(source, { type = 'error', title = 'Group', description = 'Group is already doing something' })
        return false
    end

    local license = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')
    local name = util.getMemberName(source)
    local memberID = #GROUPS[groupID].members + 1

    ps.groupID = groupID
    Debug('[AddPlayer]', string.format("PlayerID: %s GroupID Set: %s", source, groupID))
    lib.logger(source, 'add', string.format("PlayerID: %s GroupID Set: %s", source, groupID))

    GROUPS[groupID].members[memberID] = {
        name = name,
        id = source,
        license = license,
        citizenid = util.getPlayerCID(source),
        groupOwner = ps.groupOwner,
    }

    TriggerClientEvent("groups:GroupJoinEvent", source)

    group.TriggerEvent(groupID, "groups:GroupMembersUpdate", {
        name = name,
        id = source,
        memberID = memberID,
        groupOwner = ps.groupOwner,
    })

end

function group.RemovePlayer(groupID, playerID)
    Debug('[RemovePlayer]', ('Removed Player : %s from GROUP ID: %s'):format(playerID, groupID))
    lib.logger(playerID, 'remove', ('Removed Player : %s from GROUP ID: %s'):format(playerID, groupID))
    local ps = Player(playerID).state
    if not ps.groupID then
        Debug('[RemovePlayer]', "Player does not have a group.")
        lib.logger(playerID, 'remove', "Player does not have a group.")
        return false
    end

    ps.groupID = nil
    ps.groupOwner = false

    for k,v in pairs(GROUPS[groupID].members) do
        if v.id == playerID then
            table.remove(GROUPS[groupID].members, k)
            break
        end
    end

    TriggerClientEvent("groups:GroupLeaveEvent", playerID)
    group.TriggerEvent(groupID, "groups:GroupMemberLeaveEvent", playerID)
    return true
end

function group.GetMembers(groupID)
    if not GROUPS[groupID] then
        lib.logger(0, 'getmembers', "Group does not exist. GROUPID: "..tostring(groupID))
        Debug('[GetMembers]', "Group does not exist. GROUPID: "..tostring(groupID))
        return
    end
    return GROUPS[groupID].members or {}
end exports('GetMembers', group.GetMembers)

function group.MemberCount(groupID)
    if not GROUPS[groupID] then
        lib.logger(0, 'membercount', "Group does not exist. GROUPID: "..tostring(groupID))
        Debug('[MemberCount]', "Group does not exist. GROUPID: "..tostring(groupID))
        return
    end
    return #GROUPS[groupID].members
end exports('MemberCount', group.MemberCount)

function group.CreateRequest(groupID, source)
    if not GROUPS[groupID] then
        lib.logger(source, 'request', "Group does not exist.")
        Debug('[CreateRequest]', "Group does not exist.")
        return false
    end

    local ps = Player(source).state
    lib.logger(source, 'request', string.format("PlayerID: %s, groupID: %s", source, groupID))
    Debug('[CreateRequest]', string.format("playerID: %s, groupID: %s", source, groupID))
    if ps.groupID then
        Debug('[CreateRequest]', "Player already has a group.")
        return false
    end

    for i = 1, #GROUPS[groupID].requests do
        if GROUPS[groupID].requests[i].id == source then
            lib.logger(source, 'request', "Player already has a request.")
            Debug('[CreateRequest]', "Player already has a request.")
            return false
        end
    end

    GROUPS[groupID].requests[#GROUPS[groupID].requests + 1] = { name = util.getMemberName(source), id = source}
    return true
end

function group.DeleteRequest(groupID, requestID)
    if not GROUPS[groupID] then
        lib.logger(0, 'deleterequest', "Group does not exist.")
        Debug('[DeleteRequest]', "Group does not exist.")
        return false
    end

    if not GROUPS[groupID].requests[requestID] then
        lib.logger(0, 'deleterequest', "Request does not exist.")
        Debug('[DeleteRequest]', "Request does not exist.")
        return false
    end

    GROUPS[groupID].requests[requestID] = nil
    return true
end

function group.AcceptRequest(groupID, source, requestID)

    Debug('[AcceptRequest]', string.format("groupID: %s, requestID: %s", groupID, requestID))
    lib.logger(source, 'accept', string.format("groupID: %s, requestID: %s", groupID, requestID))

    if not GROUPS[groupID] then
        Debug('[AcceptRequest]', "Group does not exist.")
        lib.logger(source, 'accept', "Group does not exist.")
        return false
    end

    if not GROUPS[groupID].requests[requestID] then
        lib.logger(source, 'accept', "Request does not exist.")
        Debug('[AcceptRequest]', "Request does not exist.")
        return false
    end

    local ps = Player(source).state
    if not ps.groupOwner then
        lib.logger(source, 'accept', "Player is not groupOwner of group")
        Debug('[AcceptRequest]', "Player is not groupOwner of group")
        return false
    end

    if GROUPS[groupID].requests[requestID] then
        local requestSrc = GROUPS[groupID].requests[requestID].id
        local rs = Player(requestSrc).state
        if rs.groupID then
            Debug('[AcceptRequest]', "Requester already has a group.")
            lib.logger(source, 'accept', "Requester already has a group.")
            return false
        end

        group.AddPlayer(groupID, requestSrc)
        TriggerClientEvent("groups:requestUpdate", requestSrc, groupID, true)
        return group.DeleteRequest(groupID, requestID)
    end

    return false
end

function group.GetRequests(groupID)
    if not GROUPS[groupID] then
        Debug('[GetRequests]', "Group does not exist.")
        lib.logger(0, 'getrequests', "Group does not exist.")
        return
    end
    return GROUPS[groupID].requests or {}
end

function group.SetState(groupID, state)
    if not GROUPS[groupID] then
        Debug('[SetState]', "Group does not exist.")
        lib.logger(0, 'setstate', "Group does not exist.")
        return
    end

    GROUPS[groupID].state = state
    group.TriggerEvent(groupID, "groups:GroupStateChangeEvent", { state = state })
end exports('SetState', group.SetState)

function group.GetState(groupID)
    if not GROUPS[groupID] then
        Debug('[GetState]', "Group does not exist.")
        lib.logger(0, 'getstate', "Group does not exist.")
        return false
    end

    return GROUPS[groupID].state
end exports('GetState', group.GetState)

function group.StartTask(groupID, name, steps)
    if not GROUPS[groupID] then
        Debug('[StartTask]', "Group does not exist.")
        lib.logger(0, 'starttask', "Group does not exist.")
        return
    end

    return task.Create(groupID, name, steps)
end exports('StartTask', group.StartTask)

function group.SetTaskStep(groupID, step)
    if not GROUPS[groupID] then
        Debug('[SetTaskStep]', "Group does not exist.")
        lib.logger(0, 'settaskstep', "Group does not exist.")
        return
    end
    task.SetStep(groupID, step)
end exports('SetTaskStep', group.SetTaskStep)

function group.SetTask(groupID, task)
    if not GROUPS[groupID] then
        Debug('[SetTask]', "Group does not exist.")
        lib.logger(0, 'settask', "Group does not exist.")
        return
    end

    GROUPS[groupID].task = task
    TriggerClientEvent("groups:GroupTaskChangeEvent", -1, groupID, task)
end exports('SetTask', group.SetTask)

function group.GetTask(groupID)
    if not GROUPS[groupID] then
        Debug('[GetTask]', "Group does not exist.")
        lib.logger(0, 'gettask', "Group does not exist.")
        return false
    end

    return GROUPS[groupID].task
end exports('GetTask', group.GetTask)

function group.ResetTask(groupID)
    if not GROUPS[groupID] then
        Debug('[ResetTask]', "Group does not exist.")
        lib.logger(0, 'resettask', "Group does not exist.")
        return false
    end
    task.Delete(groupID)
end exports('ResetTask', group.ResetTask)

function group.GetCurrentStep(groupID)
    if not GROUPS[groupID] then
        Debug('[GetCurrentStep]', "Group does not exist.")
        lib.logger(0, 'getcurrentstep', "Group does not exist.")
        return false
    end
    return task.GetStep(groupID)
end exports('GetCurrentStep', group.GetCurrentStep)

function group.SetOwner(groupID, source)
    if not GROUPS[groupID] then
        Debug('[SetOwner]', "Group does not exist.")
        lib.logger(0, 'setowner', "Group does not exist.")
        return
    end
    GROUPS[groupID].groupOwner = source
    util.notify(source, "You are now the groupOwner of the group", "success")
end

function group.GetOwner(groupID)
    if not GROUPS[groupID] then
        Debug('[GetOwner]', "Group does not exist.")
        return
    end
    return GROUPS[groupID].groupOwner
end exports('GetOwner', group.GetOwner)

function group.IsOwner(source)
    return Player(source).state.groupOwner
end exports('IsOwner', group.IsOwner)

function group.HandleOwnerLeave(groupID)
    if not GROUPS[groupID] then
        Debug('[HandleOwnerLeave]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 2, #members do
        group.SetOwner(groupID, members[i].id)
        return true
    end

    return false
end

function group.GetGroup(source)
    local license = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')

    for groupID,_ in pairs(GROUPS) do
        local members = group.GetMembers(groupID)
        for i = 1, #members do
            if members[i].license == license then
                return groupID
            end
        end        
    end

    return false
end exports('GetGroup', group.GetGroup)

function group.GetGroupID(source)
    return Player(source).state.groupID
end exports('GetGroupID', group.GetGroupID)

function group.RewardMember(source, data)
    if data.type == "money" then
        util.addMoney(source, data.account, data.count)
        lib.logger(source, 'reward', string.format("was rewarded $%s", data.count))
        if data.notify then
            util.notify(source, "You have been rewarded $"..data.count, "success")
        end
    elseif data.type == "item" then
        util.addItem(source, { item = data.item, count = data.count, metadata = data.metadata, slot = data.slot })
        lib.logger(source, 'reward', string.format("was rewarded %s %s", data.count, data.item))
        if data.notify then
            util.notify(source, "You have been rewarded "..data.count.." "..data.item, "success")
        end
    end
end exports('RewardMember', group.RewardMember)

function group.RewardMembers(groupID, rewardData, divide)
    if not GROUPS[groupID] then
        Debug('[RewardMembers]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)

    if divide then
        rewardData.count = math.floor((rewardData.count / #members) + 0.5)
    end

    for i = 1, #members do
        group.RewardMember(members[i].id, rewardData)
    end
end exports('RewardMembers', group.RewardMembers)

function group.TriggerEvent(groupID, event, data)
    if not GROUPS[groupID] then return Debug('[TriggerEvent]', "Group does not exist.") end
    if event == nil then return Debug('[TriggerEvent]', "no valid event was passed to GroupEvent") end

    local members = group.GetMembers(groupID)
    for i=1, #members do
        TriggerClientEvent(event, members[i].id, data)
        lib.logger(members[i].id, 'event', string.format("GroupID: %s, Event: %s, Data: %s", groupID, event, json.encode(data)))
        Debug('[TriggerEvent]', string.format("GroupID: %s, Client: %s, Event: %s, Data: %s", groupID, members[i].id, event, json.encode(data)))
    end
end exports('TriggerEvent', group.TriggerEvent)

function group.Notify(groupID, notifData)
    if not GROUPS[groupID] then return Debug('[Notify]', "Group does not exist.") end

    local members = group.GetMembers(groupID)
    for i=1,#members do
        util.notify(members[i].id, notifData)
    end
end exports('Notify', group.Notify)

function group.Abandon(groupID, source)
    if not GROUPS[groupID] then
        Debug('[Abandon]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        group.RemovePlayer(groupID, members[i].id)
    end

    GROUPS[groupID] = nil
end exports('Abandon', group.Abandon)

function group.GetAverageReputation(groupID, name)
    if not GROUPS[groupID] then
        Debug('[GetAverageReputation]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    local total = 0
    for i = 1, #members do
        --local rep = reputation.GetPlayerRep(members[i].id)
        local rep = exports.reputation:GetPlayerRep(members[i].id)
        if rep then
            total = total + rep
        end
    end

    return total / #members
end exports('GetAverageReputation', group.GetAverageReputation)

-- Adds rep to ALL members of the group
-- divide: if true, value will be divided by the number of members
function group.GroupAddRep(groupID, name, value, divide, limit)
    if not GROUPS[groupID] then
        Debug('[GroupAddRep]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)

    if divide then
        value = value / #members
    end

    for i = 1, #members do
        exports.reputation:AddRep(members[i].citizenid, name, value, limit)
    end
end exports('GroupAddRep', group.GroupAddRep)

-- Removes rep from ALL members of the group
-- divide: if true, value will be divided by the number of members
function group.GroupRemoveRep(groupID, name, value, divide)
    if not GROUPS[groupID] then
        Debug('[GroupRemoveRep]', "Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)

    if divide then
        value = value / #members
    end

    for i = 1, #members do
        exports.reputation:RemoveRep(members[i].citizenid, name, value)
    end
end exports('GroupRemoveRep', group.GroupRemoveRep)

function group.CreateBlip(groupID, name, data)
    blip.Create(groupID, name, data)
end exports('CreateBlip', group.CreateBlip)

function group.DeleteBlip(groupID, name)
    blip.Delete(groupID, name)
end exports('DeleteBlip', group.DeleteBlip)

-- Callbacks
lib.callback.register('groups:CreateGroup', function(source)
    return group.Create(source)
end)

lib.callback.register('groups:LeaveGroup', function(source)
    local ps = Player(source).state

    if ps.groupOwner then
        return group.Delete(ps.groupID)
    end

    return group.RemovePlayer(ps.groupID, source)
end)

lib.callback.register('groups:RequestJoin', function(source, groupID)
    return group.CreateRequest(groupID, source)
end)

lib.callback.register('groups:RequestGroups', function(source)
    return group.GetGroups()
end)

lib.callback.register('groups:GetRequests', function(source)
    local ps = Player(source).state
    return group.GetRequests(ps.groupID)
end)

lib.callback.register('groups:GetMembers', function(source)
    local ps = Player(source).state
    return group.GetMembers(ps.groupID)
end)

-- Events

RegisterNetEvent('groups:AcceptRequest', function(requestID)
    local src = source
    local ps = Player(src).state
    group.AcceptRequest(ps.groupID, src, requestID)
end)

RegisterNetEvent('groups:DenyRequest', function(requestID)
    local src = source
    local ps = Player(src).state

    local requestSrc = GROUPS[ps.groupID].requests[requestID].id
    TriggerClientEvent("groups:requestUpdate", requestSrc, ps.groupID, false)

    group.DeleteRequest(ps.groupID, src, requestID)
end)

RegisterNetEvent('groups:Kick', function(playerID)
    local src = source
    local ps = Player(src).state
    group.RemovePlayer(ps.groupID, playerID)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local ps = Player(src).state

    if ps.groupID then
        if ps.groupOwner then
            -- local success = group.HandleOwnerLeave(ps.groupID)
            -- if not success then
            --     group.Delete(ps.groupID)
            -- end
            group.Delete(ps.groupID)
        end
        group.RemovePlayer(ps.groupID, src)
    end
end)

return group