local reputation = {}
local Players = {}

function reputation.CheckSaveState(source)
    if Players[source].lastSaved then
        if Players[source].lastSaved + Config.SaveInterval < os.time() then
            reputation.SavePlayerRep(source)
        end
    else
        Players[source].lastSaved = os.time()
    end
end

function reputation.GetPlayerRep(source)
    local citizenid = GetPlayerUniqueID(source)
    local data = MySQL.query.await("SELECT reputation FROM laptop_rep WHERE citizenid = ?", { citizenid })
    return json.decode(data[1].reputation)
end

function reputation.SavePlayerRep(source, data)
    local citizenid = GetPlayerUniqueID(source)
    MySQL.Async.execute("UPDATE laptop_rep SET reputation = @reputation WHERE citizenid = @citizenid", {
        ['@reputation'] = json.encode(data),
        ['@citizenid'] = citizenid
    })
end

function reputation.GetRep(source, reputation)
    if Players[source] then
        if Players[source].reputations[reputation] then
            return Players[source].reputations[reputation]
        else
            reputation.SetRep(source, reputation, 0)
            return Players[source].reputations[reputation]
        end
    else
        local rep = reputation.GetPlayerRep(source)
        if rep then
            Players[source] = rep
            if Players[source].reputations[reputation] then
                return Players[source].reputations[reputation]
            else
                reputation.SetRep(source, reputation, 0)
                return Players[source].reputations[reputation]
            end
        else
            reputation.SetRep(source, reputation, 0)
            return Players[source].reputations[reputation]
        end
    end
end

function reputation.SetRep(source, reputation, value)
    if Players[source] then
        Players[source].reputations[reputation] = value
        reputation.SetPlayerRep(source, Players[source])
    else
        local rep = reputation.GetPlayerRep(source)
        if rep then
            Players[source] = rep
            Players[source].reputations[reputation] = value
            reputation.SetPlayerRep(source, Players[source])
        else
            Players[source] = {}
            Players[source].reputations[reputation] = value
            reputation.SetPlayerRep(source, Players[source])
        end
    end
end

function reputation.AddRep(source, reputation, value)
    if Players[source] then
        local amount = Players[source][reputation] += value
        reputation.SetRep(source, reputation, amount)
    else
        local rep = reputation.GetPlayerRep(source)
        if rep then
            Players[source] = rep
            local amount = Players[source][reputation] += value
            reputation.SetRep(source, reputation, amount)
        else
            reputation.SetRep(source, reputation, 0)
        end
    end
end

function reputation.RemoveRep(source, reputation, value)
    if Players[source] then
        local amount = Players[source].reputations[reputation] -= value
        reputation.SetRep(source, reputation, amount)
    else
        local rep = reputation.GetPlayerRep(source)
        if rep then
            Players[source] = rep
            local amount = Players[source].reputations[reputation] -= value
            reputation.SetRep(source, reputation, amount)
        else
            reputation.SetRep(source, reputation, 0)
        end
    end
end

function reputation.UpdatePlayerState(source, reputation, value)
    Player(source).state[reputation] = value
end

AddEventHandler('playerDropped', function()
    local src = source
    reputation.SavePlayerRep(src, Players[src])
end)

AddEventHandler('onResourceStart', function(name)
    if name ~= GetCurrentResourceName() then return end
end)

AddEventHandler('onResourceStop', function()
    if name ~= GetCurrentResourceName() then return end
    for k,v in pairs(Players) do
        reputation.SavePlayerRep(k, v)
    end
end)

return reputation