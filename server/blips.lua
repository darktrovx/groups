blip = {}

function blip.Create(groupID, name, blipData)
    if not GROUPS[groupID] then return end
    local members = group.GetMembers(groupID)
    for i = 1, #members do
        local source = members[i].id
        if source then
            TriggerClientEvent("groups:BlipCreate", source, name, blipData)
        end
    end
end

function blip.Delete(groupID, name)
    if not GROUPS[groupID] then return end
    local members = group.GetMembers(groupID)
    for i = 1, #members do
        local source = members[i].id
        if source then
            TriggerClientEvent("groups:BlipDelete", source, name)
        end
    end
end

return blip