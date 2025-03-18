local isPunchBoostActive = false

RegisterNetEvent('brad-punchboost:setPunchBoost')
AddEventHandler('brad-punchboost:setPunchBoost', function(state)
    isPunchBoostActive = state

    if state then
        lib.notify({ type = 'success', description = 'Punch Boost activé !' })
    else
        lib.notify({ type = 'error', description = 'Punch Boost désactivé.' })
    end
end)

-- Amélioration des dégâts de coups de poing
CreateThread(function()
    while true do
        if isPunchBoostActive then
            local playerPed = PlayerPedId()

            -- Augmente la force des coups de poing
            SetPedCanRagdollFromPlayerImpact(playerPed, false)
            SetWeaponDamageModifierThisFrame(`WEAPON_UNARMED`, 10.0) -- Multiplie les dégâts par 10

            -- Détection des coups
            if IsControlJustPressed(0, 140) then -- 140 = Coup de poing
                local _, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

                if DoesEntityExist(entity) then
                    -- Si c'est un joueur
                    if IsEntityAPed(entity) and IsPedAPlayer(entity) then
                        ApplyDamageToPed(entity, 100, false, true, true) -- Inflige 100 de dégâts (quasi one-shot)
                    end

                    -- Si c'est un véhicule
                    if IsEntityAVehicle(entity) then
                        local velocity = GetEntityVelocity(entity)
                        ApplyForceToEntity(entity, 1, velocity.x * 100.0, velocity.y * 100.0, velocity.z * 100.0, 0, 0, 0, false, true, true, false, true, true)
                    end
                end
            end
        end
        Wait(0)
    end
end)
