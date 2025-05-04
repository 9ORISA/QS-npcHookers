Config = {}
Config.UseQBCore = true
Config.Debug = true
Config.Language = "en" 
Config.Target = 'qb-target' -- or 'ox_target'
Config.Logs = {
    Hooker = {
        webhook = "ChangeMe",
        screenshot = true, 
        username = "💄 Hooker Logs",
        avatar = "https://media.discordapp.net/attachments/1368571144675786844/1368579236868133044/LogoQS.png",
        title = "💋 Qs Hooker Service Used",
        color = 16711900, -- Pink
        footer = "Qrisa Store - Hooker Log",
    }
}

Config.HookerPedModels = {
    [`s_f_y_hooker_01`] = true,
    [`s_f_y_hooker_02`] = true,
    [`s_f_y_hooker_03`] = true,
    [`a_f_m_beach_01`] = true,
    [`a_f_y_beach_01`] = true,
    [`a_f_m_bodybuild_01`] = true,
    [`csb_stripper_01`] = true,
    [`csb_stripper_02`] = true,
    [`mp_f_stripperlite`] = true,
    [`s_f_y_stripper_01`] = true,
    [`s_f_y_stripper_02`] = true,
    [`s_f_y_stripperlite`] = true
}

Config.HookerSpawnLocations = {
    vector3(123.45, -1234.56, 29.28),
    vector3(345.67, -987.65, 29.32),
    vector3(567.89, -765.43, 29.45)
}

Config.BlacklistedVehicles = {
    [`police`] = true,
    [`ambulance`] = true,
    [`firetruk`] = true,
    [`riot`] = true
}

Config.Animations = {
    {
        icon = "👅", 
        name = "hooker_blowjob", 
        label = "Blowjob", 
        animDict = "oddjobs@towing",
        anim1 = "m_blow_job_loop",
        anim2 = "f_blow_job_loop",
        distance = 0.5,
        duration = 20000,
        price = 20,
        scenario = false
    },
    {
        icon = "🔥", 
        name = "hooker_sex", 
        label = "Sex", 
        animDict = "mini@prostitutes@sexnorm_veh",
        anim1 = "sex_loop_male",
        anim2 = "sex_loop_prostitute",
        distance = 0.5,
        duration = 50000,
        price = 50,
        scenario = false
    },
}
