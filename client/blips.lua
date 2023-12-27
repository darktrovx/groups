blip = {}

function blip.Create(name, blipData)
    if blipData == nil then return Debug("Invalid Data was passed to the create blip event") end

    blip.Delete(name)

    local blip = nil
    if data.entity then
        blip = AddBlipForEntity(data.entity)
    elseif data.netId then 
        blip = AddBlipForEntity(NetworkGetEntityFromNetworkId(data.netId))
    elseif data.radius then
        blip = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, data.radius)
    else
        blip = AddBlipForCoord(data.coords)
    end

    if data.color == nil then data.color = 1 end
    if data.alpha == nil then data.alpha = 255 end

    if not data.radius then
        if data.sprite == nil then data.sprite = 1 end
        if data.scale == nil then data.scale = 0.7 end
        if data.label == nil then data.label = "NO LABEL FOUND" end

        SetBlipSprite(blip, data.sprite)
        SetBlipScale(blip, data.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(data.label)
        EndTextCommandSetBlipName(blip)
    end
    
    SetBlipColour(blip, data.color)
    SetBlipAlpha(blip, data.alpha)

    if data.route then 
        SetBlipRoute(blip, true)
        if not data.routeColor then data.routeColor = data.color end
        SetBlipRouteColour(blip, data.routeColor)
    end
    GROUP_BLIPS[#GROUP_BLIPS+1] = {name = name, blip = blip}
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