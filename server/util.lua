function Notify(source, text, style)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Groups',
        description = text,
        type = style,
    })
end

function GetMemberName(source)
    -- local name = "Unknown "..math.random(0000, 9999)
    -- return name
    local Player = exports['qbx_core']:GetPlayer(source)
    local name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
    return name
end

function AddMoney(source, account, amount)

end

function RemoveMoney(source, account, amount)

end

function AddItem(source, item, amount)

end

function RemoveItem(source, item, amount)

end

function HasItem(source, item, amount)

end