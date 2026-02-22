local QBCore = exports['qb-core']:GetCoreObject()


local authorizedLicenses = {
    "license:xxxx",
}

local cleanupActive = false
local cleanupTimer = nil
local timeLeft = 0

local function isAuthorized(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if id == authorizedLicenses[1] then
            return true
        end
    end
    return false
end

local function sendUIUpdate(type, time, count)
    TriggerClientEvent('vehiclecleanup:updateUI', -1, {
        type = type,
        time = time or 0,
        totalVehicles = count or 0
    })
end


local function deleteEmptyVehicles()
    local vehicles = GetGamePool('CVehicle')
    local deleted = 0
    
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) then
            local hasPlayer = false
            
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver ~= 0 and IsPedAPlayer(driver) then
                hasPlayer = true
            end
            
            if not hasPlayer then
                for seat = 0, 7 do
                    local passenger = GetPedInVehicleSeat(vehicle, seat)
                    if passenger ~= 0 and IsPedAPlayer(passenger) then
                        hasPlayer = true
                        break
                    end
                end
            end
            

            if not hasPlayer then
                DeleteEntity(vehicle)
                deleted = deleted + 1
            end
        end
    end
    
    return deleted
end


local function countEmptyVehicles()
    local vehicles = GetGamePool('CVehicle')
    local count = 0
    
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if DoesEntityExist(vehicle) then
            local hasPlayer = false
            
            local driver = GetPedInVehicleSeat(vehicle, -1)
            if driver ~= 0 and IsPedAPlayer(driver) then
                hasPlayer = true
            end
            

            if not hasPlayer then
                for seat = 0, 7 do
                    local passenger = GetPedInVehicleSeat(vehicle, seat)
                    if passenger ~= 0 and IsPedAPlayer(passenger) then
                        hasPlayer = true
                        break
                    end
                end
            end
            
            if not hasPlayer then
                count = count + 1
            end
        end
    end
    
    return count
end


QBCore.Commands.Add('deleteallvehicles', 'Delete empty vehicles', {
    { name = 'minutes', help = 'Minutes until deletion' }
}, true, function(source, args)
    local src = source
    
    if not isAuthorized(src) then
        TriggerClientEvent('QBCore:Notify', src, 'Not authorized!', 'error')
        return
    end
    
    if cleanupActive then
        TriggerClientEvent('QBCore:Notify', src, 'Cleanup already in progress!', 'error')
        return
    end
    

    local minutes = tonumber(args[1]) or 1
    if minutes < 1 then minutes = 1 end
    if minutes > 10 then minutes = 10 end
    

    local emptyCount = countEmptyVehicles()
    

    cleanupActive = true
    timeLeft = minutes * 60
    

    sendUIUpdate('show', timeLeft, emptyCount)
    

    TriggerClientEvent('QBCore:Notify', -1, '🚗 Empty vehicles will be deleted in ' .. minutes .. ' minutes!', 'primary', 5000)
    

    cleanupTimer = Citizen.CreateThread(function()
        while timeLeft > 0 do
            Citizen.Wait(1000)
            timeLeft = timeLeft - 1
            sendUIUpdate('update', timeLeft, emptyCount)
            

            if timeLeft == 60 then
                TriggerClientEvent('QBCore:Notify', -1, '⚠️ 60 seconds remaining!', 'error', 5000)
            elseif timeLeft == 30 then
                TriggerClientEvent('QBCore:Notify', -1, '⚠️ 30 seconds! Get out of vehicles!', 'error', 5000)
            elseif timeLeft == 10 then
                TriggerClientEvent('QBCore:Notify', -1, '⚠️ 10 seconds!', 'error', 5000)
            end
        end
        

        local deleted = deleteEmptyVehicles()
        

        TriggerClientEvent('vehiclecleanup:deleted', -1, deleted)
        TriggerClientEvent('QBCore:Notify', -1, '✅ Deleted ' .. deleted .. ' empty vehicles!', 'success', 5000)
        

        Citizen.Wait(5000)
        sendUIUpdate('hide')
        

        cleanupActive = false
        cleanupTimer = nil
    end)
end)


QBCore.Commands.Add('cancelcleanup', 'Cancel vehicle cleanup', {}, true, function(source)
    local src = source
    
    if not cleanupActive then
        TriggerClientEvent('QBCore:Notify', src, 'No cleanup active!', 'error')
        return
    end
    
    if not isAuthorized(src) and src ~= 0 then
        TriggerClientEvent('QBCore:Notify', src, 'Not authorized!', 'error')
        return
    end
    
    if cleanupTimer then
        Citizen.StopThread(cleanupTimer)
    end
    
    cleanupActive = false
    sendUIUpdate('hide')
    TriggerClientEvent('QBCore:Notify', -1, '❌ Cleanup cancelled!', 'error', 5000)
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if cleanupTimer then
            Citizen.StopThread(cleanupTimer)
        end
        sendUIUpdate('hide')
    end
end)