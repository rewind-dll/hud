Config = {}

-- ========================================
-- GENERAL SETTINGS
-- ========================================

-- Enable/disable debug logging (shows detailed console output)
Config.Debug = false

-- ========================================
-- STATUS INDICATORS
-- ========================================

-- Update intervals (in milliseconds)
Config.Status = {
    UpdateInterval = 500,  -- How often to check health, armor, hunger, thirst, stamina
    
    -- Fallback values when ESX status is not available
    HungerDecayRate = 0.01,   -- Per update cycle
    ThirstDecayRate = 0.015,  -- Per update cycle
    
    -- Status circle colors (hex format)
    Colors = {
        Health = "#ff4757",   -- Red
        Armor = "#2e86de",    -- Blue
        Hunger = "#ffa502",   -- Orange
        Thirst = "#1e90ff",   -- Light Blue
        Stamina = "#7bed9f"   -- Green
    },
    
    -- Position relative to minimap (in pixels)
    MinimapWidth = 220,
    OffsetFromMinimap = 195
}

-- ========================================
-- WEAPON INDICATOR
-- ========================================

Config.Weapon = {
    UpdateInterval = 50,  -- How often to check weapon state (milliseconds)
    
    -- Weapon names (customize display names here)
    Names = {
        ['WEAPON_PISTOL'] = 'Pistol',
        ['WEAPON_COMBATPISTOL'] = 'Combat Pistol',
        ['WEAPON_APPISTOL'] = 'AP Pistol',
        ['WEAPON_PISTOL50'] = 'Pistol .50',
        ['WEAPON_SNSPISTOL'] = 'SNS Pistol',
        ['WEAPON_HEAVYPISTOL'] = 'Heavy Pistol',
        ['WEAPON_VINTAGEPISTOL'] = 'Vintage Pistol',
        ['WEAPON_MICROSMG'] = 'Micro SMG',
        ['WEAPON_SMG'] = 'SMG',
        ['WEAPON_ASSAULTSMG'] = 'Assault SMG',
        ['WEAPON_COMBATPDW'] = 'Combat PDW',
        ['WEAPON_ASSAULTRIFLE'] = 'Assault Rifle',
        ['WEAPON_CARBINERIFLE'] = 'Carbine Rifle',
        ['WEAPON_ADVANCEDRIFLE'] = 'Advanced Rifle',
        ['WEAPON_SPECIALCARBINE'] = 'Special Carbine',
        ['WEAPON_BULLPUPRIFLE'] = 'Bullpup Rifle',
        ['WEAPON_COMPACTRIFLE'] = 'Compact Rifle',
        ['WEAPON_PUMPSHOTGUN'] = 'Pump Shotgun',
        ['WEAPON_SAWNOFFSHOTGUN'] = 'Sawed-Off Shotgun',
        ['WEAPON_ASSAULTSHOTGUN'] = 'Assault Shotgun',
        ['WEAPON_BULLPUPSHOTGUN'] = 'Bullpup Shotgun',
        ['WEAPON_HEAVYSHOTGUN'] = 'Heavy Shotgun',
        ['WEAPON_SNIPERRIFLE'] = 'Sniper Rifle',
        ['WEAPON_HEAVYSNIPER'] = 'Heavy Sniper',
        ['WEAPON_MARKSMANRIFLE'] = 'Marksman Rifle',
        ['WEAPON_GRENADELAUNCHER'] = 'Grenade Launcher',
        ['WEAPON_RPG'] = 'RPG',
        ['WEAPON_MINIGUN'] = 'Minigun'
    }
}

-- ========================================
-- VEHICLE HUD
-- ========================================

Config.Vehicle = {
    UpdateInterval = 100,       -- How often to update speedometer (milliseconds)
    MonitorInterval = 500,      -- How often to check vehicle entry/exit (milliseconds)
    
    Unit = 'MPH',               -- Speed unit: 'MPH' or 'KMH'
    SpeedMultiplier = 2.236936, -- 2.236936 for MPH, 3.6 for KMH
    
    -- Seatbelt keybind (default: B key)
    SeatbeltKey = 29,           -- Control ID for B key
    
    -- RPM gauge settings
    RPMRedlineStart = 0.85      -- When to show red zone (85% RPM)
}

-- ========================================
-- VOICE INDICATOR (pma-voice)
-- ========================================

Config.Voice = {
    -- Voice range colors (proximity index to color)
    RangeColors = {
        [1] = '#3498db',  -- Whisper: Blue
        [2] = '#ffffff',  -- Normal: White
        [3] = '#f39c12'   -- Shout: Yellow
    },
    
    TalkingColor = '#2ecc71'  -- Green when talking
}

-- ========================================
-- HELPER FUNCTIONS
-- ========================================

-- Debug print helper
function DebugPrint(...)
    if Config.Debug then
        print(...)
    end
end

-- Get weapon display name
function GetWeaponDisplayName(weaponHash)
    local weaponName = GetHashKey(weaponHash)
    return Config.Weapon.Names[weaponName] or tostring(weaponHash)
end
