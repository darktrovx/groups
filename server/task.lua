task = {}

local shared = require "config.shared"

function task.Create(groupID, name, steps, limit)
    if TASKS[groupID] then
        if TASKS[groupID].InProgress then
            Debug('[task.Create]', "Group already has a task in progress.")
            return false
        end
    else

        Debug('[task.Create]', "Creating task for group "..groupID..".")
        TASKS[groupID] = {
            InProgress = true,
            Name = name,
            Steps = steps,
            CurrentStep = 1,
            GroupLimit = limit or shared.DefaultGroupLimit,
        }
        Debug('[task.Create]', "Task Data: "..json.encode(steps))
        group.TriggerEvent(groupID, "groups:TaskCreate", { steps = steps })

        return true
    end
end

function task.Delete()

end

function task.Complete()

end

function task.Fail()

end

function task.SetStep(groupID, step)
    if TASKS[groupID] then

        TASKS[groupID].CurrentStep = step

        group.TriggerEvent(groupID, "groups:TaskUpdate", { step = step })

        return true
    else
        Debug("[SetStep] Group does not exist.")
        return false
    end
end

function task.GetStep(groupID)

end

function task.InProgress(groupID)
    if TASKS[groupID] then
        return TASKS[groupID].InProgress
    else
        Debug('[InProgress] ', "Group does not exist.")
        return false
    end
end

function task.Update(groupID, step)
    if TASKS[groupID] and TASKS[groupID].InProgress then
        group.TriggerEvent(groupID, "groups:TaskUpdate", { step = step })
    else
        Debug("[TaskUpdate] Group does not exist or task is not in progress.")
    end
end

function task.SetGroupLimit(groupID, limit)
    if TASKS[groupID] then
        TASKS[groupID].GroupLimit = limit
    else
        Debug("[SetGroupLimit] Group does not exist.")
    end
end

function task.Cleanup()

end

return task