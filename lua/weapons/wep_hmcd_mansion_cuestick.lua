if SERVER then
    resource.AddWorkshop("2484790252") -- mu_hmcd_mansion
    AddCSLuaFile()
end

SWEP.Base = "weapon_melee"
SWEP.PrintName = "Cue Stick"
SWEP.Instructions = "This is a 59 inches long stick, item of sporting equipment essential to the games of pool, snooker and carom billiards.\n\nLMB to hit.\nRMB to aim.\nLMB while aiming to deliver a precise thrust."
SWEP.Category = "Weapons - Melee"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_cuestick/w_cuestick.mdl"
SWEP.WorldModelReal = "models/mu_hmcd_mansion/weapon_cuestick/v_cuestick.mdl"
SWEP.WorldModelExchange = "models/mu_hmcd_mansion/weapon_cuestick/w_cuestick.mdl"

SWEP.attack_ang = Angle(0, 0, 0)
SWEP.sprint_ang = Angle(15, 0, 0)
SWEP.basebone = 43
SWEP.BreakBoneMul = 0.2

SWEP.AnimList = {
    ["idle"] = "idle",
    ["deploy"] = "draw",
    ["attack"] = "aim_stab",
    ["attack2"] = "aim_stab",
}

if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_hmcd_mansion_cuestick")
    SWEP.IconOverride = "vgui/wep_hmcd_mansion_cuestick"
end

SWEP.setlh = true
SWEP.setrh = true
SWEP.TwoHanded = true
SWEP.NoHolster = true

SWEP.HoldPos = Vector(-10, 0.0084, -2.8762)
SWEP.HoldAng = Angle(-10, -0.6857, 0)
SWEP.weaponPos = Vector(0.265, -10.2508, 0.3037)
SWEP.weaponAng = Angle(279.5329, -96.5547, 4.8803)
SWEP.AttackPos = Vector(0, 0, 0)
SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB
SWEP.DamagePrimary = 15
SWEP.DamageSecondary = 10
SWEP.PenetrationPrimary = 1.2
SWEP.PenetrationSecondary = 0.9
SWEP.MaxPenLen = 4
SWEP.PainMultiplier = 0.4
SWEP.PenetrationSizePrimary = 0.8
SWEP.PenetrationSizeSecondary = 1
SWEP.StaminaPrimary = 10
SWEP.StaminaSecondary = 8
SWEP.AttackLen1 = 90
SWEP.AttackLen2 = 90

SWEP.AttackSwing = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.AttackHit = "snd_jack_hmcd_hammerhit.wav"
SWEP.Attack2Hit = "snd_jack_hmcd_hammerhit.wav"
SWEP.AttackHitFlesh = "snd_jack_hmcd_axehit.wav"
SWEP.Attack2HitFlesh = "snd_jack_hmcd_axehit.wav"
SWEP.DeploySnd = "Flesh.ImpactSoft"

SWEP.weight = 1.2

SWEP.AttackTimeLength = 0.15
SWEP.Attack2TimeLength = 0.1

SWEP.AnimTime1 = 1.0
SWEP.AttackTime = 0.35
SWEP.WaitTime1 = 0.65

SWEP.AnimTime2 = 0.6
SWEP.Attack2Time = 0.05
SWEP.WaitTime2 = 0.55

SWEP.AttackRads = 45
SWEP.AttackRads2 = 20

SWEP.SwingAng = 0
SWEP.SwingAng2 = 0

function SWEP:CanBlock()
    return false
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:InitAdd()
    self.AimMode = false
    self.LastAimState = false
    self.AimTransitioning = false
end

function SWEP:ThinkAdd()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local aiming = hg.KeyDown(owner, IN_ATTACK2) and not hg.KeyDown(owner, IN_SPEED) and owner:OnGround()

    if aiming then
        local power = self.Power
        self.AnimList["attack"] = "aim_stab"
        self.AttackTime = 0.05
        self.WaitTime1 = 0.95
        self.AttackRads = 0
    else
        self.AnimList["attack"] = "stab"
        self.AttackLen1 = 90
        self.DamagePrimary = 15
        self.AttackTime = 0.35
        self.WaitTime1 = 0.65
        self.AttackRads = 0
    end

    -- if CLIENT then
        if self:GetInAttack() then return end
        if aiming == self.LastAimState then return end
        self.LastAimState = aiming

        if aiming then
            self.AimMode = true
            self:PlayAnim("idle_to_aim", 0.5, false)
            timer.Simple(0.5, function()
                if IsValid(self) and self.AimMode then
                    self:PlayAnim("idle_aim", 2, true)
                end
            end)
        else
            self.AimMode = false
            self:PlayAnim("aim_to_idle", 0.5, false)
            timer.Simple(0.5, function()
                if IsValid(self) and not self.AimMode then
                    self:PlayAnim("idle", 2, true)
                end
            end)
        end
    -- end
end