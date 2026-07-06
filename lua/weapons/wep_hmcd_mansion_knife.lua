if SERVER then
    resource.AddWorkshop("2484790252") -- mu_hmcd_mansion
    AddCSLuaFile()
end

SWEP.Base = "weapon_melee"
SWEP.PrintName = "Chef Knife"
SWEP.Instructions = "A knife with wooden grip and sharp stainless steel blade. Intended for use in cooking.\n\nLMB to attack.\nRMB to block."
SWEP.Category = "Weapons - Melee"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_knives/w_kitchenknife.mdl"
SWEP.WorldModelReal = "models/mu_hmcd_mansion/weapon_knives/v_kitchenknife.mdl"
SWEP.WorldModelExchange = "models/mu_hmcd_mansion/weapon_knives/w_kitchenknife.mdl"

if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_hmcd_mansion_knife")
    SWEP.IconOverride = "vgui/wep_hmcd_mansion_knife"
end

SWEP.weaponPos = Vector(0.5, 14, 2)
SWEP.weaponAng = Angle(-45, 0, -90)
SWEP.attack_ang = Angle(-55, -3, 0)
SWEP.sprint_ang = Angle(30, 0, 0)
SWEP.basebone = 43
SWEP.BreakBoneMul = 0.15

SWEP.AnimList = {
    ["idle"] = "idle",
    ["deploy"] = "draw",
    ["attack"] = "attack_fancy",
    ["attack2"] = "attack_fancy",
}

if CLIENT then
    SWEP.BounceWeaponIcon = false
end

SWEP.setlh = false
SWEP.setrh = true
SWEP.TwoHanded = false
SWEP.NoHolster = false

SWEP.HoldPos = Vector(-10, 3, -2)
SWEP.HoldAng = Angle(-10, 5, 0)
SWEP.AttackPos = Vector(0, 0, -10)
SWEP.HoldType = "knife"

SWEP.DamageType = DMG_SLASH
SWEP.DamagePrimary = 10
SWEP.DamageSecondary = 8
SWEP.PenetrationPrimary = 1.5
SWEP.PenetrationSecondary = 1.0
SWEP.MaxPenLen = 3
SWEP.PainMultiplier = 0.5
SWEP.PenetrationSizePrimary = 0.8
SWEP.PenetrationSizeSecondary = 1.5
SWEP.StaminaPrimary = 6
SWEP.StaminaSecondary = 5
SWEP.AttackLen1 = 65
SWEP.AttackLen2 = 55

SWEP.AttackSwing = "weapons/slam/throw.wav"
SWEP.AttackHit = "snd_jack_hmcd_knifehit.wav"
SWEP.Attack2Hit = "snd_jack_hmcd_knifehit.wav"
SWEP.AttackHitFlesh = "snd_jack_hmcd_slash.wav"
SWEP.Attack2HitFlesh = "snd_jack_hmcd_slash.wav"
SWEP.DeploySnd = "snd_jack_hmcd_knifedraw.wav"

SWEP.weight = 0.5

function SWEP:CanSecondaryAttack()
    return false
end

SWEP.CanSuicide = true
SWEP.SuicidePos = Vector(5, -13.30, -14.85)
SWEP.SuicideAng = Angle(-71.89, 71.30, 6.66)

SWEP.AttackTimeLength = 0.15
SWEP.Attack2TimeLength = 0.1

SWEP.AnimTime1 = 0.75
SWEP.AttackTime = 0.15
SWEP.WaitTime1 = 0.6

SWEP.AnimTime2 = 0.75
SWEP.Attack2Time = 0.15
SWEP.WaitTime2 = 0.6

SWEP.AttackRads = 65
SWEP.AttackRads2 = 65

SWEP.SwingAng = 0
SWEP.SwingAng2 = 0
