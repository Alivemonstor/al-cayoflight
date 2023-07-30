# al-cayoflight

## If you use QBCore here's a target for both the Cayo flight and LSA flight

```
CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = 's_m_m_pilot_01',
        coords = vector4(-951.9, -2977.55, 13.94, 67.1),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = 'WORLD_HUMAN_AA_SMOKE',
        target = {
            options = {
                {
                    type = 'client',
                    event = 'al-cayoflight:takeoffLSA',
                    icon = 'fas fa-plane',
                    label = 'Let\'s have the flight to paradise!',
                },
            },
            distance = 2.5,
        },
    })
    exports['qb-target']:SpawnPed({
        model = 's_m_m_pilot_01',
        coords = vector4(4432.96, -4498.7, 3.2, 67.1),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = 'WORLD_HUMAN_AA_SMOKE',
        target = {
            options = {
                {
                    type = 'client',
                    event = 'al-cayoflight:takeoffCayo',
                    icon = 'fas fa-plane',
                    label = 'Let\'s have the flight home!',
                },
            },
            distance = 2.5,
        },
    })
end)
```

