GROUPS = {}
TASKS = {}

function Debug(text)
    if Config.Debug then
        print('DEBUG: '..text)
    end
end

AddEventHandler("onResourceStart", function(name)
    if name ~= GetCurrentResourceName() then return end
    local Players = GetPlayers()

    for i = 1, #Players do
        Debug("Setting groupID to false for "..Players[i])
        Player(Players[i]).state.groupID = false
    end
end)

AddEventHandler("onResourceStop", function(name)
    if name ~= GetCurrentResourceName() then return end
    for groupID,v in pairs(GROUPS) do
        Debug("groupID: "..groupID)
        group.Delete(groupID)
    end
end)

AddEventHandler("playerJoining", function()
    local src = source
    -- local groupID = group.GetGroup(source)
    -- if groupID then
    --     group.AddPlayer(groupID, source)
    -- end
    Player(src).state.groupID = false
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    local ps = Player(src).state
    if ps.groupID then
        group.RemovePlayer(ps.groupID, src)
    end
end)