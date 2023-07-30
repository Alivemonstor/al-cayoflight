
RegisterNetEvent('al-cayoflight:takeoffLSA', function()
    DoScreenFadeOut(500)
    Wait(2000)
    DoScreenFadeIn(1000)    
    local plyrId = PlayerPedId()
    local thisCutsceneName = 'hs4_lsa_take_vel'
	local charName = 'MP_1'
    local clone = ClonePed(plyrId, false, false, true)

    RequestCutscene(thisCutsceneName)
    while not HasCutsceneLoaded() do Wait(10) end 
    RegisterEntityForCutscene(clone, charName, 0, 0, 0)
    SetCutsceneEntityStreamingFlags(charName, 0, 1) 
    StartCutscene(0)

	NewLoadSceneStartSphere(-1303.55, -3160.9, 16.62, 1000, 0)


    StartCutscene(0)
    SetEntityCoords(plyrId, vector3(4432.96, -4493.7, 3.2))

    
    while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
    end

    ClonePedToTarget(plyrId, clone)

    Wait(12000)
    DoScreenFadeOut(500)
    Wait(2000)
    StopCutsceneImmediately()
    DoScreenFadeIn(500)    
end) 


RegisterNetEvent('al-cayoflight:takeoffCayo', function()
    DoScreenFadeOut(500)
    Wait(2000)
    DoScreenFadeIn(500) 
    local plyrId = PlayerPedId()
    local thisCutsceneName = 'hs4_lsa_land_vel'
	local charName = 'MP_1'
    local clone = ClonePed(plyrId, false, false, true)

    RequestCutscene(thisCutsceneName)
    while not HasCutsceneLoaded() do Wait(10) end 
    RegisterEntityForCutscene(clone, charName, 0, 0, 0)
    SetCutsceneEntityStreamingFlags(charName, 0, 1) 
    StartCutscene(0)

	NewLoadSceneStartSphere(4432.96, -4493.7, 3.2, 1000, 0)

    DoScreenFadeIn(500)
    StartCutscene(0)
    SetEntityCoords(plyrId, vector3(-994.61, -2949.04, 13.96))

    
    while not (DoesCutsceneEntityExist('MP_1', 0)) do
        Wait(0)
    end

    ClonePedToTarget(plyrId, clone)

    Wait(10000)
    DoScreenFadeOut(500)
    Wait(2000)
    StopCutsceneImmediately()
    DoScreenFadeIn(500)    
end) 


