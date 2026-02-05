local spawnedPeds = {}


function ScenesToBitwise(scenes)
    local flags = 0
    for _, sceneNum in ipairs(scenes) do
        flags = flags | (1 << sceneNum)
    end
    return flags
end

local CayoFlightConfig = {
    LSIA_TO_CAYO = {
        cutscene = {{name = 'hs4_nimb_lsa_isd', playbackList = ScenesToBitwise({6,10,11}), endTime = 8000}},
        sceneLoadCoords = vector3(-1303.55, -3160.9, 16.62),
        destinationCoords = vector3(4432.96, -4493.7, 3.2),
        waitTime = 8000,
        target = {
            ped = "s_m_y_ammucity_01",
            coords = vector4(-998.95, -2954.95, 12.94, 119.05),
            options = {
                {
                    icon = 'fas fa-plane-departure',
                    label = 'Take off to Cayo Perico',
                    onSelect = function()
                        takeOffLSIA()
                    end
                }
            }
        }
    },
    CAYO_TO_LSIA = {
        cutscene = {{name = 'hs4_nimb_isd_lsa', playbackList = ScenesToBitwise({3}), endTime = 8000}, {name = "hs4_lsa_land_nimb", playbackList = ScenesToBitwise({0}), endTime = 8000}},
        sceneLoadCoords = vector3(4432.96, -4493.7, 3.2),
        destinationCoords = vector3(-994.61, -2949.04, 13.96),
        target = {
            ped = "s_m_y_ammucity_01",
            coords = vector4(4432.96, -4493.7, 3.2, 158.52),
            options = {
                {
                    icon = 'fas fa-plane-departure',
                    label = 'Take off to Los Santos International Airport',
                    onSelect = function()
                        takeOffCayo()
                    end
                }
            }
        }
    }
}

function playCutsceneTravel(config)
    local playerPed = PlayerPedId()
    local characterModel = 'MP_1'
    
    DoScreenFadeOut(500)
    Wait(2000)
    
    local pedClone = ClonePed(playerPed, false, false, true)
    if not pedClone or not DoesEntityExist(pedClone) then
        print("Failed to clone player ped")
        DoScreenFadeIn(500)
        return false
    end    

    SetEntityCoords(playerPed, config.destinationCoords.x, config.destinationCoords.y, config.destinationCoords.z)
    
    NetworkStartSoloTutorialSession()

    while not NetworkIsInTutorialSession() do
        Wait(100)
    end

    for i, cutsceneData in ipairs(config.cutscene) do
        local cutsceneName = cutsceneData.name
        
        if cutsceneData.playbackList then
            RequestCutsceneWithPlaybackList(cutsceneName, cutsceneData.playbackList, 8)
        else
            RequestCutscene(cutsceneName)
        end
        
        local currTime = GetGameTimer()
        while not HasCutsceneLoaded() and GetGameTimer() - currTime < 10000 do
            Wait(100)
        end

        if not HasCutsceneLoaded() then
            print("Error: Cutscene failed to load")
            DeletePed(pedClone)
            DoScreenFadeIn(500)
            return false
        end

        RegisterEntityForCutscene(pedClone, characterModel, 0, 0, 0)
        SetCutsceneEntityStreamingFlags(characterModel, 0, 1)

        NewLoadSceneStartSphere(config.sceneLoadCoords.x, config.sceneLoadCoords.y, config.sceneLoadCoords.z, 1000, 0)
        
        Wait(500)
        
        StartCutscene(0)


        local currTime = GetGameTimer()
        while not IsCutscenePlaying() and GetGameTimer() - currTime < 5000 do
            Wait(0)
        end
        DoScreenFadeIn(500)

        local currTime = GetGameTimer()
        while not DoesCutsceneEntityExist(characterModel, 0) and GetGameTimer() - currTime < 10000 do
            Wait(100)
        end

        if DoesCutsceneEntityExist(characterModel, 0) then
            ClonePedToTarget(playerPed, pedClone)
        end

        while not HasCutsceneFinished() do
            Wait(0)
        end

        DoScreenFadeOut(0)


        StopCutsceneImmediately()
        RemoveCutscene()
        NetworkEndTutorialSession()

    end
    
    if DoesEntityExist(pedClone) then
        DeletePed(pedClone)
    end

    Wait(500)
    DoScreenFadeIn(500)
    
    return true
end

function takeOffLSIA()
    playCutsceneTravel(CayoFlightConfig.LSIA_TO_CAYO)
end

function takeOffCayo()
    playCutsceneTravel(CayoFlightConfig.CAYO_TO_LSIA)
end

AddEventHandler('esx:onPlayerLoaded', function(playerData)
    for k,v in pairs(CayoFlightConfig) do
        if v.target then
            local pedModel = joaat(v.target.ped)
            lib.requestModel(pedModel)

            spawnedPeds[k] = CreatePed(4, pedModel, v.target.coords.x, v.target.coords.y, v.target.coords.z, v.target.coords.w, false, true)
            SetEntityInvincible(spawnedPeds[k], true)
            SetBlockingOfNonTemporaryEvents(spawnedPeds[k], true)
            FreezeEntityPosition(spawnedPeds[k], true)
            ox_target:addLocalEntity(spawnedPeds[k], v.target.options)
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for k,v in pairs(CayoFlightConfig) do
        if v.target then
            local pedModel = joaat(v.target.ped)
            lib.requestModel(pedModel)

            spawnedPeds[k] = CreatePed(4, pedModel, v.target.coords.x, v.target.coords.y, v.target.coords.z, v.target.coords.w, false, true)
            SetEntityInvincible(spawnedPeds[k], true)
            SetBlockingOfNonTemporaryEvents(spawnedPeds[k], true)
            FreezeEntityPosition(spawnedPeds[k], true)
            ox_target:addLocalEntity(spawnedPeds[k], v.target.options)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for k,v in pairs(spawnedPeds) do
        if DoesEntityExist(v) then
            ox_target:removeLocalEntity(v)
            DeletePed(v)
        end
    end
end)
