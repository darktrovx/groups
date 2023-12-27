group = {}

function group.Create(source)
    local ps = group.GetPlayer(source)
    if ps.groupID then
        Debug("[Create] Player already has a group.")
        return false
    end

    local id = #GROUPS + 1

    GROUPS[id] = {
        state = "WAITING",
        owner = source,
        task = {},
        members = {},
        requests = {},
    }

    ps.groupOwner = true
    Debug("[Create] Player set to owner for groupID: "..id)

    group.AddPlayer(id, source)

    return true
end

function group.Delete(groupID)
    if not GROUPS[groupID] then
        Debug("[Delete] Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        group.RemovePlayer(groupID, members[i])
    end

    GROUPS[groupID] = nil
end

function group.AddPlayer(groupID, source)
    local ps = group.GetPlayer(source)
    if ps.groupID then
        Debug("[AddPlayer] Player already has a group.")
        Notify(source, "You are already in a group", "error")
        return false
    end

    if not GROUPS[groupID] then
        Debug("[AddPlayer] Group does not exist.")
        return false
    end

    if #group.GetMembers(groupID) >= Config.GroupLimit then
        Debug("[AddPlayer] Group is full.")
        Notify(source, "Group is full", "error")
        return
    end

    local license = GetPlayerIdentifierByType(source, 'license2') or GetPlayerIdentifierByType(source, 'license')

    ps.groupID = groupID
    GROUPS[groupID].members[#GROUPS[groupID].members + 1] = {
        name = GetMemberName(source),
        id = source,
        license = license,
        owner = ps.groupOwner,
    }
    TriggerClientEvent("groups:GroupJoinEvent", source, groupID)
end

function group.RemovePlayer(groupID, playerID)
    Debug('REMOVE PLAYER: '..groupID..' '..source)
    local ps = group.GetPlayer(playerID)
    if not ps.groupID then
        Debug("[RemovePlayer] Player does not have a group.")
        return false
    end

    ps.groupID = nil
    ps.groupOwner = false

    TriggerClientEvent("groups:GroupLeaveEvent", playerID)
    return true
end

function group.GetPlayer(source)
    return Player(source).state
end

function group.GetMembers(groupID)
    if not GROUPS[groupID] then
        Debug("[GetMembers] Group does not exist.")
        return
    end
    return GROUPS[groupID].members or {}
end

function group.CreateRequest(groupID, source)
    if not GROUPS[groupID] then
        Debug("[CreateRequest] Group does not exist.")
        return false
    end

    local ps = group.GetPlayer(source)
    if ps.groupID then
        Debug("[CreateRequest] Player already has a group.")
        return false
    end

    GROUPS[groupID].requests[#GROUPS[groupID].requests + 1] = { name = GetMemberName(source), id = source}
    return true
end

function group.DeleteRequest(groupID, source, requestID)
    if not GROUPS[groupID] then
        Debug("[DeleteRequest] Group does not exist.")
        return
    end

    if not GROUPS[groupID].requests[requestID] then
        Debug("[DeleteRequest] Request does not exist.")
        return
    end

    GROUPS[groupID].requests[requestID] = nil
end

function group.GetRequests(groupID)
    if not GROUPS[groupID] then
        Debug("[GetRequests] Group does not exist.")
        return
    end
    return GROUPS[groupID].requests or {}
end

function group.AcceptRequest(groupID, source, requestID)
    if not GROUPS[groupID] then
        Debug("[AcceptRequest] Group does not exist.")
        return false
    end

    if not GROUPS[groupID].requests[requestID] then
        Debug("[AcceptRequest] Request does not exist.")
        return false
    end

    local ps = group.GetPlayer(source)
    if not ps.owner then
        Debug("[AcceptRequest] Player is not owner of group")
        return false
    end

    if GROUPS[groupID].requests[requestID] then
        local rs = group.GetPlayer(GROUPS[groupID].requests[requestID].id)
        if rs.groupID then
            Debug("[AcceptRequest] Requester already has a group.")
            return false
        end
        group.AddPlayer(groupID, request.id)
        group.DeleteRequest(groupID, source, requestID)
        return true
    end

    return false
end

function group.SetState(groupID, state)
    if not group.Exists(groupID) then
        Debug("[SetState] Group does not exist.")
        return
    end

    GROUPS[groupID].state = state
    TriggerClientEvent("groups:GroupStateChangeEvent", -1, groupID, state)
end

function group.GetState(groupID)
    if not group.Exists(groupID) then
        Debug("[GetState] Group does not exist.")
        return
    end

    return GROUPS[groupID].state
end

function group.StartTask(groupID, name, steps)
    if not group.Exists(groupID) then
        Debug("[StartTask] Group does not exist.")
        return
    end

    return task.Create(groupID, name, steps)
end

function group.SetTask(groupID, task)
    if not group.Exists(groupID) then
        Debug("[SetTask] Group does not exist.")
        return
    end

    GROUPS[groupID].task = task
    TriggerClientEvent("groups:GroupTaskChangeEvent", -1, groupID, task)
end

function group.GetTask(groupID)
    if not group.Exists(groupID) then
        Debug("[GetTask] Group does not exist.")
        return
    end

    return GROUPS[groupID].task
end

function group.SetOwner(groupID, source)
    if not GROUPS[groupID] then
        Debug("[SetOwner] Group does not exist.")
        return
    end
    GROUPS[groupID].owner = source
    Notify(source, "You are now the owner of the group", "success")
end

function group.GetOwner(groupID)
    if not GROUPS[groupID] then
        Debug("[GetOwner] Group does not exist.")
        return
    end
    return GROUPS[groupID].owner
end

function group.HandleOwnerLeave(groupID)
    if not GROUPS[groupID] then
        Debug("[HandleOwnerLeave] Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        local source = GetPlayerFromIdentifier(members[i])
        if source then
            group.SetOwner(groupID, source)
            break
        end
    end
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
end

function group.GetGroupID(source)
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
end

function group.RewardMember(source, rewardData)
    if rewardData.type == "money" then
        AddMoney(source, rewardData.account, rewardData.amount)
        Notify(source, "You have been rewarded $"..rewardData.amount, "success")
    elseif rewardData.type == "item" then
        AddItem(source, rewardData.item, rewardData.amount)
        Notify(source, "You have been rewarded "..rewardData.amount.." "..rewardData.item, "success")
    end
end

function group.RewardMembers(groupID, rewardData)
    if not GROUPS[groupID] then
        Debug("[RewardMembers] Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        local source = GetPlayerFromIdentifier(members[i])
        if source then
            group.RewardMember(groupID, source)
        end
    end
end

function group.TriggerEvent(groupID, event, data)
    if not GROUPS[groupID] then return Debug("[TriggerEvent] Group does not exist.") end
    if event == nil then return Debug("no valid event was passed to GroupEvent") end

    local members = group.GetMembers(groupID)
    for i=1,#members do
        if data ~= nil then
            TriggerClientEvent(event, members[i].id, data)
        else 
            TriggerClientEvent(event, members[i].id)
        end
    end
end

function group.Abandon(groupID, source)
    if not GROUPS[groupID] then
        Debug("[Abandon] Group does not exist.")
        return
    end

    local members = group.GetMembers(groupID)
    for i = 1, #members do
        local source = GetPlayerFromIdentifier(members[i])
        if source then
            group.RemovePlayer(groupID, source)
        end
    end

    GROUPS[groupID] = nil
end

-- Callbacks
lib.callback.register('groups:CreateGroup', function(source)
    return group.Create(source)
end)

lib.callback.register('groups:LeaveGroup', function(source)
    local ps = group.GetPlayer(source)
    return group.RemovePlayer(ps.groupID, source)
end)

lib.callback.register('groups:GetRequests', function(source)
    local ps = group.GetPlayer(source)
    return group.GetRequests(ps.groupID)
end)

lib.callback.register('groups:GetMembers', function(source)
    local ps = group.GetPlayer(source)
    print('GetMembersCall '..tostring(ps.groupID))
    return group.GetMembers(ps.groupID)
end)

-- Events

RegisterNetEvent('groups:AcceptRequest', function(requestID)
    local src = source
    local ps = group.GetPlayer(src)
    group.AcceptRequest(ps.groupID, src, requestID)
end)

RegisterNetEvent('groups:DenyRequest', function(requestID)
    local src = source
    local ps = group.GetPlayer(src)
    group.DeleteRequest(ps.groupID, src, requestID)
end)

RegisterNetEvent('groups:Kick', function(playerID)
    local src = source
    local ps = group.GetPlayer(src)
    group.RemovePlayer(ps.groupID, playerID)
end)

return group