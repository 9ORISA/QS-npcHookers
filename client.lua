local hookerPeds = {}
local prgress = "none"
local notify = true
local QBCore = exports['qb-core']:GetCoreObject()
local lang = Languages[Config.Language]

function Notify(titleKey, messageKey, type, duration, ...)
    local title = lang[titleKey] or titleKey
    local message = string.format(lang[messageKey] or messageKey, ...)
    
    if notify and Config.UseQBCore and QBCore and QBCore.Functions and QBCore.Functions.Notify then
        QBCore.Functions.Notify(message, type, duration or 5000)
    end
    if Config.Debug then
        print(("[%s] %s: %s"):format(type, title, message))
    end
end


function GetRandomHookerModel()
    local models = {}
    for model in pairs(Config.HookerPedModels) do
        table.insert(models, model)
    end
    return models[math.random(#models)]
end

function CreateHookerPeds()
    for _, loc in ipairs(Config.HookerSpawnLocations) do
        local model = GetRandomHookerModel()
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local ped = CreatePed(4, model, loc.x, loc.y, loc.z - 1.0, 0.0, true, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedFleeAttributes(ped, 0, 0)
        SetPedCombatAttributes(ped, 17, 1)
        FreezeEntityPosition(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, true)

        AddTargetToPed(ped)
        table.insert(hookerPeds, {
            ped = ped,
            spawnPos = vector3(loc.x, loc.y, loc.z)
        })
    end
end

function AddTargetToPed(ped)
    if IsPedAPlayer(ped) then return end

    local options = {}
    for _, anim in ipairs(Config.Animations) do
        table.insert(options, {
            icon = anim.icon,
            label = anim.label .. " ($" .. anim.price .. ")",
            action = function()
                MakeHookerFollowPlayer(ped, anim)
            end,
            canInteract = function()
                return not IsPedInAnyVehicle(PlayerPedId(), false)
            end
        })
    end

    exports[Config.Target]:AddTargetEntity(ped, {
        options = options,
        distance = 2.0
    })
end

function MakeHookerFollowPlayer(ped, animData)
    local playerPed = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData.money.cash < animData.price then
        Notify("title_oops", "not_enough_money", "error")
        PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
        return
    end

    local veh = GetNearestVehicle()
    if not veh or #(GetEntityCoords(playerPed) - GetEntityCoords(veh)) > 10.0 then
        Notify("title_error", "no_vehicle_near", "error")
        PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
        return
    end

    Notify("title_selection", "selected_hooker", "success", nil, animData.label, animData.price)

    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
    TaskFollowToOffsetOfEntity(ped, playerPed, 0.5, 0.0, 0.0, 2.5, -1, 2.0, true)

    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then break end

            if IsPedInAnyVehicle(playerPed, false) then
                local veh = GetVehiclePedIsIn(playerPed, false)

                if GetPedInVehicleSeat(veh, -1) ~= playerPed then
                    Notify("title_error", "error_driver", "error")
                    PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
                    break
                end

                local vehModel = GetEntityModel(veh)
                if Config.BlacklistedVehicles[vehModel] then
                    Notify("title_error", "error_blacklisted_vehicle", "error")
                    PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
                    break
                end

                if GetEntityHealth(veh) < 400 then
                    Notify("title_error", "error_vehicle_health", "error")
                    PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
                    break
                end

                local seat = GetFrontPassengerSeat(veh)
                if seat == -2 then
                    Notify("title_error", "error_seat", "error")
                    PlayHookerSpeach(ped, "GENERIC_NO", "SPEECH_PARAMS_FORCE")
                    break
                end

                TaskEnterVehicle(ped, veh, -1, seat, 2.0, 1, 0)
                PlayPedAmbientSpeechNative(ped, "GENERIC_HI", "SPEECH_PARAMS_FORCE")

                local timeout = 0
                while not IsPedInVehicle(ped, veh, false) and timeout < 50 do
                    Wait(100)
                    timeout = timeout + 1
                end

                if IsPedInVehicle(ped, veh, false) then
                    TriggerServerEvent("tx_hooker:charge", animData.price)
                    StartVehicleInteraction(playerPed, ped, animData)
                end
                break
            end
        end
    end)
end


function GetFrontPassengerSeat(vehicle)
    if IsVehicleSeatFree(vehicle, 0) then return 0 end
    return -2
end

function GetPedGender(ped)
    if GetEntityModel(ped) == `mp_f_freemode_01` then
        return "female"
    else
        return "male"
    end
end

function StartVehicleInteraction(playerPed, ped, animData)
    if Config.UseQBCore and QBCore and QBCore.Functions then
        prgress = "started"
        QBCore.Functions.Progressbar("vehicle_animation", lang["enjoying_time"], animData.duration, false, true, {}, {}, {}, {}, function()
            prgress = "stopped"
            Notify("title_complete", "interaction_complete", "success")
        end)
    else
        Wait(animData.duration)
    end
    TriggerEvent("QS_hooker:logToDiscord", animData.label, animData.price)

    RequestAnimDict(animData.animDict)
    while not HasAnimDictLoaded(animData.animDict) do Wait(0) end

    TaskPlayAnim(playerPed, animData.animDict, animData.anim1, 8.0, -8.0, animData.duration, 1, 0, false, false, false)
    TaskPlayAnim(ped, animData.animDict, animData.anim2, 8.0, -8.0, animData.duration, 1, 0, false, false, false)

    -- Speech
    local gender = GetPedGender(ped)
    local speechName = "SEX_GENERIC"
    if animData.name == "hooker_blowjob" then
        speechName = (gender == "male") and "SEX_ORAL" or "SEX_ORAL_FEM"
    elseif animData.name == "hooker_sex" then
        speechName = (gender == "male") and "SEX_GENERIC" or "SEX_GENERIC_FEM"
    end

    Wait(animData.duration)

    PlayHookerSpeach(ped, "HOOKER_LEAVES_ANGRY", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
    TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
    Wait(2500)

    local pedData = GetHookerDataByPed(ped)
    if pedData then
        TaskGoStraightToCoord(ped, pedData.spawnPos.x, pedData.spawnPos.y, pedData.spawnPos.z, 1.0, -1, 0.0, 0.0)
        Wait(7000)
        ClearPedTasks(ped)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, true)
    end
end

function GetHookerDataByPed(ped)
    for _, data in ipairs(hookerPeds) do
        if data.ped == ped then
            return data
        end
    end
    return nil
end

function PlayHookerSpeach(hooker, speechName, speechParam)
    if not IsAnySpeechPlaying(hooker) then
        PlayPedAmbientSpeechNative(hooker, speechName, speechParam)
        if Config.Debug then
            print("[Voice] Hooker says: " .. speechName .. " with param " .. speechParam)
        end
    end
end

Citizen.CreateThread(function()
    Wait(5000)
    CreateHookerPeds()
end)

RegisterNetEvent("QS_hooker:logToDiscord", function(animLabel, price)
    local playerPed = PlayerPedId()
    local playerName = GetPlayerName(PlayerId())
    local logConfig = Config.Logs.Hooker

    if Config.Logs.Hooker.screenshot then
        exports['screenshot-basic']:requestScreenshotUpload(logConfig.webhook, "files[]", {
            encoding = "png",
            quality = 1
        }, function(data)
            local resp = json.decode(data)
            if resp.attachments and resp.attachments[1] then
                TriggerServerEvent("QS_hooker:sendLogToDiscord", playerName, animLabel, price, resp.attachments[1].url)
            else
                TriggerServerEvent("QS_hooker:sendLogToDiscord", playerName, animLabel, price, nil)
            end
        end)
    else
        TriggerServerEvent("QS_hooker:sendLogToDiscord", playerName, animLabel, price, nil)
    end
end)

function GetNearestVehicle()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local vehicles = GetGamePool("CVehicle")
    local closestVeh, closestDist = nil, 999.0

    for _, veh in ipairs(vehicles) do
        local dist = #(coords - GetEntityCoords(veh))
        if dist < closestDist then
            closestVeh = veh
            closestDist = dist
        end
    end

    return closestVeh
end
