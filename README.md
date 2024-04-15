# !!WIP!!
## This is the V2 of my original groups script.

This script aims to replace and improve on my first iteration of a group handler.
Still working on it but the base is there with working UI.
To use the built in UI navigate to config/shared.lua and set `standaloneUI = false` to `standaloneUI = true`
There is also an npwd app I've made ( also still a WIP ) [npwd_groups](https://github.com/darktrovx/npwd_groups)

This script is currently setup to work with [Qbox](https://github.com/Qbox-project) and [ox_inventory](https://github.com/overextended/ox_inventory)

If you want to also use the reputation system you need [Reputation](https://github.com/darktrovx/reputation)

This update has no backwards compatibility and any existing group scripts will not work with it.

# Group Exports

## Client

```
-- Create a group.
exports.groups:CreateGroup()
-- Gets a list of all groups.
exports.groups:RequestGroupsList()
-- Leaves the current group.
exports.groups:LeaveGroup()
-- Request to join a group via groupID.
exports.groups:RequestJoin(groupID)
-- Get the requests for the current group player is in.
exports.groups:GetRequests()
-- Accept a group join request by requestID.
exports.groups:AcceptRequest(requestID)
-- Deny a group joint request by requestID.
exports.groups:DenyRequest(requestID)
-- Get the members of the group a player is in.
exports.groups:GetMembers()
-- Kick player from group via memberId.
exports.groups:Kick(memberId)
-- Get current groupID.
exports.groups:GetGroupID()
-- Get current task data.
exports.groups:GetTaskData()
-- Returns if player is owner of a group.
exports.groups:IsOwner()
```

## Server

```
-- Gets members of passed groupID.
exports.groups:GetMembers(groupID)

-- Sets the state of a group.
exports.groups:SetState(groupID, state)

-- Gets group state.
exports.groups:GetState(groupID)

-- Starts group task with passed in data.
exports.groups:StartTask(groupID, name, steps)

-- Set the current task of the group.
exports.groups:SetTask(groupID, task)

-- Get the current task of a group.
exports.groups:GetTask(groupID)

-- Get the group that player is currently in.
exports.groups:GetGroup(playerId)

-- Get the group ID of a group the player is currently in.
exports.groups:GetGroupID(playerId)

-- Reward SINGLE member of a group via playerId.
exports.groups:RewardMember(playerId, data)

-- Reward ALL members of a group.
exports.groups:RewardMembers(groupID, data)

-- Triggers an event on ALL members of a group.
exports.groups:TriggerEvent(groupID, event, data)

-- Notifies ALL group members.
exports.groups:Notify(groupID, notifData)

-- Abandons current group (destroys)
exports.groups:Abandon(groupID, playerId)

-- Get the average reputation for a specific reputation for the entire group.
exports.groups:GetAverageReputation(groupID, reputationName)

-- Creates a blip for all group members.
exports.groups:CreateBlip(groupID, blipName, blipData)

-- Deletes a blip for the group.
exports.groups:DeleteBlip(groupID, blipName)
```

# Blips
Group managed blip system

# Tasks
A group task is the current steps/instructions for the job they are currently working on.
This is optional to use for a job but it is handy so players can know what they have to do.