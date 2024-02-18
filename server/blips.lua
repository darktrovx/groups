blip = {}

function blip.Create(groupID, name, blipData)
    if not GROUPS[groupID] then return end
    local members = group.GetMembers(groupID)
    for i = 1, #members do
        TriggerClientEvent("groups:BlipCreate", members[i].id, name, blipData)
    end
end

function blip.Delete(groupID, name)
    if not GROUPS[groupID] then return end
    local members = group.GetMembers(groupID)
    for i = 1, #members do
        TriggerClientEvent("groups:BlipDelete", members[i].id, name)
    end
end

return blip