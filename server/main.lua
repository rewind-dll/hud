-- Store player session data (global for hud_framework.lua)
Players = {}

-- Player joined event
AddEventHandler('playerJoining', function()
    local src = source
    Players[src] = {
        job = 'Unemployed',
        bank = 0,
        cash = 0,
        dirty = 0
    }
    
    DebugPrint(('[HUD SERVER] Player %d joined - initializing data'):format(src))
end)

-- Player dropping
AddEventHandler('playerDropped', function()
    local src = source
    Players[src] = nil
    DebugPrint(('[HUD SERVER] Player %d dropped'):format(src))
end)

-- Get player HUD data
RegisterNetEvent('hud:server:getData', function()
    local src = source
    DebugPrint(('[HUD SERVER] getData called by player %d'):format(src))
    
    -- Get data from framework or fallback to stored data
    local data = GetPlayerHUDData(src)
    
    DebugPrint(('[HUD SERVER] Sending data to player %d: Job=%s, Cash=%d, Bank=%d, Dirty=%d'):format(
        src, data.job, data.cash, data.bank, data.dirty
    ))
    TriggerClientEvent('hud:client:updateData', src, data)
end)

-- Update player job
RegisterNetEvent('hud:server:setJob', function(jobName)
    local src = source
    if not Players[src] then Players[src] = {} end
    Players[src].job = jobName
    DebugPrint(('[HUD SERVER] Player %d job set to: %s'):format(src, jobName))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Update cash
RegisterNetEvent('hud:server:addCash', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then 
        DebugPrint(('[HUD SERVER] Invalid addCash call from player %d: %s'):format(src, tostring(amount)))
        return 
    end
    
    Players[src].cash = Players[src].cash + amount
    DebugPrint(('[HUD SERVER] Player %d cash updated: +%d (total: %d)'):format(src, amount, Players[src].cash))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Remove cash
RegisterNetEvent('hud:server:removeCash', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    if Players[src].cash >= amount then
        Players[src].cash = Players[src].cash - amount
        DebugPrint(('[HUD SERVER] Player %d cash removed: -%d (total: %d)'):format(src, amount, Players[src].cash))
        TriggerClientEvent('hud:client:updateData', src, Players[src])
    end
end)

-- Set exact cash amount
RegisterNetEvent('hud:server:setCash', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    Players[src].cash = amount
    DebugPrint(('[HUD SERVER] Player %d cash set to: %d'):format(src, amount))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Update bank
RegisterNetEvent('hud:server:addBank', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    Players[src].bank = Players[src].bank + amount
    DebugPrint(('[HUD SERVER] Player %d bank updated: +%d (total: %d)'):format(src, amount, Players[src].bank))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Remove bank
RegisterNetEvent('hud:server:removeBank', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    if Players[src].bank >= amount then
        Players[src].bank = Players[src].bank - amount
        DebugPrint(('[HUD SERVER] Player %d bank removed: -%d (total: %d)'):format(src, amount, Players[src].bank))
        TriggerClientEvent('hud:client:updateData', src, Players[src])
    end
end)

-- Set exact bank amount
RegisterNetEvent('hud:server:setBank', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    Players[src].bank = amount
    DebugPrint(('[HUD SERVER] Player %d bank set to: %d'):format(src, amount))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Update dirty money
RegisterNetEvent('hud:server:addDirty', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    Players[src].dirty = Players[src].dirty + amount
    DebugPrint(('[HUD SERVER] Player %d dirty money updated: +%d (total: %d)'):format(src, amount, Players[src].dirty))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Remove dirty money
RegisterNetEvent('hud:server:removeDirty', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    if Players[src].dirty >= amount then
        Players[src].dirty = Players[src].dirty - amount
        DebugPrint(('[HUD SERVER] Player %d dirty money removed: -%d (total: %d)'):format(src, amount, Players[src].dirty))
        TriggerClientEvent('hud:client:updateData', src, Players[src])
    end
end)

-- Set exact dirty money amount
RegisterNetEvent('hud:server:setDirty', function(amount)
    local src = source
    if not Players[src] then Players[src] = {} end
    if type(amount) ~= 'number' or amount < 0 then return end
    
    Players[src].dirty = amount
    DebugPrint(('[HUD SERVER] Player %d dirty money set to: %d'):format(src, amount))
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Initialize player with data (call this from your framework/when player loads)
RegisterNetEvent('hud:server:initPlayer', function(jobName, cash, bank, dirty)
    local src = source
    if not Players[src] then Players[src] = {} end
    
    Players[src].job = jobName or 'Unemployed'
    Players[src].cash = cash or 0
    Players[src].bank = bank or 0
    Players[src].dirty = dirty or 0
    
    DebugPrint(('[HUD SERVER] Player %d initialized: Job=%s, Cash=%d, Bank=%d, Dirty=%d'):format(
        src, Players[src].job, Players[src].cash, Players[src].bank, Players[src].dirty
    ))
    
    TriggerClientEvent('hud:client:updateData', src, Players[src])
end)

-- Get player data (export for other resources)
exports('getPlayerData', function(playerId)
    return Players[playerId] or {
        job = 'Unknown',
        bank = 0,
        cash = 0,
        dirty = 0
    }
end)

-- Admin command to set player job
RegisterCommand('setjob', function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local jobName = table.concat(args, ' ', 2) or 'Unemployed'
    
    if playerId and Players[playerId] then
        Players[playerId].job = jobName
        DebugPrint(('[HUD SERVER] Admin set player %d job to: %s'):format(playerId, jobName))
        TriggerClientEvent('hud:client:updateData', playerId, Players[playerId])
    end
end, true)

-- Admin command to set player money
RegisterCommand('setcash', function(source, args, rawCommand)
    local playerId = tonumber(args[1])
    local amount = tonumber(args[2]) or 0
    
    if playerId and Players[playerId] then
        Players[playerId].cash = amount
        DebugPrint(('[HUD SERVER] Admin set player %d cash to: %d'):format(playerId, amount))
        TriggerClientEvent('hud:client:updateData', playerId, Players[playerId])
    end
end, true)
