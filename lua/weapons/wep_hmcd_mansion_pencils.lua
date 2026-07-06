if SERVER then
    resource.AddWorkshop("2484790252") -- mu_hmcd_mansion
    AddCSLuaFile()
end

SWEP.Base = "weapon_melee"
SWEP.PrintName = "Pencil"
SWEP.Instructions = "This is your magical pencil, it can change its color to another, just think about it. Use it to draw something.\n\nHOLD RELOAD to open color menu.\nLMB to swing while in attack mode.\nRMB + RELOAD to change between modes."
SWEP.Category = "Weapons - Melee"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.WorldModel = "models/mu_hmcd_mansion/weapon_pencils/w_pencil.mdl"
SWEP.WorldModelReal = "models/mu_hmcd_mansion/weapon_pencils/v_pencil.mdl"
SWEP.WorldModelExchange = "models/mu_hmcd_mansion/weapon_pencils/w_pencil.mdl"

SWEP.weaponPos = Vector(0.7244, -2.1373, 1.334)
SWEP.weaponAng = Angle(-109.4992, -90, 0)
SWEP.attack_ang = Angle(-55, -3, 0)
SWEP.sprint_ang = Angle(30, 0, 0)
SWEP.basebone = 43
SWEP.BreakBoneMul = 0.1

SWEP.AnimList = {
    ["idle"] = "idle_attack",
    ["deploy"] = "draw_attack",
    ["attack"] = "attack"
}

if CLIENT then
    SWEP.BounceWeaponIcon = false
    SWEP.WepSelectIcon = surface.GetTextureID("vgui/wep_hmcd_mansion_pencils")
    SWEP.IconOverride = "vgui/wep_hmcd_mansion_pencils"
end

SWEP.setlh = false
SWEP.setrh = true
SWEP.TwoHanded = false
SWEP.NoHolster = false

SWEP.HoldPos = Vector(-10, 2, -2)
SWEP.HoldAng = Angle(-10, 5, 0)
SWEP.AttackPos = Vector(0, 0, -10)
SWEP.HoldType = "melee"

SWEP.DamageType = DMG_SLASH
SWEP.DamagePrimary = 9
SWEP.DamageSecondary = 7
SWEP.PenetrationPrimary = 1.2
SWEP.PenetrationSecondary = 0.8
SWEP.MaxPenLen = 2
SWEP.PainMultiplier = 0.45
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
SWEP.DeploySnd = "physics/wood/wood_crate_impact_soft3.wav"

SWEP.weight = 0.3

SWEP.AttackTimeLength = 0.15
SWEP.Attack2TimeLength = 0.1

SWEP.AnimTime1 = 0.75
SWEP.AttackTime = 0.15
SWEP.WaitTime1 = 0.6

SWEP.AnimTime2 = 0.75
SWEP.Attack2Time = 0.15
SWEP.WaitTime2 = 0.6

SWEP.AttackRads = 0
SWEP.AttackRads2 = 0

SWEP.SwingAng = -85
SWEP.SwingAng2 = 0

if SERVER then
    util.AddNetworkString("pencil_dcolour")
    util.AddNetworkString("pencil_dscale")
    util.AddNetworkString("pencil_draw")

    net.Receive("pencil_draw", function(len, ply)
        local ent = net.ReadEntity()
        local x = net.ReadFloat()
        local y = net.ReadFloat()
        local col = net.ReadTable()
        local scale = net.ReadInt(4)
        if not IsValid(ent) or ent:GetClass() ~= "ent_hmcd_mansion_sheet" then return end
        ent:DrawDot(x, y, col, scale)
    end)

    net.Receive("pencil_dcolour", function(len, ply)
        local ent = net.ReadEntity()
        local tbl = net.ReadTable()
        if not IsValid(ent) or ent:GetOwner() ~= ply then return end
        tbl.a = tbl.a or 255
        tbl.r = tbl.r or 255
        tbl.g = tbl.g or 255
        tbl.b = tbl.b or 255
        ent:SetNetVar("dcolour", tbl.r .. " " .. tbl.g .. " " .. tbl.b .. " " .. tbl.a)
    end)

    net.Receive("pencil_dscale", function(len, ply)
        local ent = net.ReadEntity()
        local int = net.ReadInt(4)
        if not IsValid(ent) or ent:GetOwner() ~= ply then return end
        ent.DScale = int
    end)
end

function SWEP:CanBlock()
    return false
end

function SWEP:CanSecondaryAttack()
    return false
end

function SWEP:NormalizeColor(col)
    return math.Round(1 / 255 * col.r, 2), math.Round(1 / 255 * col.g, 2), math.Round(1 / 255 * col.b, 2)
end

function SWEP:GetDColour()
    return self:GetNetVar("dcolour", "0 0 0 255")
end

function SWEP:InitAdd()
    self.DrawMode = false
    self.NextModeSwitch = 0
    self.ALLOWOPENMENU = true
    self.DScale = 4
end

function SWEP:CanPrimaryAttack()
    if self.DrawMode then return false end
    return true
end

function SWEP:ToggleMode()
    self.DrawMode = not self.DrawMode
    if CLIENT then
        if self.DrawMode then
            self.AnimList["idle"] = "idle_draw"
            self.AnimList["deploy"] = "draw_idle"
            self:PlayAnim("attack_to_draw", 0.5, false, function()
                if IsValid(self) and self.DrawMode then
                    self:PlayAnim("idle_draw", 2, true)
                    self.weaponPos = Vector(0.5504, 0.693, 2.9405)
                    self.weaponAng = Angle(-109.4992, -90, 0)
                end
            end)
        else
            self.AnimList["idle"] = "idle_attack"
            self.AnimList["deploy"] = "draw_attack"
            self:PlayAnim("draw_to_attack", 0.5, false, function()
                if IsValid(self) and not self.DrawMode then
                    self:PlayAnim("idle_attack", 2, true)
                    self.weaponPos = Vector(0.7244, -2.1373, 1.334)
                    self.weaponAng = Angle(-109.4992, -90, 0)
                end
            end)
        end
    end
end

function SWEP:ThinkAdd()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if CLIENT then
        if owner ~= LocalPlayer() then return end

        local col = string.ToColor(self:GetDColour())
        if col and IsValid(self:GetWM()) then
            self:GetWM():SetColor(col)
        end

        local ENT = hg.eyeTrace(owner).Entity
        if IsValid(ENT) and ENT:GetClass() == "ent_hmcd_mansion_sheet" and self.DrawMode then
            if hg.KeyDown(owner, IN_ATTACK2) then
                local function WorldToScreen(vWorldPos, vPos, vScale, aRot)
                    vWorldPos = vWorldPos - vPos
                    vWorldPos:Rotate(Angle(0, -aRot.y, 0))
                    vWorldPos:Rotate(Angle(-aRot.p, 0, 0))
                    vWorldPos:Rotate(Angle(0, 0, -aRot.r))
                    return vWorldPos.x / vScale, (-vWorldPos.y) / vScale
                end
                local lookAtX, lookAtY = WorldToScreen(owner:GetEyeTrace().HitPos or Vector(0, 0, 0), ENT:GetPos() + ENT:GetAngles():Up(), 0.1, ENT:GetAngles())
                local col = string.ToColor(self:GetDColour()) or Color(0, 0, 0)
                net.Start("pencil_draw")
                    net.WriteEntity(ENT)
                    net.WriteFloat(lookAtX)
                    net.WriteFloat(lookAtY)
                    net.WriteTable(col)
                    net.WriteInt(self.DScale or 4, 4)
                net.SendToServer()
            end
        end
        
        if IsValid(self.Frame) and owner:KeyReleased(IN_RELOAD) then
            self.Frame:Close()
        end
        if owner:KeyReleased(IN_RELOAD) then
            self.ALLOWOPENMENU = true
        end

    end
    if hg.KeyDown(owner, IN_ATTACK2) and owner:KeyDown(IN_RELOAD) and self.NextModeSwitch < CurTime() then
        self.NextModeSwitch = CurTime() + 1
        self:ToggleMode()
    end
end

function SWEP:Reload()
    if not CLIENT then return end
    if not self.DrawMode then return end
    if not self.ALLOWOPENMENU then return end
    if IsValid(self.Frame) then return end
    if hg.KeyDown(self:GetOwner(), IN_ATTACK2) then return end

    local Frame = vgui.Create("DFrame")
    Frame:SetSize(250, 250)
    Frame:Center()
    Frame:MakePopup()
    Frame:SetTitle("Color")
    Frame.Target = self
    self.Frame = Frame

    local Mixer = vgui.Create("DColorPalette", Frame)
    Mixer:SetPos(5, 28)
    Mixer:SetButtonSize(30)
    Mixer:SetSize(265, 200)

    local Slider = vgui.Create("DNumSlider", Frame)
    Slider:SetPos(5, 210)
    Slider:SetSize(200, 16)
    Slider:SetMin(1)
    Slider:SetMax(4)
    Slider:SetDecimals(0)
    Slider:SetText("Brush scale")
    Slider:SetValue(self.DScale or 4)
    Slider.OnValueChanged = function(s, value)
        self.DScale = math.Round(value)
    end

    local Apply = vgui.Create("DButton", Frame)
    Apply:SetPos(5, 230)
    Apply:SetSize(241, 16)
    Apply:SetText("Eraser")
    Apply.Target = self
    function Apply:DoClick()
        if not IsValid(self.Target) then return end
        local col = string.ToColor(self.Target:GetDColour()) or Color(0, 0, 0)
        net.Start("pencil_dcolour")
            net.WriteEntity(self.Target)
            net.WriteTable({ r = col.r, g = col.g, b = col.b, a = 0 })
        net.SendToServer()
        Frame:Close()
        self.Target.ALLOWOPENMENU = false
    end

    function Frame:OnClose()
        if not IsValid(self.Target) then return end
        net.Start("pencil_dscale")
            net.WriteEntity(self.Target)
            net.WriteInt(math.Round(Slider:GetValue()) or 1, 4)
        net.SendToServer()
    end

    Mixer.OnValueChanged = function(s, value)
        if not IsValid(self) then return end
        if IsValid(self:GetWM()) then
            self:GetWM():SetColor(Color(value.r, value.g, value.b))
        end
        net.Start("pencil_dcolour")
            net.WriteEntity(self)
            net.WriteTable(value)
        net.SendToServer()
        Frame:Close()
        self.ALLOWOPENMENU = false
    end
end
