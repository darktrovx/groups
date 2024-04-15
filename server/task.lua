task = {}

local shared = require "config.shared"

function task.Create(groupID, name, steps, limit)
    if TASKS[groupID] then
        if TASKS[groupID].inProgress then
            Debug('[task.Create]', "Group already has a task in progress.")
            return false
        end
    else

        Debug('[task.Create]', "Creating task for group "..groupID..".")
        TASKS[groupID] = {
            inProgress = true,
            name = name,
            steps = steps,
            currentStep = 1,
            groupLimit = limit or shared.DefaultGroupLimit,
        }
        Debug('[task.Create]', "Task Data: "..json.encode(steps))
        group.TriggerEvent(groupID, "groups:TaskCreate", { steps = steps })

        return true
    end
end

function task.Delete(groupID)
    if not TASKS[groupID] then return false end

    TASKS[groupID] = {
        inProgress = false,
        name = 'IDLE',
        steps = {},
        currentStep = 0,
        groupLimit = shared.DefaultGroupLimit,
    }

    group.TriggerEvent(groupID, "groups:TaskUpdate", { steps = {}, step = 0 })
end


function task.SetStep(groupID, step)
    if TASKS[groupID] then

        TASKS[groupID].currentStep = step
        Debug("[SetStep]", ("Group Step set to %s "):format(step))
        group.TriggerEvent(groupID, "groups:TaskSetStep", { step = step })

        return true
    else
        Debug("[SetStep]", "Group does not exist.")
        return false
    end
end

function task.GetStep(groupID)
    if TASKS[groupID] then
        return TASKS[groupID].currentStep
    else
        Debug("[GetStep] Group does not exist.")
        return 0
    end
end

function task.InProgress(groupID)
    if TASKS[groupID] then
        return TASKS[groupID].inProgress
    else
        Debug('[InProgress] ', "Group does not exist.")
        return false
    end
end

function task.Update(groupID, steps, step)
    if TASKS[groupID] and TASKS[groupID].inProgress then
        steps = steps or TASKS[groupID].steps
        step = step or 1
        group.TriggerEvent(groupID, "groups:TaskUpdate", { steps = steps, step = step })
    else
        Debug("[TaskUpdate] Group does not exist or task is not in progress.")
    end
end

function task.SetGroupLimit(groupID, limit)
    if TASKS[groupID] then
        TASKS[groupID].groupLimit = limit
    else
        Debug("[SetGroupLimit] Group does not exist.")
    end
end

return task