RegisterNetEvent('sd-hitman:server:deductPayment', function(amount)
    local amount = 500
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end
    
    if player.Functions.RemoveItem('cash', amount) then
        TriggerClientEvent('QBCore:Notify', src, 'Payment of $' .. amount .. ' deducted for starting a Celebrity Hit.', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Insufficient funds.', 'error')
    end
end)

RegisterNetEvent('sd-hitman:server:payPlayer', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local hitmanrep = player.PlayerData.metadata['hitmanrep']
    if not player then return end

    player.Functions.AddItem('black_money', 5000)
    player.Functions.SetMetaData('hitmanrep',  (hitmanrep + 2))
    TriggerClientEvent('QBCore:Notify', src, 'You have been paid $5,000 for completing the hit.', 'success')
end)

RegisterNetEvent('sd-hitman:server:payPlayer2', function(profile)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local hitmanrep = player.PlayerData.metadata['hitmanrep']
    if not player then return end

    local payouts = {
        low = 750,
        medium = 1500,
        high = 2500
    }
    
    local payment = payouts[profile] or 0
    player.Functions.AddItem('black_money', payment)
    player.Functions.SetMetaData('hitmanrep',  (hitmanrep + 1))
    TriggerClientEvent('QBCore:Notify', src, 'You have been paid $' .. payment .. ' for completing the hit.', 'success')
end)

RegisterNetEvent('sd-hitman:server:putOnCooldown', function()
    local src = source
    TriggerClientEvent('sd-hitman:client:applyCooldown', src)
end)
