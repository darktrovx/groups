local util = {}

function util.notify(source, notifData)
    notifData.type = notifData.type or 'info'
    notifData.title = notifData.title or 'Groups'
    notifData.description = notifData.description or 'No description'
    lib.notify(notifData)
end

return util