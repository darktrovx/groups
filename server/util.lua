local util = {}

function util.notify(source, notifData)
    notifData.type = notifData.type or 'info'
    notifData.title = notifData.title or 'Groups'
    notifData.description = notifData.description or 'No description'
    TriggerClientEvent('ox_lib:notify', source, notifData)
end

function util.getPlayerCID(source)
    return exports.qbx_core:GetPlayer(source).PlayerData.citizenid
end

function util.getMemberName(source)
    local Player = exports.qbx_core:GetPlayer(source)
    local name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
    return name
end

function util.addMoney(source, account, amount)
    local Player = exports.qbx_core:GetPlayer(source)
    return Player.Functions.AddMoney(account, amount)
end

function util.removeMoney(source, account, amount)
    local Player = exports.qbx_core:GetPlayer(source)
    return Player.Functions.AddMoney(account, amount)
end

---@param source number
---@param data table : { item: string, count: number, metadata: table, slot: number }
function util.addItem(source, data)
    local success, resp = exports.ox_inventory:AddItem(source, data.item, data.count, data.metadata or false, data.slot or false)
    return success, resp
end

---@param source number
---@param data table : { item: string, count: number, metadata: table, slot: number }
function util.removeItem(source, data)
    local success, resp = exports.ox_inventory:RemoveItem(source, data)
    return success, resp
end

function util.hasItem(source, item, metadata, strict)
    return exports.ox_inventory:GetItemCount(item, metadata, strict)
end

return util