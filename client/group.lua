
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
    SendNUIMessage({
        type = "updateGroups",
        groups = groups
    })
end)

RegisterNetEvent("groups:BlipCreate", function(name, data)
    blips.Create(name, data)
end)

RegisterNetEvent("groups:BlipDelete", function(name)
    blip.Delete(name)
end)

-- NUI CALLBACKS
RegisterNUICallback("CreateGroup", function(data, cb)
    local success = lib.callback.await('groups:CreateGroup', false)
    Wait(50)
    cb(success)
end)

RegisterNUICallback("LeaveGroup", function(data, cb)
    local success = lib.callback.await('groups:LeaveGroup', false)
    cb(success)
end)

RegisterNUICallback("JoinGroup", function(data, cb)
    local success = lib.callback.await('groups:JoinGroup', false)
    if success then
        Notify("You have requested to join the group", "success")
    end
end)

RegisterNUICallback("GetRequests", function(data, cb)
    local success = lib.callback.await('groups:GetRequests', false)
    cb(success)
end)

RegisterNUICallback("Accept", function(data, cb)
    TriggerServerEvent("groups:AcceptRequest", data.requestID)
    cb('ok')
end)

RegisterNUICallback("Deny", function(data, cb)
    TriggerServerEvent("groups:DenyRequest", data.requestID)
    cb('ok')
end)

RegisterNUICallback("GetMembers", function(data, cb)
    local success = lib.callback.await('groups:GetMembers', false)
    cb(success)
end)

RegisterNUICallback("Kick", function(data, cb)
    TriggerServerEvent("groups:KickMember", data.id)
    cb('ok')
end)