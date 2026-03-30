-- Weapon tracking
local currentWeapon = {
    name = 'unarmed',
    ammo = 0,
    clipAmmo = 0
}

-- Get weapon name from hash using Config
local function getWeaponName(weaponHash)
    for key, name in pairs(Config.Weapon.Names) do
        if weaponHash == GetHashKey(key) then
            return name
        end
    end
    -- Fallback: return hash as string
    return tostring(weaponHash)
end

-- Check if weapon is a melee weapon or unarmed
local function isMeleeOrUnarmed(weaponHash)
    local meleeWeapons = {
        `WEAPON_UNARMED`,
        `WEAPON_KNIFE`,
        `WEAPON_NIGHTSTICK`,
        `WEAPON_HAMMER`,
        `WEAPON_BAT`,
        `WEAPON_CROWBAR`,
        `WEAPON_GOLFCLUB`,
        `WEAPON_BOTTLE`,
        `WEAPON_DAGGER`,
        `WEAPON_HATCHET`,
        `WEAPON_MACHETE`,
        `WEAPON_SWITCHBLADE`,
        `WEAPON_POOLCUE`,
        `WEAPON_WRENCH`,
        `WEAPON_BATTLEAXE`,
        `WEAPON_KNUCKLE`,
        `WEAPON_FLASHLIGHT`,
    }
    
    for _, melee in ipairs(meleeWeapons) do
        if weaponHash == melee then
            return true
        end
    end
    return false
end

-- Update weapon info every 50ms
Citizen.CreateThread(function()
    DebugPrint('[WEAPON] Tracking thread started')
    
    while true do
        Wait(Config.Weapon.UpdateInterval)
        
        local ped = PlayerPedId()
        local weaponHash = GetSelectedPedWeapon(ped)
        local weaponName = 'unarmed'
        local ammo = 0
        local clipAmmo = 0
        
        -- Only process if it's not melee or unarmed
        if not isMeleeOrUnarmed(weaponHash) then
            weaponName = getWeaponName(weaponHash)
            
            -- Get ammo in current clip/mag
            local _, clipCount = GetAmmoInClip(ped, weaponHash)
            clipAmmo = clipCount or 0
            
            -- Get total ammo (includes clip)
            local hasWeapon, totalAmmo = GetAmmoInPedWeapon(ped, weaponHash)
            if hasWeapon and totalAmmo then
                -- Reserve ammo = total ammo - current clip
                ammo = math.max(0, totalAmmo - clipAmmo)
            end
        end
        
        -- Always update on any change (including when holstering to unarmed)
        if weaponName ~= currentWeapon.name or ammo ~= currentWeapon.ammo or clipAmmo ~= currentWeapon.clipAmmo then
            currentWeapon.name = weaponName
            currentWeapon.ammo = ammo
            currentWeapon.clipAmmo = clipAmmo
            
            SendNuiMessage(json.encode({
                action = 'updateWeapon',
                data = {
                    name = weaponName,
                    ammo = ammo,
                    clipAmmo = clipAmmo
                }
            }))
            
            DebugPrint(('[WEAPON] Updated: %s | Clip: %d | Reserve: %d'):format(weaponName, clipAmmo, ammo))
        end
    end
end)

-- Command to test weapon display
RegisterCommand('testweapon', function(source, args)
    local weaponName = table.concat(args, ' ', 1) or 'Combat Pistol'
    local ammo = tonumber(args[#args]) or 15
    
    SendNuiMessage(json.encode({
        action = 'updateWeapon',
        data = {
            name = weaponName,
            ammo = ammo
        }
    }))
    
    DebugPrint(('[WEAPON] Test weapon sent: %s with %d ammo'):format(weaponName, ammo))
end, false)
