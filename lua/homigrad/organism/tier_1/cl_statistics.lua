local hg_xray = ConVarExists("hg_xray") and GetConVar("hg_xray") or CreateConVar("hg_xray",0,FCVAR_ARCHIVE,"enables xray mode like in sniper elite 3",0,1)
hg.organism_ents = hg.organism_ents or {}

net.Receive("organism_send", function()
	local org = net.ReadTable()
	local force = net.ReadBool()
	local spectatov_ne_trogaem = net.ReadBool()
	local moreinfopls = net.ReadBool()
	local add = net.ReadBool()
	local ply = org.owner
	
	if ply:IsNPC() then
		hg.organism_ents[ply] = true
	end

	if add and org.owner.organism and org.owner.new_organism then
		hook.Run("HG_OrganismChanged", org.owner.organism, org)
		
		table.Merge(org.owner.organism, org, true)
		table.Merge(org.owner.new_organism, org, true)
		
		return 
	end

	if ply.is_lookedat and not moreinfopls then return end
	if !IsValid(ply) then return end
	if spectatov_ne_trogaem and (ply == LocalPlayer():GetNWEntity("spect",nil)) and not LocalPlayer():Alive() then return end
	
	local old_org = table.Copy(ply.organism)
	ply.organism = old_org

	ply.new_organism = org

	--print(org.owner,org.blood)
	
	if not ply.organism or force then
		ply.organism = org
	end

	if ply:IsPlayer() and ply:Alive() then
		org.health = ply:Health()
	end
	
	local rag = ply:GetNWEntity("FakeRagdoll")
	if IsValid(rag) then
		rag.organism = old_org
		rag.new_organism = org
	end

	--[[jit.on()
	jit.collectgarbage()--]]
	--print(collectgarbage("collect"))
end)

hook.Add("Player_Death","removeorg",function(ply)
	ply.organism = nil
	ply.new_organism = nil

	if IsValid(ply.FakeRagdoll) then
		ply.FakeRagdoll.organism = nil
		ply.FakeRagdoll.new_organism = nil
	end
end)

--organism_otherply = organism_otherply or {}
--net.Receive("organism_sendply", function() organism_otherply = net.ReadTable() end)
local white = Color(255, 255, 255)
local black = Color(0, 0, 0, 200)
local list = {
	"owner",
	"superfighter",
	"berserkActive2",
	"temperature",
	"tempchanging",
	"heatbuff",
	"blindness",
	"fear",
	"assimilated",
	"berserk",
	"noradrenaline",
	"fearadd",
	{"blood", 5000}, 
	{"bleed", 100, true}, 
	"bloodtype",
	"hemotransfusionshock",
	{"internalBleed", 10, true}, 
	"internalBleedHeal", 
	{"arteria", 1, true}, 
	{"rarmartery", 1, true}, 
	{"larmartery", 1, true}, 
	{"rlegartery", 1, true}, 
	{"llegartery", 1, true}, 
	{"spineartery", 1, true}, 
	{"llegdislocation", true, true},
	{"rlegdislocation", true, true},
	{"larmdislocation", true, true},
	{"rarmdislocation", true, true},
	{"jawdislocation", true, true},
	{"llegamputated", true, true},
	{"rlegamputated", true, true},
	{"larmamputated", true, true},
	{"rarmamputated", true, true},
	0,
	"likely_phrase",
	{"alive", true}, 
	{"otrub", true, true}, 
	{"health", 100, false},
	{"incapacitated",true,true},
	{"critical",true,true}, false,
	{"pain", 90, true},
	{"painadd", 90, true},
	{"avgpain", 90, true},
	{"immobilization", true},
	{"painkiller", 3, true},
	{"analgesia",0,true},
	{"naloxone",0,true},
	{"shock", 10, true},
	{"hurt", 1, true}, 
	{"tranquilizer", 1, true}, 
	"wantToVomit",
	"satiety",
	0, 
	{"adrenaline", 5, true},
	{"adrenalineStorage", 5, false},
	{"adrenalineAdd", 5, true},
	0, 
	{"stamina", {"stamina", "range"}}, 
	{{"stamina.max", "stamina", "max"}, 
	{"stamina", "range"}}, 
	{{"stamina.regen", "stamina", "regen"}, 1}, 
	{{"stamina.sub", "stamina", "sub"}, 1, true}, 
	0, 
	{"brain", 1, true},
	{"consciousness", 1, false},
	{"skull", 1, true}, 
	{"disorientation",1,true},
	{"jaw", 1, true}, false, 
	{"spine1", 1, true}, 
	{"spine2", 1, true}, 
	{"spine3", 1, true}, 
	{"chest", 1, true}, 
	{"pelvis", 1, true}, 
	0, 
	{"heart", 1, true}, 
	{"heartstop", true, true}, 
	{"pulse", 70}, 
	{"heartbeat", 70}, false, 
	{"stomach", 1, true}, 
	{"liver", 1, true}, 
	{"intestines", 1, true}, 
	"thiamine",
	"vomitInThroat",
	0, 
	{"lungsL", 1, true}, 
	{"lungsR", 1, true}, 
	{{"lungsL.penetrated", "lungsL", 2}, 1,true},
	{{"lungsR.penetrated", "lungsR", 2}, 1,true},
	{"trachea", 1, true}, 
	{"pneumothorax", 1, true}, 
	{"needle", 1, true},
	0, 
	{"o2", {"o2", "range"}}, 
	"CO",
	{"lungsfunction", true, false},
	"COregen",
	"LodgedEntities",
	"holdingbreath",
	{{"o2.regen", "o2", "regen"}, 2}, 
	{{"o2.curregen", "o2", "curregen"}, 0.4},
	0, 
	{"lleg", 1, true}, 
	{"rleg", 1, true}, 
	{"larm", 1, true}, 
	{"rarm", 1, true},
	//"recoilmul",
	//"meleespeed",
}
local function LerpColor(lerp, source, set)
	return Lerp(lerp, source.r, set.r), Lerp(lerp, source.g, set.g), Lerp(lerp, source.b, set.b)
end

local function set(set)
	return set.r, set.g, set.b
end
-- твое говно вообще-то это глуаинтер дурак лучше бы вы его не использовали я бы

local Round = math.Round -- Тут были плохие слова от деке...
local red, green = Color(255, 0, 0), Color(0, 255, 0)
local function getTextTable(org)
	local textList = {}
	for i, v in pairs(list) do
		local text1, text2 = "", ""
		local value
		local r, g, b
		if type(v) == "table" then
			if type(v[1]) == "table" then
				if org[v[1][2]] == nil then continue end
				text1 = v[1][1]
				value = org[v[1][2]][v[1][3]]
			else
				if org[v[1]] == nil then continue end
				text1 = v[1]
				value = org[text1]
				
				if type(value) == "table" then value = value[1] end
			end

			if type(v[2]) == "boolean" then
				if value then
					r, g, b = set(v[3] and red or green)
				else
					r, g, b = set(v[3] and green or red)
				end
			elseif value then
				local max = v[2]
				if type(v[2]) == "string" then max = org[v[2]] end
				if type(v[2]) == "table" then max = org[v[2][1]][v[2][2]] end
				if not max then continue end
				local k = value ~= 0 and max ~= 0 and value / max or 0 -- Тут были плохие слова от шарика...
				if v[3] then
					r, g, b = LerpColor(1 - k, red, green)
				else
					r, g, b = LerpColor(k, red, green)
				end
			end

			text2 = isnumber(value) and string.sub(string.format("%f", value),1,-5) or value
		elseif v == 0 then

		else
			if not org[v] then continue end
			text1 = tostring(v)
			text2 = isnumber(org[v]) and string.sub(string.format("%f", org[v]),1,-5) or org[v]
		end
		
		textList[#textList + 1] = {text1, text2, r, g, b}
	end

	return textList
end

local function LerpVariables(lerp,org_source,org_target)
	if not org_source or not org_target then return end
	for i, v in ipairs(list) do		
		if type(v) == "table" then
			if type(v[1]) == "table" then
				if not org_source[v[1][2]] then continue end
				
				org_source[v[1][2]][v[1][3]] = org_target[v[1][2]] and org_target[v[1][2]][v[1][3]] and Lerp(lerp, org_source[v[1][2]][v[1][3]] or org_target[v[1][2]][v[1][3]], org_target[v[1][2]][v[1][3]]) or nil
			else
				if not org_source[v[1]] then org_source[v[1]] = org_target[v[1]] continue end
				
				if type(org_source[v[1]]) == "table" then
					org_source[v[1]][1] = org_target[v[1]] and org_target[v[1]][1] and Lerp(lerp, org_source[v[1]][1] or org_target[v[1]][1], org_target[v[1]][1]) or nil
				else
					org_source[v[1]] = isnumber(org_source[v[1]]) and isnumber(org_target[v[1]]) and Lerp(lerp, org_source[v[1]],org_target[v[1]]) or org_target[v[1]] or nil
				end
			end
		elseif type(org_target[v]) == "number" and type(org_source[v]) == "number" then
			org_source[v] = Lerp(lerp, org_source[v], org_target[v])
		else
			org_source[v] = org_target[v]
			--print(org_source,org_source[v])
		end
	end
end

hg.LerpVariables = LerpVariables

local littleblack = Color(75, 75, 75, 255)
local trahalgmod = Color(0, 0, 0, 75)
local weight = 200
local developer = GetConVar("developer")
local hg_stats = GetConVar("hg_stats") or CreateClientConVar("hg_stats", 1, true, false, "show stats", 0, 1)
hook.Add("HUDPaint", "homigrad-organism-debug", function()
	
	local spect = IsValid(lply:GetNWEntity("spect")) and lply:GetNWEntity("spect")
	local organism = lply:Alive() and lply.organism or (viewmode == 1 and IsValid(spect) and spect.organism) or {}
	local new_organism = lply:Alive() and lply.new_organism or (viewmode == 1 and IsValid(spect) and spect.new_organism) or {}
	
	--LerpVariables(FrameTime(),organism,new_organism)
	if !organism then return end
	if not developer:GetBool() then return end
	if not LocalPlayer():IsAdmin() then return end
	if !hg_stats:GetBool() then return end
	local textList = getTextTable(organism)
	local h = math.Round(ScreenScaleH(5.5))
	local cutoff = math.floor((ScrH() - 150 - 50) / h)

	draw.RoundedBox(0, 15, 150, weight, cutoff * h, black)
	
	if cutoff < #textList then
		draw.RoundedBox(0, 15 + weight + 15, 150, weight, (#textList - cutoff) * h, black)
	end

	for i, text in ipairs(textList) do
		local y = i > cutoff and 150 + (i - 1 - cutoff) * h or 150 + (i - 1) * h
		local x = i > cutoff and 15 + weight + 15 or 15
		
		if i % 2 == 0 then draw.RoundedBox(0, x, y, weight, h, littleblack) end
		if text[3] then
			trahalgmod.r = text[3]
			trahalgmod.g = text[4]
			trahalgmod.b = text[5]
			trahalgmod.a = 75
			draw.RoundedBox(0, x, y, weight, h, trahalgmod)
		end

		draw.SimpleText(text[1], "DefaultFixedDropShadow", x, y, white)
		draw.SimpleText(text[2], "DefaultFixedDropShadow", x + weight, y, white, TEXT_ALIGN_RIGHT)
	end

	local tr = hg.eyeTrace(LocalPlayer(), 10000)
	if not hg.eyeTrace or not IsValid(LocalPlayer()) or !tr then return end

	local trent = tr.Entity
	local organism_otherply = trent.organism or {}
	local new_organism_otherply = trent.new_organism or {}
	
	--LerpVariables(FrameTime(),organism_otherply,new_organism_otherply)

	if not organism_otherply or table.IsEmpty(organism_otherply) then return end
	trent = organism_otherply.owner
	local textList = getTextTable(organism_otherply)
	local w = ScrW()
	local x = w - 15 - weight
	draw.RoundedBox(0, x, 15, weight, #textList * h, black)
	for i, text in ipairs(textList) do
		local y = 15 + (i - 1) * h
		if i % 2 == 0 then draw.RoundedBox(0, x, y, weight, h, littleblack) end
		if text[3] then
			trahalgmod.r = text[3]
			trahalgmod.g = text[4]
			trahalgmod.b = text[5]
			trahalgmod.a = 75
			draw.RoundedBox(0, x, y, weight, h, trahalgmod)
		end

		draw.SimpleText(text[1], "DefaultFixedDropShadow", w - 15, y, white, TEXT_ALIGN_RIGHT)
		draw.SimpleText(text[2], "DefaultFixedDropShadow", w - 15 - weight, y, white)
	end
end)

local angZero = Angle(0,0,0)
local vecFull = Vector(1,1,1)
local defaultModel = "models/Humans/group01/Female_03.mdl"

hg.hits = hg.hits or {}
local hg_max_hitshow = ConVarExists("hg_max_hitshow") and GetConVar("hg_max_hitshow") or CreateClientConVar("hg_max_hitshow", 40, true, false, "how many hits to track on your local pc (very bad idea to put this to more than 60)", 0, 150)

local csmodel, skiletmodel, bulletmodel
local playStartTime = 0
local curIdx = 1
local cur = {
	traveltime = 5,
	bones = {},
	tracePoses = {},
	hitBoxs = {},
	ricochets = {},
	hitorgans = {},
	organs = nil,
	boxs = nil,
	size = 0,
	model = defaultModel,
	inf = nil,
	attacker = nil,
}

local function ensureCsModel()
	if IsValid(csmodel) then return csmodel end
	csmodel = ClientsideModel(defaultModel, RENDERMODE_TRANSCOLOR)
	csmodel:SetNoDraw(true)
	return csmodel
end

local function ensureSkiletModel()
	if IsValid(skiletmodel) then return skiletmodel end
	skiletmodel = ClientsideModel("models/player/skeleton.mdl", RENDERMODE_TRANSCOLOR)
	skiletmodel:SetNoDraw(true)
	skiletmodel:SetSkin(2)
	skiletmodel:AddEffects(EF_BONEMERGE)
	skiletmodel:SetParent(ensureCsModel())
	return skiletmodel
end

local function ensureBulletModel()
	if IsValid(bulletmodel) then return bulletmodel end
	bulletmodel = ClientsideModel("models/bullets/w_pbullet1.mdl", RENDERMODE_TRANSCOLOR)
	bulletmodel:SetNoDraw(true)
	return bulletmodel
end

local function normalize(val, min, max)
    return (val - min) / (max - min)
end

ensureCsModel()
ensureSkiletModel()
ensureBulletModel()

local function clearHits()
	playStartTime = nil
	hg.hits = {}
end

local function playHit(idx)
	local hit = hg.hits[idx]
	if not hit then return end

	curIdx = idx
	cur.tracePoses = hit.tracePoses
	cur.ent = hit.ent
	cur.hitBoxs = hit.hitBoxs
	cur.dmg = hit.dmg
	cur.size = hit.size
	cur.traveltime = hit.traveltime
	cur.attacker = hit.att
	cur.model = hit.model
	cur.bone0 = hit.bone0
	cur.bones = hit.bones
	cur.ricochets = hit.ricochets
	cur.inf = hit.inf

	local mdl = ensureCsModel()
	mdl:SetPos(hit.bone0:GetTranslation())
	mdl:SetModel(hit.model)
	if hit.curAppearance and hg.Appearance and hg.Appearance.ApplyAppearanceToEnt then
		hg.Appearance.ApplyAppearanceToEnt(mdl, hit.curAppearance)
	end
	mdl.armors = hit.armors or {}

	cur.organs = hg.organism.GetHitBoxOrgans(hit.model, mdl)
	cur.boxs, cur.pos, cur.sphere = hg.organism.ShootMatrix(mdl, cur.organs)
	if cur.boxs == nil then return end

	cur.hitorgans = {}
	for i = 1, #cur.boxs do
		local box = cur.boxs[i]
		local organ = box[6] and cur.organs[box[6]][box[7]]
		if organ and cur.hitBoxs[i] then cur.hitorgans[i] = organ[1] end
	end

	for cbId in pairs(mdl:GetCallbacks("BuildBonePositions")) do
		mdl:RemoveCallback("BuildBonePositions", cbId)
	end

	mdl:AddCallback("BuildBonePositions", function()
		for i = 0, mdl:GetBoneCount() do
			if not cur.bones[i] or not mdl:GetBoneMatrix(i) then continue end
			cur.bones[i]:SetScale(vecFull)
			mdl:SetBoneMatrix(i, cur.bones[i])
		end
	end)

	playStartTime = 0
end

hook.Add("Player_Death", "wowww", function(ply)
	if ply ~= LocalPlayer() or #hg.hits == 0 then return end
	playHit(#hg.hits)
end)

hook.Add("Player Spawn", "removehuys", function(ply)
	if ply ~= LocalPlayer() then return end
	hg.hits = {}
end)

local function decodeHit()
	local tracePoses = net.ReadTable()
	local ent = net.ReadEntity()
	local hitBoxs = net.ReadTable()
	local dmg = net.ReadFloat() -- actually pen
	local size = net.ReadFloat()
	local traveltime = math.min(dmg, 8)
	local bone = net.ReadInt(32)
	local matpos = net.ReadVector()
	local matang = net.ReadAngle()
	local model = net.ReadString()
	local bone0 = net.ReadMatrix()
	local inf = net.ReadString()
	local att = net.ReadString()
	local basebone = net.ReadMatrix()
	local curAppearance = net.ReadTable()

	ent = hg.GetCurrentCharacter(ent) or ent
	if not basebone or not IsValid(ent) then return end

	local bones = {}
	for i = 0, ent:GetBoneCount() do
		bones[i] = ent:GetBoneMatrix(i)
		if bones[i] then
			bones[i]:SetScale(vecFull)
			bones[i]:SetTranslation(bones[i]:GetTranslation())
		end
	end

	if not bones[bone] then return end
	local addpos = -(matpos - bones[bone]:GetTranslation())

	local ricochets = {}
	for i = #tracePoses, 2, -1 do
		local str = tracePoses[i]
		debugoverlay.Line(tracePoses[i], tracePoses[i - 1], 6, color_white, true)
		if istable(str) then
			table.insert(ricochets, str)
			table.remove(tracePoses, i)
			continue
		end
		tracePoses[i] = Vector(str)

		local localpos, localang = WorldToLocal(tracePoses[i], basebone:GetAngles(), matpos, matang)
		localpos:Rotate(localang)
		tracePoses[i] = LocalToWorld(localpos, angZero, matpos, matang)
		tracePoses[i]:Add(addpos)
	end

	local ricoshits = {}
	for _, tbl in ipairs(ricochets) do
		ricoshits[tbl[2]] = tbl[1]
	end

	if #hg.hits >= hg_max_hitshow:GetInt() then table.remove(hg.hits, 1) end

	local armors = table.Copy((hg.RagdollOwner(ent) or ent):GetNetVar("Armor"))

	size = normalize(size, 1, 4)

	table.insert(hg.hits, {
		tracePoses = tracePoses,
		ent = ent,
		hitBoxs = hitBoxs,
		dmg = dmg,
		size = size,
		traveltime = traveltime,
		att = att,
		model = model,
		bone0 = bone0,
		bones = bones,
		basebone = basebone,
		ricochets = ricoshits,
		armors = armors,
		inf = inf,
		curAppearance = curAppearance,
	})
end

net.Receive("tracePosesSend", function()
	if not hg_xray:GetBool() then return end
	decodeHit()
end)

function draw.RotatedText(text, x, y, font, color, ang)
	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)

	local m = Matrix()
	m:Translate(Vector(x, y, 0))
	m:Rotate(Angle(0, ang, 0))

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)

	m:Translate(-Vector(w / 2, h / 2, 0))

	cam.PushModelMatrix(m)
		draw.DrawText(text, font, 0, 0, color)
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end

local function getReplayProgress()
	if not playStartTime then return nil end
	local endTime = playStartTime + cur.traveltime
	if endTime <= CurTime() then return nil end

	local tbl = cur.tracePoses
	if not tbl or #tbl < 2 then return nil end

	local remaining = endTime - CurTime()
	local part = 1 - remaining / cur.traveltime
	local alpha = remaining / 0.2
	local alpha2 = math.Clamp(1 - remaining / 0.5, 0, 1)

	local baseIdx = math.floor(#tbl * part)
	local firstpoint = tbl[math.min(baseIdx + 1, #tbl)]
	local secondpoint = tbl[math.min(baseIdx + 2, #tbl)]
	local nextfirstpoint = tbl[math.min(baseIdx + 2, #tbl)]
	local nextsecondpoint = tbl[math.min(baseIdx + 3, #tbl)]

	if not firstpoint or not secondpoint or not nextfirstpoint or not nextsecondpoint then return nil end

	local frac = (#tbl * part) - baseIdx
	local point1 = LerpVector(frac, firstpoint, nextfirstpoint)
	local point2 = LerpVector(frac, secondpoint, nextsecondpoint)

	return {
		tbl = tbl,
		part = part,
		alpha = alpha,
		alpha2 = alpha2,
		firstpoint = firstpoint,
		secondpoint = secondpoint,
		nextfirstpoint = nextfirstpoint,
		nextsecondpoint = nextsecondpoint,
		point1 = point1,
		point2 = point2,
	}
end

function hg.DeathCamAvailable(ply)
	return playStartTime and ((playStartTime + cur.traveltime) > CurTime()) and #hg.hits > 0
end

local delta = 0
hook.Add("CreateMove", "delta-counting-hg", function(cmd)
	delta = cmd:GetMouseWheel()
end)

local camLen = 50
function hg.DeathCam(ply, origin, angles, fov, znear, zfar)
	if lply:Alive() then return end

	camLen = math.Clamp(camLen - delta * 10, 10, 50)
	if playStartTime == 0 then playStartTime = CurTime() end
	if lply:KeyDown(IN_RELOAD) then clearHits() end

	local rp = getReplayProgress()
	if not rp then return end

	return {
		origin = rp.point2 + angles:Forward() * -camLen,
		angles = angles,
		fov = fov,
		drawviewer = true,
	}
end

local weight = ScreenScale(100)
local colblack = Color(0, 0, 0, 255)
local colyellow = Color(255, 217, 0)
local colred = Color(135, 0, 0, 255)
local colblacka = Color(22, 22, 22, 255)
local mathuy = Material("color")
local meat = Material("models/flesh")
local attpressed, attpressed2
local angle = Angle(25, 0, 0)

surface.CreateFont("DefaultFixedDropShadowBig", {
	font = "DefaultFixedDropShadow",
	size = ScreenScale(12),
})

local function handleHitNav()
	if (lply:KeyDown(IN_ATTACK2) or lply:KeyDown(IN_MOVERIGHT)) and playStartTime and #hg.hits ~= 0 then
		if not attpressed then
			local next_ = curIdx + 1
			playHit(next_ > #hg.hits and 1 or next_)
			attpressed = true
		end
	else
		attpressed = nil
	end

	if (lply:KeyDown(IN_ATTACK) or lply:KeyDown(IN_MOVELEFT)) and playStartTime and #hg.hits ~= 0 then
		if not attpressed2 then
			local next_ = curIdx - 1
			playHit(next_ < 1 and #hg.hits or next_)
			attpressed2 = true
		end
	else
		attpressed2 = nil
	end
end

hook.Add("HUDPaint", "homigrad-wound-debug", function()
	if lply:Alive() then return end

	if playStartTime == 0 then playStartTime = CurTime() end
	if lply:KeyDown(IN_RELOAD) then clearHits() end

	handleHitNav()

	local rp = getReplayProgress()
	if not rp then return end

	local mdl = ensureCsModel()
	local skilet = ensureSkiletModel()
	local hit = hg.hits[curIdx]
	if not hit then return end

	colblack.a = 255 * rp.alpha
	angle = angle + Angle(0, 0.25, 0)

	cam.Start3D()
		render.SetStencilWriteMask(0xFF)
		render.SetStencilTestMask(0xFF)
		render.SetStencilReferenceValue(0)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		render.ClearStencil()

		render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)

		mdl:DrawModel()
		if hit.curAppearance and hit.curAppearance.AAttachments then
			for _, vv in pairs(hit.curAppearance.AAttachments) do
				if vv == "none" then continue end
				DrawAccesories(mdl, mdl, vv, hg.Accessories[vv], false, true)
			end
		end

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_INCR)
		render.SetStencilZFailOperation(STENCIL_INCR)

		local huyalpha = rp.alpha * 0.2 / cur.traveltime
		huyalpha = huyalpha > 0.2 and 1 or huyalpha / 0.2
		render.SetMaterial(mathuy)
		render.DrawSphere(rp.point2, 7 * huyalpha, 50, 50, colblacka)

		render.SetStencilReferenceValue(2)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.ClearBuffersObeyStencil(0, 0, 0, 0, true)

		cam.Start2D()
			surface.SetDrawColor(155, 0, 0, 15)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH(), 0)
		cam.End2D()

		skilet:DrawModel() -- надо доделать, когда разберусь в стенсилах // а все уже, работает

		cam.Start2D()
			surface.SetDrawColor(155, 0, 0, 95)
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH(), 0)
		cam.End2D()

		cur.organs = hg.organism.GetHitBoxOrgans(cur.model, mdl)
		cur.boxs, cur.pos, cur.sphere = hg.organism.ShootMatrix(mdl, cur.organs)

		for i = 1, #cur.boxs do
			local box = cur.boxs[i]
			local organ = box[6] and cur.organs[box[6]][box[7]]
			if not cur.hitBoxs[i] then continue end

			local col = Color((organ and organ[6] or white):Unpack())
			col.a = 50
			render.DrawWireframeBox(box[1], box[2], box[3], box[4], col, false)
		end

		render.SetStencilEnable(false)

		for i = 1, #cur.boxs do
			local box = cur.boxs[i]
			local organ = box[6] and cur.organs[box[6]][box[7]]
			if not cur.hitBoxs[i] then continue end

			if organ and cur.hitorgans[i] then
				cam.Start2D()
					draw.SimpleText(hg.organism.translationTbl[organ[1]] or organ[1], "HomigradFontSmall",
						box[1]:ToScreen().x + math.sin(CurTime() % i) ^ 3 * (5 % i),
						box[1]:ToScreen().y + math.cos(CurTime() % i) * (5 % i),
						organ[6])
				cam.End2D()
			end
		end

		white.r, white.g, white.b, white.a = 255, 255, 255, 255

		render.SetColorMaterial()
		local segDir = (rp.nextsecondpoint - rp.nextfirstpoint):Angle()
		local segLen = (rp.nextsecondpoint - rp.nextfirstpoint):Length()
		render.DrawBox(rp.nextfirstpoint, segDir, -Vector(0, cur.size, cur.size), Vector(segLen, cur.size * 0.9, cur.size * 0.9), colyellow)
		render.DrawWireframeBox(rp.nextfirstpoint, segDir, -Vector(0, cur.size * 0.9, cur.size * 0.9), Vector(segLen, cur.size * 0.9, cur.size * 0.9), colyellow)

		for i = 1, #rp.tbl - 1 do
			local a, b = rp.tbl[i], rp.tbl[i + 1]
			render.DrawWireframeBox(a, (b - a):Angle(), -Vector(0, cur.size * 0.9, cur.size * 0.9), Vector((b - a):Length(), cur.size * 0.9, cur.size * 0.9), Color(0, 0, 0, 100))
		end
	cam.End3D()

	draw.SimpleText("R to skip.", "HomigradFontBig", ScrW() / 3 * 2, ScrH() / 7, color_white)
	draw.SimpleText("Hit " .. tostring(curIdx) .. " of " .. tostring(#hg.hits) .. " by " .. tostring(cur.inf) .. " from " .. tostring(cur.attacker), "HomigradFontBig", ScrW() / 3 * 2, ScrH() / 10, color_white)

	local countedorgans = {}
	local organs2 = {}
	for i, text in pairs(cur.hitorgans) do
		if countedorgans[text] then continue end
		countedorgans[text] = true

		if cur.ricochets[i] then
			table.insert(organs2, cur.ricochets[i] .. tostring(hg.organism.translationTbl[cur.hitorgans[i]] or cur.hitorgans[i]))
		else
			table.insert(organs2, "Penetrated " .. hg.organism.translationTbl[text])
		end
	end

	for i, text in ipairs(organs2) do
		local y = ScreenScale(200) + ScreenScale((i - 1) * 16)
		draw.RoundedBox(0, ScreenScale(75),y , weight * 1.5, ScreenScale(16), littleblack)
		draw.RoundedBox(1, ScreenScale(75), y, weight * 1.5 - 5, ScreenScale(16), color_black)
		draw.SimpleText(text, "HomigradFont", ScreenScale(80), y, white)
	end
end)

local hg_wound_debug = GetConVar("hg_wound_debug") or CreateClientConVar("hg_wound_debug", 0, true, false, "show wounds", 0, 1)

local red = Color(255,0,0)
local white = Color(255,255,255)
local black = Color(0,0,0)

local lookedWound
local lookedPos

hook.Add("PostDrawTranslucentRenderables", "homigrad-wound-debug", function()
	if not hg_wound_debug:GetBool() then return end
	if not LocalPlayer():IsAdmin() then return end

	lookedWound = nil
	lookedPos = nil

	local eyePos = EyePos()
	local eyeDir = EyeAngles():Forward()

	local bestDist = math.huge

	for _, ply in player.Iterator() do
		if ply == LocalPlayer() then continue end
		ply = hg.GetCurrentCharacter(ply)

		if ply == LocalPlayer() then continue end
		if not IsValid(ply) then continue end

		local org = ply.organism
		if not org or not org.wounds then continue end

		for _, wound in ipairs(org.wounds) do
			local bone = ply:LookupBone(wound[4] or "")
			if not bone then continue end

			local matrix = ply:GetBoneMatrix(bone)
			if not matrix then continue end

			local pos = LocalToWorld(
				wound[2],
				angle_zero,
				matrix:GetTranslation(),
				matrix:GetAngles()
			)

			render.DrawWireframeSphere(
				pos,
				1.5,
				8,
				8,
				Color(255, 0, 0)
			)

			local dist = util.DistanceToLine(
				eyePos,
				eyePos + eyeDir * 10000,
				pos
			)

			if dist < 3 then
				local d = eyePos:DistToSqr(pos)

				if d < bestDist then
					bestDist = d
					lookedWound = wound
					lookedPos = pos
				end
			end
		end
	end
end)

hook.Add("HUDPaint", "homigrad-wound-debug-info", function()
	if not lookedWound or not lookedPos then return end

	local scr = (lookedPos + Vector(0, 0, 4)):ToScreen()

	draw.SimpleTextOutlined(
		"Blood: "..math.Round(lookedWound[1], 2),
		"DefaultFixedDropShadow",
		scr.x,
		scr.y,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM,
		1,
		color_black
	)

	draw.SimpleTextOutlined(
		"Bone: "..lookedWound[4],
		"DefaultFixedDropShadow",
		scr.x,
		scr.y + 14,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM,
		1,
		color_black
	)

	draw.SimpleTextOutlined(
		"Time: "..math.Round(lookedWound[5], 2),
		"DefaultFixedDropShadow",
		scr.x,
		scr.y + 28,
		color_white,
		TEXT_ALIGN_CENTER,
		TEXT_ALIGN_BOTTOM,
		1,
		color_black
	)
end)