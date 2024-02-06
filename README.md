# !!WIP!!
## This is the V2 of my original groups script.

This script aims to replace and improve on my first iteration of a group handler.
Still working on it but the base is there with working UI.
 
I am currently planning on finishing this script along with creating an app for qb-phone and possibly npwd that can be plug and play so more servers can utilize this script.

This update has no backwards compatibility and any existing group scripts will not work with it.


## Reputation SQL
```
CREATE TABLE `group_rep` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`citizenid` VARCHAR(55) NOT NULL COLLATE 'utf8mb4_general_ci',
	`reputation` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
	UNIQUE INDEX `id` (`id`) USING BTREE,
	CONSTRAINT `reputation` CHECK (json_valid(`reputation`))
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
```

## Reputation Exports
```
-- Gets all Player reputations and values
exports['devyn-groups']:GetRep(citizenid)

-- Gets a singluar rep and value.
exports['devyn-groups']:GetRep(citizenid, reputationName)

-- Sets the reputation to the amount.
exports['devyn-groups']:SetRep(citizenid, reputationName, amountToSet)

-- Add amount to a reputation.
exports['devyn-groups']:AddRep(citizenid, reputationName, amountToAdd)

-- Remove amount from reputation (cannot go lower than zero)
exports['devyn-groups']:RemoveRep(citizenid, reputationName, amountToRemove)
```