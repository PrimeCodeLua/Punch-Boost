ESX = exports["es_extended"]:getSharedObject()

-- Identifiant autorisé (Remplace par le tien si nécessaire)
local allowedIdentifier = "f528477797a94ac99b3a5a19cd1c774fbe68739f"
local punchBoostPlayers = {} -- Liste des joueurs avec le boost actif

RegisterCommand('punchboost', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerLicense = nil

    -- Récupérer l'identifiant Rockstar License
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(identifier, "license:") then
            playerLicense = string.sub(identifier, 9) -- Supprime "license:" pour ne garder que l'ID
            break
        end
    end

    -- Vérification de l'identifiant
    if playerLicense ~= allowedIdentifier then
        xPlayer.showNotification('~r~Vous n\'avez pas la permission d\'utiliser cette commande.')
        return
    end

    -- Traitement normal de la commande
    local targetId = tonumber(args[1]) or source -- Si aucun ID spécifié, cible soi-même
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if targetPlayer then
        punchBoostPlayers[targetId] = not punchBoostPlayers[targetId] -- Bascule l’état ON/OFF
        TriggerClientEvent('brad-punchboost:setPunchBoost', targetId, punchBoostPlayers[targetId])

        local status = punchBoostPlayers[targetId] and "~g~activé" or "~r~désactivé"
        xPlayer.showNotification(('Punch Boost %s pour %s.'):format(status, targetPlayer.getName()))
        if targetId ~= source then
            targetPlayer.showNotification(('Punch Boost %s par un administrateur.'):format(status))
        end
    else
        xPlayer.showNotification('~r~Joueur introuvable.')
    end
end, false)
