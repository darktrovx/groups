local util = {}

function util.notify(source, text, style)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Groups',
        description = text,
        type = style,
    })
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

function util.addItem(source, item, amount, metadata, slot)
    local success, resp = exports.ox_inventory:AddItem(source, item, amount, metadata, slot)
    return success, resp
end

function util.removeItem(source, item, amount, metadata, slot)
    local success, resp = exports.ox_inventory:RemoveItem(source, item, amount, metadata, slot)
    return success, resp
end

function util.hasItem(source, item, metadata, strict)
    return exports.ox_inventory:GetItemCount(item, metadata, strict)
end

return util