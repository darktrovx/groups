
RegisterCommand("test", function(source, args, rawCommand)
    -- group.Create(source)

    -- local ps = group.GetPlayer(source)
    -- print('GROUP ID: '..ps.groupID)
    -- print('IS OWNER: '..tostring(ps.groupOwner))
    -- local members = group.GetMembers(ps.groupID)
    -- print('MEMBERS: '..#members)
    -- for i = 1, #members do
    --     print('MEMBER SRC: '..members[i])
    -- end

    -- local ps = group.GetPlayer(source)

    -- task.Create(ps.groupID, 'TEST TASK', {
    --     {
    --         title = 'Test Step 1',
    --         description = 'This is a test step.',
    --     },
    --     {
    --         title = 'Test Step 2',
    --         description = 'This is a test step.',
    --     },
    --     {
    --         title = 'Test Step 3',
    --         description = 'This is a test step.',
    --     },
    -- })

    local id = #GROUPS + 1
    GROUPS[id] = {
        owner = 999,
        task = {},
        members = {
            {
                name = 'Test Group',
                id = 999,
                license = 'invalid',
                owner = true,
            }
        },
        requests = {},
    }

end, false)

RegisterCommand("test2", function(source, args, rawCommand)
    group.AddPlayer(1, 1)
end, false)