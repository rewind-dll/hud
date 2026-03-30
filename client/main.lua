-- HUD visibility state
local hudVisible = true

-- Initialize HUD on script start
Citizen.CreateThread(function()
    Wait(1000)  -- Wait for server to be ready
    DebugPrint('[HUD CLIENT] Script initialized')
    SetNuiFocus(false, false)
    DebugPrint('[HUD CLIENT] Waiting for player initialization...')
    
    -- Wait for player to be loaded (check for character spawn)
    while true do
        Wait(100)
        if GetPlayerPed(-1) and DoesEntityExist(GetPlayerPed(-1)) then
            DebugPrint('[HUD CLIENT] Player spawned, initializing HUD...')
            -- Initialize with player job (you can replace this with actual framework data)
            TriggerServerEvent('hud:server:initPlayer', 'Unemployed', 0, 0, 0)
            break
        end
    end
end)

-- Hide default health and armor bars
Citizen.CreateThread(function()
    while true do
        Wait(0)
        HideHudComponentThisFrame(3)  -- SP Health
        HideHudComponentThisFrame(4)  -- SP Armor
    end
end)

-- Continuously refresh HUD data from framework
Citizen.CreateThread(function()
    while true do
        Wait(1000)  -- Update every 1 second for real-time tracking
        if hudVisible then
            TriggerServerEvent('hud:server:getData')
        end
    end
end)

-- Update time and voice range every second
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        if hudVisible then
            -- Get current time (hours:minutes)
            local hours = GetClockHours()
            local minutes = GetClockMinutes()
            local timeString = string.format('%02d:%02d', hours, minutes)
            
            -- Get voice range from pma-voice (1=whisper, 2=normal, 3=shout)
            local voiceRange = 2  -- Default to normal
            if LocalPlayer.state.proximity then
                voiceRange = LocalPlayer.state.proximity.index or 2
            end
            
            -- Get talking state (using mumble)
            local isTalking = MumbleIsPlayerTalking(PlayerId()) or false
            
            -- Get player ID
            local playerId = GetPlayerServerId(PlayerId())
            
            -- Send time and voice updates
            SendNuiMessage(json.encode({
                action = 'updatePlayer',
                data = {
                    id = playerId,
                    time = timeString,
                    voiceRange = voiceRange,
                    isTalking = isTalking
                }
            }))
        end
    end
end)

-- Receive HUD data from server and send to NUI
RegisterNetEvent('hud:client:updateData', function(data)
    if data then
        DebugPrint(('[HUD CLIENT] Received data: Job=%s, Cash=%d, Bank=%d, Dirty=%d'):format(
            data.job or 'nil', data.cash or 0, data.bank or 0, data.dirty or 0
        ))
        
        -- Get current player ID
        local playerId = GetPlayerServerId(PlayerId())
        
        -- Get current time (hours:minutes)
        local hours = GetClockHours()
        local minutes = GetClockMinutes()
        local timeString = string.format('%02d:%02d', hours, minutes)
        
        -- Get voice range from pma-voice (default to 2 if not available)
        local voiceRange = 2
        if LocalPlayer.state.proximity then
            voiceRange = LocalPlayer.state.proximity.index or 2
        end
        
        -- Get talking state
        local isTalking = MumbleIsPlayerTalking(PlayerId()) or false
        
        local message = {
            action = 'updatePlayer',
            data = {
                id = playerId,
                job = data.job or 'Unknown',
                bank = data.bank or 0,
                cash = data.cash or 0,
                dirty = data.dirty or 0,
                time = timeString,
                voiceRange = voiceRange,
                isTalking = isTalking
            }
        }
        DebugPrint('[HUD CLIENT] Sending to NUI: ' .. json.encode(message))
        SendNuiMessage(json.encode(message))
    else
        DebugPrint('[HUD CLIENT] ERROR: Received nil data from server')
    end
end)

-- Toggle HUD visibility
RegisterCommand('toghud', function()
    hudVisible = not hudVisible
    local message = {
        action = 'setVisibility',
        data = hudVisible
    }
    DebugPrint('[HUD CLIENT] Sending visibility to NUI: ' .. json.encode(message))
    SendNuiMessage(json.encode(message))
    DebugPrint('[HUD CLIENT] HUD visibility toggled: ' .. tostring(hudVisible))
end, false)

-- Command to test money updates
RegisterCommand('testmoney', function(source, args, rawCommand)
    local amount = tonumber(args[1]) or 1000
    DebugPrint('[HUD CLIENT] Testing addCash with amount: ' .. amount)
    TriggerServerEvent('hud:server:addCash', amount)
end, false)

-- Command to test job change
RegisterCommand('testjob', function(source, args, rawCommand)
    local job = table.concat(args, ' ') or 'Unemployed'
    DebugPrint('[HUD CLIENT] Testing setJob with: ' .. job)
    TriggerServerEvent('hud:server:setJob', job)
end, false)

-- Command to test dirty money
RegisterCommand('testdirty', function(source, args, rawCommand)
    local amount = tonumber(args[1]) or 5000
    DebugPrint('[HUD CLIENT] Testing addDirty with amount: ' .. amount)
    TriggerServerEvent('hud:server:addDirty', amount)
end, false)

-- Command to test bank
RegisterCommand('testbank', function(source, args, rawCommand)
    local amount = tonumber(args[1]) or 10000
    DebugPrint('[HUD CLIENT] Testing addBank with amount: ' .. amount)
    TriggerServerEvent('hud:server:addBank', amount)
end, false)

-- Debug command to check if NUI is working
RegisterCommand('huddebug', function()
    DebugPrint('[HUD CLIENT] Sending debug NUI message...')
    local message = {
        action = 'updateHUD',
        job = 'DEBUG_TEST',
        bank = 99999,
        cash = 88888,
        dirty = 77777
    }
    DebugPrint('[HUD CLIENT] Debug message: ' .. json.encode(message))
    SendNuiMessage(json.encode(message))
end, false)

-- Command to manually initialize HUD with custom values
RegisterCommand('initHUD', function(source, args, rawCommand)
    local job = args[1] or 'Unemployed'
    local cash = tonumber(args[2]) or 0
    local bank = tonumber(args[3]) or 0
    local dirty = tonumber(args[4]) or 0
    
    DebugPrint(('[HUD CLIENT] Initializing HUD with: Job=%s, Cash=%d, Bank=%d, Dirty=%d'):format(job, cash, bank, dirty))
    TriggerServerEvent('hud:server:initPlayer', job, cash, bank, dirty)
end, false)
