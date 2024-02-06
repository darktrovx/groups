local util = {}

function util.notify(text, type)
    lib.notify({ title = 'Groups', description = text, type = type })
end

return util