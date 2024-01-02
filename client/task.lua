task = {}

function task.Create()

end

function task.Delete()

end

function task.Update(steps, step)
    if not steps then
        steps = TASK.steps or {}
    end
    if not step then
        step = TASK.step or 1
    end
    SendNUIMessage({
        type = "updateTask",
        step = Task.step,
        steps = TASK.steps,
    })
    TriggerEvent("groups:SendTaskUpdate", steps, step)
end

function task.GetTaskData()
    return {
        steps = TASK.steps or {},
        step = TASK.step or 1,
    }
end

function task.Complete()

end

function task.Cleanup()
    TASKS = {}
end

function task.CreateVehicle()

end

function task.DeleteVehicle()

end

function task.CreatePed()

end

function task.CreateEnemyPed()

end

function task.DeletePed()

end

function task.CreateObject()

end

function task.DeleteObject()

end

function task.CreateInteractable()

end

function task.DeleteInteractable()

end

-- EVENTS

RegisterNetEvent("groups:TaskCreate", function(taskData)
    TASK.steps = taskData.steps
    TASK.step = 0
end)

RegisterNetEvent("groups:TaskUpdate", function(steps, step)
    TASK.step = step
    task.Update(nil, step)
end)

RegisterNetEvent("groups:SendTaskUpdate", function(steps, step)
    -- Example event for external apps to get data from.
end)

-- NUI Callbacks
RegisterNUICallback("GetTaskData", function(data, cb)
    cb(task.GetTaskData())
end)