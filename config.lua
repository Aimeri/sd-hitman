QBCore = exports['qb-core']:GetCoreObject()

Config = {}

-- Hitman Target Locations
Config.Locations = {
    vector4(-193.28, -1634.68, 32.37, 229.25),
    vector4(235.72, -1714.74, 28.02, 21.27),
    vector4(124.84, -1071.78, 28.19, 109.09),
    vector4(882.85, -40.33, 77.76, 50.81),
    vector4(280.8, 169.57, 103.46, 74.65),
    vector4(-1640.21, -894.67, 7.85, 192.51),
    vector4(1621.18, 3699.2, 33.32, 312.27),
    vector4(2123.87, 4804.38, 40.2, 322.93),
    vector4(-115.89, 6452.02, 30.4, 337.8),
    vector4(-144.98, 6355.41, 31.49, 177.57),
    vector4(-57.33, 6160.47, 30.9, 76.64),
    vector4(1564.45, 3572.85, 33.69, 117.83),
    vector4(2388.76, 3325.01, 47.8, 323.14),
    vector4(3631.67, 3757.51, 28.52, 40.26),
    vector4(3592.15, 3719.14, 36.38, 20.0),
    vector4(2307.82, 4887.74, 41.81, 81.2),
    vector4(-1915.06, 2059.1, 140.74, 219.44),
    vector4(-1861.67, 2076.98, 140.99, 182.18),
    vector4(-2308.24, 263.02, 169.6, 30.18),
    vector4(-2234.72, 268.51, 174.62, 39.38),
    vector4(-427.07, 1115.67, 326.78, 352.12),
    vector4(199.17, 1165.84, 227.0, 103.18),
    vector4(686.29, 577.94, 130.46, 148.98),
    vector4(-260.83, -1893.42, 27.76, 321.66),
    vector4(148.64, -2995.44, 7.03, 299.46),

}

-- Ped configurations
Config.Peds = {
    { model = "s_m_m_armoured_01", description = "Frank Santo, A crooked cop. Green shirt, black vest. Find him." },
    { model = "s_m_m_autoshop_02", description = "Peno Tino, A greasy mechanic. Grey overalls, greasy hair. Fucker charged me $200 for a oil change..." },
    { model = "s_m_m_fibsec_01", description = "Rowdy Trimble, A crooked FBI agent. FIB vest, put my brother away for life." },
    { model = "s_m_y_clown_01", description = "Coco Clown, A creepy clown. You know what to do..." },
    { model = "s_m_y_prismuscl_01", description = "OG Papa, Fuck this guys out of jail? He must still be wearing his jail clothes..." },
    { model = "ig_claypain", description = "Crip Cilla, A OG in the hood, Red cap, red shirt, blood him up blood..." },
    { model = "ig_maryann", description = "Mary Ann, Normally wearing blue sports wear, she broke my heart..." },
    { model = "ig_trafficwarden", description = "TRod DRod, A fucking ticket officer, gave me a $50 fine for parking legally!..." },
    { model = "u_f_y_danceburl_01", description = "Slay Sally, This stripper gave me the clap..." },
    { model = "u_f_m_corpse_01", description = "Megan Cogar, A bitch i just shot, somehow shes alive. Wearing a blue robe..." },
    { model = "u_m_y_babyd", description = "Buff Brad, Bitch wooped my ass at the beach. This guy NEVER wears a shirt..." },
    { model = "u_m_y_mani", description = "Mani Carlito, Fucker owes me money! Wearing a mexican hat!..." },
    { model = "cs_tracydisanto", description = "Tracy DiSanto, My boy michaels daughter, Bitch didnt finish me off..." },
    { model = "cs_wade", description = "Wade O-Neal, What a bitch... Guy only wears black & red..." },
    { model = "cs_orleans", description = "Big Foot, Yeah this guy just dresses up as bigfoot all day..." },
    { model = "mp_f_stripperlite", description = "Mami Lite, She snapped my glasses!..." },
}

Config.Targets = {
    TargetLable = "Speak to ?",
    TargetCoords = vector4(-310.42, 222.65, 87.93, 15.63),
}

Config.WaitTime = math.random(5000, 10000)
