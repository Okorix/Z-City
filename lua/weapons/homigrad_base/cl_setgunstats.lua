local hg_setgunstats = CreateClientConVar("hg_setgunstats", "0", false, false, "Open editor for the currently held gun (positions, angles, attachment mounts, stats)", 0, 1)

local _gunFrame

local vecProps = {
    "FakePos", "FakeAng",
    "AttachmentPos", "AttachmentAng",
    "ZoomPos", "ZoomAng",
    "GunCamPos", "GunCamAng",
    "LocalMuzzlePos", "LocalMuzzleAng",
    "WeaponEyeAngles",
    "WorldPos", "WorldAng",
    "EjectAng", "EjectPos",
    "attPos", "attAng",
    "handsAng",
    "RHPos", "RHAng",
    "LHPos", "LHAng",
    "RHandPos", "LHandPos",
    "RHPosOffset", "LHPosOffset",
    "RHAngOffset", "LHAngOffset",
    "AdditionalPos", "AdditionalAng",
    "AdditionalPos2", "AdditionalAng2",
    "AdditionalPosPreLerp", "AdditionalAngPreLerp",
    "lmagpos", "lmagang",
    "lmagpos2", "lmagang2",
    "vecSuicidePist", "angSuicidePist",
    "vecSuicidePist2", "angSuicidePist2",
    "vecSuicideRifle", "angSuicideRifle",
    "vecSuicideRifle2", "angSuicideRifle2",
    "CloseAnimAddVec", "CloseAnimAddAng",
    "CustomEjectAngle",
    "weaponPos", "weaponAng",
}

local scalarProps = {
    { name = "ViewPunchDiv",       min = 1,   max = 500 },
    { name = "SightSlideOffset",   min = 0,   max = 20  },
    { name = "ShootAnimMul",       min = 0,   max = 10  },
    { name = "ReloadTime",         min = 0,   max = 20  },
    { name = "Penetration",        min = 0,   max = 50  },
    { name = "Ergonomics",         min = 0,   max = 10  },
    { name = "weight",             min = 0,   max = 20  },
    { name = "lengthSub",          min = 0,   max = 100 },
    { name = "SpreadMul",          min = 0,   max = 20  },
    { name = "SpreadMulZoom",      min = 0,   max = 20  },
    { name = "RecoilMul",          min = 0,   max = 20  },
    { name = "Primary.Damage",     min = 0,   max = 300 },
    { name = "Primary.Force",      min = 0,   max = 500 },
    { name = "Primary.Wait",       min = 0,   max = 1,   decimals = 4 },
    { name = "Primary.Cone",       min = 0,   max = 10,  decimals = 4 },
    { name = "Primary.Spread",     min = 0,   max = 10,  decimals = 4 },
}

local function getVal(tbl, path)
    local o = tbl
    for k in string.gmatch(path, "[^.]+") do
        if type(o) ~= "table" then return nil end
        o = o[k]
    end
    return o
end

local function setVal(tbl, path, val)
    local keys = {}
    for k in string.gmatch(path, "[^.]+") do keys[#keys + 1] = k end
    local o = tbl
    for i = 1, #keys - 1 do
        o = o[keys[i]]
        if type(o) ~= "table" then return end
    end
    o[keys[#keys]] = val
end

local function fmtV3(v)
    return math.Round(v[1], 4) .. ", " .. math.Round(v[2], 4) .. ", " .. math.Round(v[3], 4)
end

local function PrintAndCopy(wep, editedVec, editedScalar, editedAtt)
    local lines = {}

    for name in pairs(editedVec) do
        local v = wep[name]
        if not v then continue end
        if isvector(v) then
            lines[#lines + 1] = "SWEP." .. name .. " = Vector(" .. fmtV3(v) .. ")"
        elseif isangle(v) then
            lines[#lines + 1] = "SWEP." .. name .. " = Angle(" .. fmtV3(v) .. ")"
        end
    end

    for name in pairs(editedScalar) do
        local v = getVal(wep, name)
        if v == nil then continue end
        lines[#lines + 1] = "SWEP." .. name .. " = " .. tostring(math.Round(v, 4))
    end

    for key, info in pairs(editedAtt) do
        lines[#lines + 1] = "-- att " .. key .. " = " .. info
    end

    if #lines == 0 then return end

    local str = table.concat(lines, "\n") .. "\n"
    print(str)
    SetClipboardText(str)
end

local function addVecSlider(scroll, wep, name, editedVec, saveOriginal)
    local v = wep[name]
    if not v then return end
    local isAng = isangle(v)

    local label = vgui.Create("DLabel", scroll)
    label:SetText(name)
    label:SetFont("DermaDefaultBold")
    label:Dock(TOP)
    label:DockMargin(0, 6, 0, 2)
    label:SetTall(16)

    saveOriginal(name, { v[1], v[2], v[3] }, "vec")

    local comps = isAng and { "P", "Y", "R" } or { "X", "Y", "Z" }
    for i, comp in ipairs(comps) do
        local slider = vgui.Create("DNumSlider", scroll)
        slider:SetText(comp)
        slider:SetMin(isAng and -360 or -50)
        slider:SetMax(isAng and 360 or 50)
        slider:SetDefaultValue(v[i])
        slider:SetDecimals(3)
        slider:Dock(TOP)
        slider:SetTall(22)
        slider:SetValue(v[i])

        local capI = i
        slider.OnValueChanged = function(_, val)
            if not IsValid(wep) then return end
            wep[name][capI] = val
            editedVec[name] = true
        end
    end
end

local function addScalarSlider(scroll, wep, def, editedScalar, saveOriginal)
    local v = getVal(wep, def.name)
    if v == nil or type(v) ~= "number" then return end

    local label = vgui.Create("DLabel", scroll)
    label:SetText(def.name)
    label:SetFont("DermaDefaultBold")
    label:Dock(TOP)
    label:DockMargin(0, 6, 0, 2)
    label:SetTall(16)

    saveOriginal(def.name, v, "scalar")

    local slider = vgui.Create("DNumSlider", scroll)
    slider:SetText("value")
    slider:SetMin(def.min)
    slider:SetMax(def.max)
    slider:SetDefaultValue(v)
    slider:SetDecimals(def.decimals or 3)
    slider:Dock(TOP)
    slider:SetTall(22)
    slider:SetValue(v)

    slider.OnValueChanged = function(_, val)
        if not IsValid(wep) then return end
        setVal(wep, def.name, val)
        editedScalar[def.name] = true
    end
end

local function collectAttachmentSlots(wep)
    local slots = {}
    if not wep.availableAttachments then return slots end

    for placement, plc in pairs(wep.availableAttachments) do
        if not istable(plc) then continue end

        if isvector(plc.mount) then
            slots[#slots + 1] = { path = { "availableAttachments", placement, "mount" }, label = placement .. ".mount", isAng = false }
        elseif istable(plc.mount) then
            for mt, val in pairs(plc.mount) do
                if isvector(val) then
                    slots[#slots + 1] = { path = { "availableAttachments", placement, "mount", mt }, label = placement .. ".mount[" .. mt .. "]", isAng = false }
                end
            end
        end

        if isangle(plc.mountAngle) then
            slots[#slots + 1] = { path = { "availableAttachments", placement, "mountAngle" }, label = placement .. ".mountAngle", isAng = true }
        elseif istable(plc.mountAngle) then
            for mt, val in pairs(plc.mountAngle) do
                if isangle(val) then
                    slots[#slots + 1] = { path = { "availableAttachments", placement, "mountAngle", mt }, label = placement .. ".mountAngle[" .. mt .. "]", isAng = true }
                end
            end
        end

        for k, entry in pairs(plc) do
            if not istable(entry) or isvector(entry) or isangle(entry) then continue end
            if type(entry[1]) == "string" and isvector(entry[2]) then
                slots[#slots + 1] = { path = { "availableAttachments", placement, k, 2 }, label = placement .. "[" .. tostring(k) .. "].pos (" .. entry[1] .. ")", isAng = false }
            end
        end
    end

    return slots
end

local function resolvePath(root, path)
    local o = root
    for i = 1, #path - 1 do
        o = o[path[i]]
        if type(o) ~= "table" then return nil end
    end
    return o, path[#path]
end

local function addAttachmentSlider(scroll, wep, slot, editedAtt, saveOriginal)
    local parent, key = resolvePath(wep, slot.path)
    if not parent then return end
    local v = parent[key]
    if not v then return end

    local label = vgui.Create("DLabel", scroll)
    label:SetText(slot.label)
    label:SetFont("DermaDefaultBold")
    label:Dock(TOP)
    label:DockMargin(0, 6, 0, 2)
    label:SetTall(16)

    local slotKey = table.concat(slot.path, "/")
    saveOriginal(slotKey, { v[1], v[2], v[3], parent = parent, key = key, isAng = slot.isAng }, "att")

    local comps = slot.isAng and { "P", "Y", "R" } or { "X", "Y", "Z" }
    for i, comp in ipairs(comps) do
        local slider = vgui.Create("DNumSlider", scroll)
        slider:SetText(comp)
        slider:SetMin(slot.isAng and -360 or -50)
        slider:SetMax(slot.isAng and 360 or 50)
        slider:SetDefaultValue(v[i])
        slider:SetDecimals(3)
        slider:Dock(TOP)
        slider:SetTall(22)
        slider:SetValue(v[i])

        local capI = i
        slider.OnValueChanged = function(_, val)
            if not IsValid(wep) then return end
            local newv = slot.isAng and Angle(v[1], v[2], v[3]) or Vector(v[1], v[2], v[3])
            newv[capI] = val
            parent[key] = newv
            v = newv
            editedAtt[slotKey] = slot.label .. " = " .. (slot.isAng and "Angle(" or "Vector(") .. fmtV3(newv) .. ")"
        end
    end
end

local function OpenFrame(wep)
    if IsValid(_gunFrame) then _gunFrame:Remove() end

    local frame = vgui.Create("DFrame")
    frame:SetSize(420, 700)
    frame:Center()
    frame:SetTitle("hg_setgunstats — " .. (wep.PrintName or wep:GetClass()))
    frame:MakePopup()
    _gunFrame = frame

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    local originals = {}
    local editedVec, editedScalar, editedAtt = {}, {}, {}
    local function saveOriginal(key, val, kind)
        if originals[key] then return end
        originals[key] = { val = val, kind = kind }
    end

    local pageVec = vgui.Create("DScrollPanel", sheet)
    sheet:AddSheet("Positions & Angles", pageVec, "icon16/arrow_out.png")
    for _, name in ipairs(vecProps) do
        addVecSlider(pageVec, wep, name, editedVec, saveOriginal)
    end

    local pageScalar = vgui.Create("DScrollPanel", sheet)
    sheet:AddSheet("Stats", pageScalar, "icon16/chart_bar.png")
    for _, def in ipairs(scalarProps) do
        addScalarSlider(pageScalar, wep, def, editedScalar, saveOriginal)
    end

    local pageAtt = vgui.Create("DScrollPanel", sheet)
    sheet:AddSheet("Attachments", pageAtt, "icon16/wrench.png")
    local slots = collectAttachmentSlots(wep)
    if #slots == 0 then
        local l = vgui.Create("DLabel", pageAtt)
        l:SetText("No editable attachment mounts on this weapon.")
        l:Dock(TOP)
        l:DockMargin(6, 6, 6, 6)
    else
        for _, slot in ipairs(slots) do
            addAttachmentSlider(pageAtt, wep, slot, editedAtt, saveOriginal)
        end
    end

    local btn = vgui.Create("DButton", frame)
    btn:SetText("Copy edited values")
    btn:Dock(BOTTOM)
    btn:DockMargin(4, 4, 4, 4)
    btn:SetTall(24)
    btn.DoClick = function()
        PrintAndCopy(wep, editedVec, editedScalar, editedAtt)
    end

    frame.OnClose = function()
        if IsValid(wep) then
            for key, entry in pairs(originals) do
                if entry.kind == "vec" then
                    local v = wep[key]
                    if v then
                        v[1] = entry.val[1]
                        v[2] = entry.val[2]
                        v[3] = entry.val[3]
                    end
                elseif entry.kind == "scalar" then
                    setVal(wep, key, entry.val)
                elseif entry.kind == "att" then
                    local parent = entry.val.parent
                    local pkey = entry.val.key
                    if parent and pkey ~= nil then
                        local ov = parent[pkey]
                        if ov then
                            ov[1] = entry.val[1]
                            ov[2] = entry.val[2]
                            ov[3] = entry.val[3]
                        end
                    end
                end
            end
        end
        RunConsoleCommand("hg_setgunstats", "0")
    end
end

cvars.AddChangeCallback("hg_setgunstats", function(_, _, new)
    if new == "1" then
        if not IsValid(LocalPlayer()) then return end
        local wep = LocalPlayer():GetActiveWeapon()
        if IsValid(wep) and wep.ishgwep then
            OpenFrame(wep)
        else
            RunConsoleCommand("hg_setgunstats", "0")
        end
    elseif IsValid(_gunFrame) then
        _gunFrame:Remove()
    end
end, "hg_setgunstats_cb")
