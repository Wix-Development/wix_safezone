-- __          _________   __    _____                 _                                  _   
-- \ \        / /_   _\ \ / /   |  __ \               | |                                | |  
--  \ \  /\  / /  | |  \ V /    | |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
--   \ \/  \/ /   | |   > <     | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
--    \  /\  /   _| |_ / . \    | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
--     \/  \/   |_____/_/ \_\   |_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
--                                                            | |                             
--                                                            |_|                             
Config = {}

Config.SafeZones = { 
    ["hospital"] = {
        -- Zone Location Settings
        coords = { x=320.3028, y=-594.6119, z=43.2918 }, -- Central point coordinates of the safezone
        radius = 45.0,                                    -- Size of the safezone in meters

        -- Visual Settings
        color = { r=255, g=0, b=0, a=128 },  -- Border color (Red, Green, Blue, Alpha)
        showBorder = true,                    -- Show a visual border around the zone
        showBlip = true,                      -- Show zone on the minimap
        blipColor = 2,                        -- Color of the minimap blip (2 = green)
        transparentPlayers = true,            -- Make players semi-transparent in the zone

        -- Protection Settings
        setInvincible = true,                -- Players can't take damage in the zone
        removeWeapons = true,                -- Remove all weapons when entering
        disableFiring = true,                -- Prevent weapon firing even if player has weapons
        antiZoneCamp = false,                -- Adds extra radius when exiting to prevent camping

        -- Vehicle Settings
        enableSpeedLimits = true,            -- Enable speed limiting in the zone
        setSpeedLimit = 20,                  -- Maximum speed allowed
        speedUnit = 'kmh',                   -- Speed unit: 'mph', 'kmh', 'ms' (meters per second)

        -- Notification Settings
        notifications = {
            enabled = true,                   -- Show notifications on enter/exit
            title = "Hospital Safezone",      -- Title of notifications
            enterMessage = "You have entered the hospital safezone",  -- Message shown on entry
            exitMessage = "You have left the hospital safezone",      -- Message shown on exit
            enterType = 'success',            -- Notification type on entry ('success', 'error', 'info')
            exitType = 'error'               -- Notification type on exit
        }
    },

    -- Example additional zone
    --[[
    ["police"] = {
        coords = { x=442.1, y=-983.5, z=30.6 },
        radius = 50.0,
        -- ... copy settings from above ...
    }
    --]]
}