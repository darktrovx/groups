blip = {}

function blip.Create(name, data)
    if data == nil then return Debug('[Blip Create]',"Invalid Data was passed to the create blip event") end

    blip.DeleteByName(name)

    local newBlip = nil
    if data.coords then
        newBlip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    elseif data.entity then
        newBlip = AddBlipForEntity(data.entity)
    elseif data.netId then 
        newBlip = AddBlipForEntity(NetworkGetEntityFromNetworkId(data.netId))
    elseif data.radius then
        newBlip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, data.radius)
    else
        newBlip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    end

    data.color = data.color or 1
    data.alpha = data.alpha or 255

    if not data.radius then

        data.sprite = data.sprite or 1
        data.scale = data.scale or 0.7
        data.label = data.label or "NO LABEL FOUND"

        SetBlipSprite(newBlip, data.sprite)
        SetBlipScale(newBlip, data.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(data.label)
        EndTextCommandSetBlipName(newBlip)
    end
    
    SetBlipColour(newBlip, data.color)
    SetBlipAlpha(newBlip, data.alpha)

    if data.shortrange then
        SetBlipAsShortRange(newBlip, true)
    else
        SetBlipAsShortRange(newBlip, false)
    end

    if data.route then 
        SetBlipRoute(newBlip, true)
        data.routeColor = data.routeColor or data.color
        SetBlipRouteColour(newBlip, data.routeColor)
    end
    GROUP_BLIPS[#GROUP_BLIPS+1] = {name = name, blip = newBlip}
end

function blip.DeleteByName(name)
    local index = blip.Find(name)
    if index then
        SetBlipRoute(GROUP_BLIPS[index], false)
        RemoveBlip(GROUP_BLIPS[index])
        GROUP_BLIPS[index] = nil
    end
end

function blip.DeleteById(id)
    if GROUP_BLIPS[index] == nil then return end
    SetBlipRoute(GROUP_BLIPS[index], false)
    RemoveBlip(GROUP_BLIPS[index])
    GROUP_BLIPS[index] = nil
end

function blip.Find(name)
    for i = 1, #GROUP_BLIPS do
        if GROUP_BLIPS[i]["name"] == name then
            return GROUP_BLIPS[i]
        end
    end
    return false
end

function blip.ClearAll()
    for k,_ in pairs(GROUP_BLIPS) do
        blip.DeleteById(k)
    end
end

return blip