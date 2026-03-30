-- HUD Framework Integration
-- This file handles getting player data from your framework

local function GetPlayerDataESX(playerId)
    if GetResourceState('es_extended') ~= 'started' then return nil end
    
    local ESX = exports['es_extended']:getSharedObject()
    local player = ESX.GetPlayerFromId(playerId)
    
    if player then
        return {
            job = player.job.label,
            cash = player.getMoney(),
            bank = player.getAccount('bank').money,
            dirty = player.getAccount('black_money') and player.getAccount('black_money').money or 0
        }
    end
    return nil
end

local function GetPlayerDataQBCore(playerId)
    if GetResourceState('qb-core') ~= 'started' then return nil end
    
    local QBCore = exports['qb-core']:GetCoreObject()
    local player = QBCore.Functions.GetPlayer(playerId)
    
    if player then
        return {
            job = player.PlayerData.job.label,
            cash = player.PlayerData.money['cash'] or 0,
            bank = player.PlayerData.money['bank'] or 0,
            dirty = player.PlayerData.money['dirty'] or 0
        }
    end
    return nil
end

-- Try to get player data from installed framework
function GetPlayerHUDData(playerId)
    -- Try QBCore first
    local data = GetPlayerDataQBCore(playerId)
    if data then return data end
    
    -- Try ESX
    data = GetPlayerDataESX(playerId)
    if data then return data end
    
    -- Fallback to stored data
    return Players[playerId] or {
        job = 'Unknown',
        bank = 0,
        cash = 0,
        dirty = 0
    }
end

-- Auto-sync player data from framework
function SyncPlayerHUDData(playerId)
    local data = GetPlayerHUDData(playerId)
    if data then
        -- Update stored data
        Players[playerId] = data
        -- Send to client
        TriggerClientEvent('hud:client:updateData', playerId, data)
    end
end
