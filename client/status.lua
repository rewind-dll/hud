-- Status tracking (health, armor, hunger, thirst, stamina)
local lastStatus = {
    health = 100,
    armor = 0,
    hunger = 100,
    thirst = 100,
    stamina = 100
}

-- Function to get ESX status if available
local function getESXStatus()
    if GetResourceState('es_extended') ~= 'started' then return nil end
    
    local status = {}
    TriggerEvent('esx_status:getStatus', 'hunger', function(hungerStatus)
        if hungerStatus then
            status.hunger = math.floor((hungerStatus.val / 1000000) * 100)
        end
    end)
    
    TriggerEvent('esx_status:getStatus', 'thirst', function(thirstStatus)
        if thirstStatus then
            status.thirst = math.floor((thirstStatus.val / 1000000) * 100)
        end
    end)
    
    return status
end

-- Update status every 500ms
Citizen.CreateThread(function()
    while true do
        Wait(Config.Status.UpdateInterval)
        
        local ped = PlayerPedId()
        
        -- Get health (0-200 in GTA, normalize to 0-100)
        -- When dead, health is <= 100. When alive, health is 101-200
        local health = GetEntityHealth(ped)
        local healthPercent = 0
        
        if health > 0 then
            -- Normalize: 101 = 0%, 200 = 100%
            healthPercent = math.floor(((health - 100) / 100) * 100)
            healthPercent = math.max(0, math.min(100, healthPercent))
        end
        
        -- Get armor (0-100)
        local armor = GetPedArmour(ped)
        
        -- Get stamina (0-100, 100 = full stamina)
        local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
        stamina = math.max(0, math.min(100, stamina))
        
        -- Try to get hunger/thirst from ESX, otherwise use fallback values
        local esxStatus = getESXStatus()
        local hunger = 100
        local thirst = 100
        
        if esxStatus then
            hunger = esxStatus.hunger or 100
            thirst = esxStatus.thirst or 100
        else
            -- Fallback: slowly decrease hunger/thirst over time for demo
            lastStatus.hunger = math.max(0, lastStatus.hunger - Config.Status.HungerDecayRate)
            lastStatus.thirst = math.max(0, lastStatus.thirst - Config.Status.ThirstDecayRate)
            hunger = lastStatus.hunger
            thirst = lastStatus.thirst
        end
        
        -- Update if changed
        if healthPercent ~= lastStatus.health or armor ~= lastStatus.armor or 
           math.abs(hunger - lastStatus.hunger) > 0.5 or math.abs(thirst - lastStatus.thirst) > 0.5 or
           math.abs(stamina - lastStatus.stamina) > 1 then
            
            lastStatus.health = healthPercent
            lastStatus.armor = armor
            lastStatus.hunger = hunger
            lastStatus.thirst = thirst
            lastStatus.stamina = stamina
            
            SendNuiMessage(json.encode({
                action = 'updateStatus',
                data = {
                    health = healthPercent,
                    armor = armor,
                    hunger = math.floor(hunger),
                    thirst = math.floor(thirst),
                    stamina = math.floor(stamina)
                }
            }))
        end
    end
end)

-- Command to test status updates
RegisterCommand('teststatus', function(source, args)
    local health = tonumber(args[1]) or 100
    local armor = tonumber(args[2]) or 0
    local hunger = tonumber(args[3]) or 100
    local thirst = tonumber(args[4]) or 100
    
    SendNuiMessage(json.encode({
        action = 'updateStatus',
        data = {
            health = health,
            armor = armor,
            hunger = hunger,
            thirst = thirst
        }
    }))
    
    DebugPrint(('[STATUS] Test values sent: Health=%d, Armor=%d, Hunger=%d, Thirst=%d'):format(health, armor, hunger, thirst))
end, false)
