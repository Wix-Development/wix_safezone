local SafeZones = {SafeZone = false}
local currentZoneConfig = nil
local inZone = false
local disabledControls = {37, 106, 140, 141, 142, 157, 158, 159, 160, 161, 162, 163, 164, 165}

local function handleTransparency(ped, enable)
    if enable then
        SetEntityAlpha(ped, 170, false)
    else
        SetEntityAlpha(ped, 255, false)
    end
end

local function handleZoneEffects(ped, zoneConfig, enable)
    if enable then
        if zoneConfig.removeWeapons then
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            RemoveAllPedWeapons(ped, true)
        end
        if zoneConfig.setInvincible then SetPlayerInvincible(ped, true) end
        if zoneConfig.transparentPlayers then 
            handleTransparency(ped, true)
        end
        NetworkSetFriendlyFireOption(false)
    else
        NetworkSetFriendlyFireOption(true)
        SetPlayerInvincible(ped, false)
        handleTransparency(ped, false)
    end
end

local function convertSpeed(speed, unit)
    local conversions = {
        mph = 0.44,
        kmh = 0.278,
        ms = 1.0
    }
    return speed * (conversions[unit] or conversions.mph)
end

local function handleVehicle(vehicle, zoneConfig, enable)
    if not vehicle then return end
    if enable and zoneConfig.enableSpeedLimits then
        local gameSpeed = convertSpeed(zoneConfig.setSpeedLimit, zoneConfig.speedUnit)
        SetVehicleMaxSpeed(vehicle, gameSpeed)
    else
        SetEntityAlpha(vehicle, enable and 170 or 255, false)
        SetVehicleMaxSpeed(vehicle, 0.0)
    end
end

AddEventHandler("onClientResourceStart", function(resourceName)
    local scriptName = GetCurrentResourceName()
    if resourceName ~= scriptName then return end
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsUsing(ped)

        if not SafeZones.SafeZone then
            for _, v in pairs(Config.SafeZones) do
                if #(coords - vector3(v.coords.x, v.coords.y, v.coords.z)) <= v.radius then
                    SafeZones.SafeZone = true
                    currentZoneConfig = v
                    SafeZones.coords = v.coords
                    SafeZones.radius = v.radius
                    
                    handleZoneEffects(ped, v, true)
                    handleVehicle(vehicle, v, true)
                    
                    if v.notifications and v.notifications.enabled then
                        exports['wix_core']:Notify(v.notifications.title, v.notifications.enterMessage, v.notifications.enterType)
                    end
                    inZone = true
                    Citizen.Wait(0)
                    break
                end
            end
            Citizen.Wait(500)
        elseif currentZoneConfig then
            if currentZoneConfig.removeWeapons then
                for _, control in ipairs(disabledControls) do
                    DisableControlAction(0, control, true)
                end
                if GetSelectedPedWeapon(ped) ~= GetHashKey('WEAPON_UNARMED') then
                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
                    RemoveAllPedWeapons(ped, true)
                end
            end

            if wasInVehicle ~= IsPedInAnyVehicle(ped, false) then
                wasInVehicle = IsPedInAnyVehicle(ped, false)
                if currentZoneConfig.transparentPlayers then
                    handleTransparency(ped, true)
                end
            end

            if currentZoneConfig.transparentPlayers then
                handleTransparency(ped, true)
                if vehicle then
                    SetEntityAlpha(vehicle, 170, false)
                end
            end

            local exitRadius = currentZoneConfig.antiZoneCamp and (SafeZones.radius + 10) or SafeZones.radius
            if #(coords - vector3(SafeZones.coords.x, SafeZones.coords.y, SafeZones.coords.z)) > exitRadius then
                if inZone then
                    handleVehicle(vehicle, currentZoneConfig, false)
                    if currentZoneConfig.notifications.enabled then
                        exports['wix_core']:Notify(currentZoneConfig.notifications.title, 
                            currentZoneConfig.notifications.exitMessage, 
                            currentZoneConfig.notifications.exitType)
                    end
                end
                handleZoneEffects(ped, currentZoneConfig, false)
                SafeZones.SafeZone = false
                SafeZones.coords = nil
                SafeZones.radius = nil
                currentZoneConfig = nil
                inZone = false
            end
        end
        
        Citizen.Wait(0)
    end
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    local scriptName = GetCurrentResourceName()
    if resourceName ~= scriptName then return end
    for _, v in pairs(Config.SafeZones) do
        if v.showBlip then
            local blip = AddBlipForRadius(v.coords.x, v.coords.y, v.coords.z, v.radius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, v.blipColor)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)
        end
    end
end)

local function hasEnabledBorders()
    for _, v in pairs(Config.SafeZones) do
        if v.showBorder then
            return true
        end
    end
    return false
end

AddEventHandler("onClientResourceStart", function(resourceName)
    local scriptName = GetCurrentResourceName()
    if resourceName ~= scriptName then return end

    if hasEnabledBorders() then
        while true do
            Citizen.Wait(0)
            for i, v in pairs(Config.SafeZones) do
                if v.showBorder then
                    DrawMarker(
                           1, 
                        v.coords.x, v.coords.y, v.coords.z - 8, 
                        0.0, 0.0, 0.0, 
                        0, 0.0, 0.0, 
                        v.radius * 1.98, v.radius * 1.98, 10.0, 
                        v.color.r, v.color.g, v.color.b, v.color.a,
                        9999, false, true, 2, false, false, false, false
                    )
                end
            end
        end
    end
end)