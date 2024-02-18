task = {}

function task.Update(steps, step)

    if shared.standaloneUI then
        SendNUIMessage({
            type = "updateTask",
            step = TASK.step,
            steps = TASK.steps,
        })
    end

    TriggerEvent("groups:SendTaskUpdate", steps, step)
end

function task.GetTaskData()
    return {
        steps = TASK.steps or {},
        step = TASK.step or 1,
    }
end

function task.GetCurrentStep()
    return TASK.step
end

function task.Cleanup()
    TASKS = {}
end

-- EVENTS

RegisterNetEvent("groups:TaskCreate", function(data)
    TASK.steps = data.steps
    TASK.step = 1
end)

RegisterNetEvent("groups:TaskUpdate", function(data)
    task.Update(data.steps, data.step)
end)

RegisterNetEvent("groups:TaskSetStep", function(data)
    TASK.step = data.step
end)

RegisterNetEvent("groups:SendTaskUpdate", function(steps, step)
    -- Example event for external apps to get data from.
end)

-- NUI Callbacks
RegisterNUICallback("GetTaskData", function(data, cb)
    cb(task.GetTaskData())
end)

return task