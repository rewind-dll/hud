-- Vehicle HUD tracking
local isInVehicle = false
local vehicleHandle = nil
local seatbeltOn = false

-- Monitor vehicle entry/exit
Citizen.CreateThread(function()
    while true do
        Wait(Config.Vehicle.MonitorInterval)
        
        local ped = PlayerPedId()
        local newInVehicle = IsPedInAnyVehicle(ped)
        
        -- Vehicle state changed
        if newInVehicle ~= isInVehicle then
            isInVehicle = newInVehicle
            DebugPrint(('[VEHICLE HUD] In vehicle: %s'):format(tostring(isInVehicle)))
            
            if isInVehicle then
                vehicleHandle = GetVehiclePedIsIn(ped)
                seatbeltOn = false  -- Reset seatbelt on entry
                DebugPrint(('[VEHICLE HUD] Entered vehicle: %d'):format(vehicleHandle))
            else
                vehicleHandle = nil
                DebugPrint('[VEHICLE HUD] Exited vehicle')
                -- Hide vehicle HUD
                SendNuiMessage(json.encode({
                    action = 'updateVehicle',
                    data = {
                        active = false,
                        speed = 0,
                        fuel = 0,
                        unit = 'MPH',
                        rpm = 0,
                        gear = 'P',
                        odometer = 0,
                        lights = false,
                        seatbelt = false,
                        engine = false
                    }
                }))
            end
        end
    end
end)

-- Toggle seatbelt with B key
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        if isInVehicle then
            if IsControlJustPressed(0, Config.Vehicle.SeatbeltKey) then
                seatbeltOn = not seatbeltOn
                DebugPrint(('[VEHICLE HUD] Seatbelt: %s'):format(tostring(seatbeltOn)))
            end
        end
    end
end)

-- Update vehicle stats every tick
Citizen.CreateThread(function()
    while true do
        Wait(Config.Vehicle.UpdateInterval)
        
        if isInVehicle and vehicleHandle and DoesEntityExist(vehicleHandle) then
            -- Speed in MPH or KMH based on config
            local speed = GetEntitySpeed(vehicleHandle) * Config.Vehicle.SpeedMultiplier
            local fuel = GetVehicleFuelLevel(vehicleHandle)
            
            -- RPM (0.0 to 1.0)
            local rpm = GetVehicleCurrentRpm(vehicleHandle)
            
            -- Gear
            local gear = GetVehicleCurrentGear(vehicleHandle)
            if gear == 0 then
                gear = 'R'
            elseif speed < 1 then
                gear = 'P'
            end
            
            -- Odometer (using entity ID as pseudo-odometer for demo)
            local odometer = math.floor(speed * 100) % 999999
            
            -- Lights
            local lightsOn = GetVehicleLightsState(vehicleHandle)
            
            -- Engine running
            local engineOn = GetIsVehicleEngineRunning(vehicleHandle)
            
            -- Send to NUI with correct structure
            SendNuiMessage(json.encode({
                action = 'updateVehicle',
                data = {
                    active = true,
                    speed = math.floor(speed),
                    fuel = math.max(0, math.floor(fuel)),
                    unit = Config.Vehicle.Unit,
                    rpm = rpm,
                    gear = gear,
                    odometer = odometer,
                    lights = lightsOn,
                    seatbelt = seatbeltOn,
                    engine = engineOn
                }
            }))
        end
    end
end)

-- Debug command
RegisterCommand('vehicledebug', function()
    if isInVehicle and vehicleHandle then
        DebugPrint(('Vehicle Handle: %d'):format(vehicleHandle))
        DebugPrint(('Speed: %.2f km/h'):format(GetEntitySpeed(vehicleHandle) * 3.6))
        DebugPrint(('Fuel: %.2f%%'):format(GetVehicleFuelLevel(vehicleHandle)))
        DebugPrint(('Engine: %.2f%%'):format(GetVehicleEngineHealth(vehicleHandle) / 10))
    else
        DebugPrint('[VEHICLE HUD] Not in a vehicle')
    end
end, false)
