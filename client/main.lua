TASK = {}
GROUP_BLIPS = {}

function Debug(text)
    if Config.Debug then
        print("[devyn-groups] "..text)
    end
end

local function OpenUI()
    SendNUIMessage({
        type = "open",
    })
    SetNuiFocus(true, true)
end

local function CloseUI()
    SendNUIMessage({
        type = "close",
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function(data, cb)
    CloseUI()
    cb('ok')
end)

if Config.UI then
    RegisterCommand('+group', function()
        OpenUI()
    end, false)
    RegisterKeyMapping('+group', 'Open Group UI', 'keyboard', 'o')
end