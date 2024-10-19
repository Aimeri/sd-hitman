local blip, radius, ped
local hasPhoto = false
local startTime = nil
local challengeDuration = 0
local lastHitAttempt = 0
local playerData = QBCore.Functions.GetPlayerData()
local challengeCooldown = 7200000
local cooldowns = {
    low = 900000,
    medium = 1800000,
    high = 3600000
}
local isCelebrityHit = false
local profile = nil

local function startHit(profileType, isCelebrity)
    local currentTime = GetGameTimer()
    local cooldown = cooldowns[profileType]
    profile = profileType

    local location = Config.Locations[math.random(1, #Config.Locations)]
    local pedData = Config.Peds[math.random(1, #Config.Peds)]
    local pedModel = GetHashKey(pedData.model)

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(100)
    end

    print("Creating ped at location: ", location.x, location.y, location.z)

    blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip, 1)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    radius = AddBlipForRadius(location.x, location.y, location.z, 40.0)
    SetBlipAlpha(radius, 150)
    SetBlipColour(radius, 1)

    local targetType = isCelebrity and "celebrity" or "normal"
    QBCore.Functions.Notify('A ' .. targetType .. ' target has been marked', 'warning', 5000)

    ped = CreatePed(5, pedModel, location.x, location.y, location.z, location.w, true, true)

    if DoesEntityExist(ped) then
        print("Ped successfully created")

        GiveWeaponToPed(ped, GetHashKey("WEAPON_HEAVYPISTOL"), 250, false, true)
        SetPedFiringPattern(ped, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAttributes(ped, 5, true)
        SetPedCombatAttributes(ped, 0, true)
        SetPedCombatAbility(ped, 100)
        SetPedCombatMovement(ped, 3)
        SetPedConfigFlag(ped, 183, true)
        SetPedConfigFlag(ped, 4, true)
        TaskCombatHatedTargetsAroundPed(ped, 100.0, 0)
        SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))

        local bodyguardCount = 0
        if profileType == "medium" then
            bodyguardCount = 1
        elseif profileType == "high" then
            bodyguardCount = 2
        elseif isCelebrity then
            bodyguardCount = 3
        end

        if bodyguardCount > 0 then
            local bodyguardModel = GetHashKey("s_m_m_highsec_01")
            RequestModel(bodyguardModel)
            while not HasModelLoaded(bodyguardModel) do
                Wait(100)
            end

            for i = 1, bodyguardCount do
                local randomX = math.random(-12, 12)
                local randomY = math.random(-12, 12)
                local bodyguardX = location.x + randomX
                local bodyguardY = location.y + randomY

                local bodyguard = CreatePed(5, bodyguardModel, bodyguardX, bodyguardY, location.z, location.w, true, true)
                SetPedCombatAttributes(bodyguard, 46, true)
                SetPedCombatAttributes(bodyguard, 5, true)
                SetPedCombatAttributes(bodyguard, 0, true)
                SetPedCombatAbility(bodyguard, 100)
                SetPedCombatMovement(bodyguard, 3)
                SetPedConfigFlag(bodyguard, 183, true)
                SetPedConfigFlag(bodyguard, 4, true)
                SetPedFiringPattern(bodyguard, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
                GiveWeaponToPed(bodyguard, GetHashKey("WEAPON_SMG"), 250, false, true)
                SetPedRelationshipGroupHash(bodyguard, GetHashKey("HATES_PLAYER"))
                TaskCombatHatedTargetsAroundPed(bodyguard, 100.0, 0)
            end

            QBCore.Functions.Notify('Target is guarded by ' .. bodyguardCount .. ' bodyguard(s)!', 'info', 5000)
        end

        CreateThread(function()
            while DoesEntityExist(ped) do
                Wait(1000)
                if IsPedDeadOrDying(ped, true) then
                    exports['qb-target']:AddTargetEntity(ped, {
                        options = {
                            {
                                type = "client",
                                event = "sd-hitman:client:takePhotoAction",
                                icon = "fa-solid fa-camera",
                                label = "Take photo of the target",
                            }
                        },
                        distance = 2.5
                    })
                    break
                end
            end
        end)

        if isCelebrity then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local locationCoords = vector3(location.x, location.y, location.z)
            local distance = #(playerCoords - locationCoords)
            if distance < 500 then
                challengeDuration = math.random(240000)
                QBCore.Functions.Notify('You have 4 minutes to kill the target.', 'warning', 5000)
            else
                challengeDuration = math.random(600000)
                QBCore.Functions.Notify('You have 10 minutes to kill the target.', 'warning', 5000)
            end
            startTime = GetGameTimer()
            isCelebrityHit = true
        else
            isCelebrityHit = false
        end
        lastHitAttempt = currentTime
    else
        print("Failed to create ped")
    end
end

RegisterNetEvent('sd-hitman:client:startCelebrityHit', function()
    if lastHitAttempt ~= 0 then
        local currentTime = GetGameTimer()
        if currentTime - lastHitAttempt < challengeCooldown then
            QBCore.Functions.Notify('You must wait 2 hours before starting another hit.', 'error', 5000)
            return
        end
    end

    local playerMoney = QBCore.Functions.GetPlayerData().money['cash']

    if playerMoney < 500 then
        QBCore.Functions.Notify('You need $500 to start a Celebrity Hit.', 'error', 5000)
        return
    end

    TriggerServerEvent('sd-hitman:server:deductPayment', 5000)

    startHit('celebrity', true)

    CreateThread(function()
        lastHitAttempt = GetGameTimer()
        Wait(7200000)
        lastHitAttempt = 0
    end)
end)


RegisterNetEvent('sd-hitman:client:takePhotoAction', function()
    local playerPed = PlayerPedId()
    
    RequestAnimDict('amb@world_human_paparazzi@male@idle_a')
    while not HasAnimDictLoaded('amb@world_human_paparazzi@male@idle_a') do
        Wait(100)
    end

    TaskPlayAnim(playerPed, 'amb@world_human_paparazzi@male@idle_a', 'idle_a', 8.0, -8.0, -1, 50, 0, false, false, false)
    
    local cameraHash = GetHashKey('prop_pap_camera_01')
    RequestModel(cameraHash)
    while not HasModelLoaded(cameraHash) do
        Wait(100)
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local camera = CreateObject(cameraHash, playerCoords.x, playerCoords.y, playerCoords.z + 1.0, true, true, true)
    
    AttachEntityToEntity(camera, playerPed, GetPedBoneIndex(playerPed, 28422), 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    Wait(2000)
    DeleteObject(camera)
    ClearPedTasks(playerPed)
    QBCore.Functions.Notify('Photo taken! Return to the original location to get paid.', 'success', 5000)
    hasPhoto = true
    
    if DoesEntityExist(ped) then
        if IsPedDeadOrDying(ped, 1) then
            DeleteEntity(ped)
        end
    end

    if DoesEntityExist(bodyguard) then
        if IsPedDeadOrDying(bodyguard, 1) then
            DeleteEntity(bodyguard)
        end
    end

end)


RegisterNetEvent('sd-hitman:client:openMenu', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local hitmanRep = playerData.metadata.hitmanrep

    local options = {
        {
            icon = "fa-solid fa-gun", 
            iconColor = '#5ff5b4',
            title = 'Hit Rep: ' .. hitmanRep
        },
        {
            icon = "fa-solid fa-skull", 
            iconColor = 'red',
            title = 'Find Hit',
            description = 'Start a new hit mission',
            event = 'sd-hitman:client:openFindHitMenu'
        },
        {
            icon = "fa-solid fa-star",
            iconColor = '#e8b923',
            title = 'Celebrity Hits',
            description = 'High profile targets with timed hits, 2 rep points for a succesful hit + a fat paycheck;)',
            event = 'sd-hitman:client:startCelebrityHit'
        }
    }

    if hasPhoto then
        table.insert(options, {
            icon = "fa-solid fa-money-bill",
            title = 'Get Paid',
            description = 'Collect your payment for the hit',
            event = 'sd-hitman:client:payPlayer'
        })
    end

    lib.registerContext({
        id = 'HitMenu',
        title = 'Hit Menu',
        options = options
    })

    lib.showContext('HitMenu')
end)

RegisterNetEvent('sd-hitman:client:openFindHitMenu', function()
    local playerData = QBCore.Functions.GetPlayerData()
    local hitmanRep = playerData.metadata.hitmanrep

    local options = {
        {
            icon = "fa-solid fa-user-secret",
            title = 'Low Profile Target',
            description = 'Requires at least 0 hitman rep',
            event = 'sd-hitman:client:startLowProfileHit'
        },
        {
            icon = "fa-solid fa-user-tie",
            title = 'Medium Profile Target',
            description = 'Requires at least 50 hitman rep',
            event = 'sd-hitman:client:startMediumProfileHit'
        },
        {
            icon = "fa-solid fa-user-crown",
            title = 'High Profile Target',
            description = 'Requires at least 125 hitman rep',
            event = 'sd-hitman:client:startHighProfileHit'
        }
    }

    if hitmanRep < 50 then
        options[2] = nil
        options[3] = nil
    elseif hitmanRep < 125 then
        options[3] = nil
    end

    lib.registerContext({
        id = 'FindHitMenu',
        title = 'Find Hit Menu',
        options = options
    })

    lib.showContext('FindHitMenu')
end)

RegisterNetEvent('sd-hitman:client:startLowProfileHit', function()
    startHit('low', false)
end)

RegisterNetEvent('sd-hitman:client:startMediumProfileHit', function()
    startHit('medium', false)
end)

RegisterNetEvent('sd-hitman:client:startHighProfileHit', function()
    startHit('high', false)
end)

RegisterNetEvent('sd-hitman:client:payPlayer', function()
    if hasPhoto then
        local profile = profile or "normal"

        if isCelebrityHit then
            local currentTime = GetGameTimer()
            local elapsedTime = currentTime - startTime
            
            if elapsedTime <= challengeDuration then
                TriggerServerEvent('sd-hitman:server:payPlayer', profile)
                QBCore.Functions.Notify('Challenge completed within time limit! You have been paid $5,000.', 'success', 5000)
            else
                TriggerServerEvent('sd-hitman:server:putOnCooldown')
                QBCore.Functions.Notify('Challenge failed. You did not complete the hit within the time limit.', 'error', 5000)
            end
        else
            TriggerServerEvent('sd-hitman:server:payPlayer2', profile)
            QBCore.Functions.Notify('You have been paid for the hit.', 'success', 5000)
        end
        
        if blip then
            RemoveBlip(blip)
            blip = nil
        end
        if radius then
            RemoveBlip(radius)
            radius = nil
        end
        
        hasPhoto = false
    else
        QBCore.Functions.Notify('You need to take a photo of the target first.', 'error', 5000)
    end
end)

RegisterNetEvent('sd-hitman:client:applyCooldown', function(remainingTime)
    QBCore.Functions.Notify('Hey, come back in ' .. remainingTime .. ' seconds.', 'error', 5000)
end)

CreateThread(function()
    local startPed = exports['qb-target']:SpawnPed({
        model = 'a_m_m_hasjew_01',
        coords = Config.Targets.TargetCoords,
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        animDict = 'abigail_mcs_1_concat-0',
        anim = 'csb_abigail_dual-0',
        flag = 1,
        scenario = 'WORLD_HUMAN_AA_COFFEE',
        target = {
            options = {
                {
                    type = "client",
                    event = "sd-hitman:client:openMenu",
                    icon = "fa-solid fa-toilet",
                    label = Config.Targets.TargetLable,
                }
            },
            distance = 2.5,
        },
        spawnNow = true,
        currentpednumber = 0,
    })
end)
