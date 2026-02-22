local QBCore = exports['qb-core']:GetCoreObject()


Citizen.CreateThread(function()
    SendNUIMessage({type = 'hide'})
end)


RegisterNetEvent('vehiclecleanup:updateUI', function(data)
    SendNUIMessage(data)
end)


RegisterNetEvent('vehiclecleanup:deleted', function(count)
    SendNUIMessage({
        type = 'deleted',
        count = count
    })
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SendNUIMessage({type = 'hide'})
    end
end)