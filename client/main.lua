TASK = {}
GROUP_BLIPS = {}

shared = require 'config.shared'

function Debug(area, text)
    if not shared.debug then return end
    area = area or 'groups'
    print(string.format('%s: %s', area, text))
end

local function OpenUI()
    SendNUIMessage({
        type = "open",
    })
    SetNuiFocus(true, true)
end

local function CloseUI()
    SetNuiFocus(false, false)
end

RegisterNUICallback('Close', function(data, cb)
    CloseUI()
    cb('ok')
end)

if shared.standaloneUI then
    RegisterCommand('+group', function()
        OpenUI()
    end, false)
    RegisterKeyMapping('+group', 'Open Group UI', 'keyboard', 'o')
end