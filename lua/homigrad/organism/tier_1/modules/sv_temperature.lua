local warmingEnts = {
	["env_sprite"] = 0.0,
	["env_fire"] = 0.5,
	["vfire"] = function(ent) return ent:GetFireState() end,
}

hg.MapTemps = {
	["gm_wintertown"] = -10,
	["cs_drugbust_winter"] = -10,
	["cs_office"] = -10,
	["gm_zabroshka_winter"] = -23,
	["mu_smallotown_v2_snow"] = -12,
	["ttt_cosy_winter"] = -16,
	["ttt_winterplant_v4"] = -16,
	["gm_everpine_mall"] = -10,
	["gm_boreas"] = -40,
	["gm_reservoir_a1"] = -10,
	["mu_riverside_snow"] = -10,
	["gm_fork_north"] = -16,
	["gm_fork_north_day"] = -21,
	["gm_ijm_boreas"] = -40,
	["gm_construct"] = 20
}

function hg.TranslateToBodyTemp(temp, org)
	return math.Remap(temp, -20, 20, 27, org and org.needed_temp or 36.7)
end

local hg_temperaturesystem = CreateConVar("hg_temperaturesystem", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_NOTIFY, "Toggle temperature system", 0, 1)
local sf2_get_temp = StormFox2 and StormFox2.Temperature and StormFox2.Temperature.Get or nil

hook.Add("StormFox2.PostEntityScan","load-stormfox-support",function()
	sf2_get_temp = StormFox2 and StormFox2.Temperature and StormFox2.Temperature.Get or nil
end)

hook.Add("Org Think", "BodyTemperature", function(owner, org, timeValue)
	if not owner:IsPlayer() or not owner:Alive() then return end
	if owner.GetPlayerClass and owner:GetPlayerClass() and owner:GetPlayerClass().NoFreeze then return end
	if !hg_temperaturesystem:GetBool() then return end
	if (owner.CheckTemp or 0) > CurTime() then return end
	owner.CheckTemp = CurTime() + 0.5--optimization update

	local timeValue = 0.5
	local ent = hg.GetCurrentCharacter(owner)

	local IsVisibleSkyBox = util.TraceLine( {
		start = ent:GetPos() + vector_up * 15,
		endpos = ent:GetPos() + vector_up * 999999,
		mask = MASK_SOLID_BRUSHONLY
	} ).HitSky and !owner:InVehicle()

	org.temperature = org.temperature or 36.7

	local currentPulse = org.pulse or 70
	local pulseHeat = 0
	local temp = sf2_get_temp and sf2_get_temp() or hg.MapTemps[game.GetMap()] or 20

	if currentPulse > 80 then
		local pulseMultiplier = math.min((currentPulse - 70) / 100, 1.2)
		pulseHeat = timeValue / 50 * pulseMultiplier * 0.2
	end -- unused

	local warming = org.stamina.sub > 0 and 0.5 or 0
	local ownerpos = owner:GetPos()
	for i, ent in ipairs(ents.FindInSphere(ownerpos, 300)) do
		local warmingent = warmingEnts[ent:GetClass()]
		if warmingent and !ent:GetNoDraw() then
			--org.temperature = org.temperature + timeValue * (warmingEnts[ent:GetClass()] / 50 * (1 - ent:GetPos():Distance(owner:GetPos()) / 200))
			warming = warming + (isfunction(warmingent) and warmingent(ent) or warmingent)
		end
	end

	for i, tbl in ipairs(hg.gasolinePath) do
		--tbl[2] -> true = burned, number = still burning, false = unignited
		if tbl[2] and isnumber(tbl[2]) and (ownerpos - tbl[1]):LengthSqr() < 200 * 200 then
			warming = warming + 0.5
		end
	end

	local changeRate = timeValue / 30 -- 1 degree every 1 minute

	local temp = (IsVisibleSkyBox and temp or 20) + warming * 5
	
	local isFreezing = temp < 0
	local isHeating = temp > 30

	local MaxWarmMul = 1
	local warmLoseMul = 1

	if temp < -20 then
		changeRate = changeRate * math.abs(temp) * 0.1
	end
	local result1,result2,result3 = hook.Run("ZC_BodyTemperature", owner, org, timeValue, changeRate, MaxWarmMul, warmLoseMul)
	if result1 and result2 and result3 then
		changeRate = result1
		MaxWarmMul = result2
		warmLoseMul = result3
	end

	if temp > 25 then
		changeRate = changeRate * math.Clamp(((org.heatbuff - 30) / 60), 1, 2)
	end

	org.tempchanging = changeRate

	if org.heatbuff > 0 then
		temp = math.max(20, temp)
	end

	if org.heatbuff < 30 and org.temperature < 30 then
		temp = math.min(-20, temp)
	end

	org.temperature = math.Approach(org.temperature, hg.TranslateToBodyTemp(temp, org), org.tempchanging)

	if owner:Alive() and not org.otrub and org.temperature < 36 then
		org.FreezeSndCD = org.FreezeSndCD or CurTime() + math.random(5, 15)
		
		if org.FreezeSndCD < CurTime() then
			org.FreezeSndCD = CurTime() + math.random(10, 35)

			ent:EmitSound("zcitysnd/"..(ThatPlyIsFemale(ent) and "fe" or "").."male/freezing_"..math.random(1,8)..".mp3",65)
		end
	end
	
	org.FreezeDMGCd = org.FreezeDMGCd or CurTime()
	if org.temperature < 35 and org.FreezeDMGCd < CurTime() then
		org.painadd = org.painadd + math.Rand(0, 1) * ((35 - org.temperature) / 35 * 4 + 1)
		org.FreezeDMGCd = CurTime() + 0.5
	end

	if owner:Alive() and org.temperature > 40 then
		org.VomitCD = org.VomitCD or CurTime() + math.random(35, 75)
		
		if org.VomitCD < CurTime() then
			org.VomitCD = CurTime() + math.random(35, 75)
			owner:Notify(hg.get_phraselist(owner, "heatvomit"), 1, "phrase", 1, nil, Color(255, 85, 85, 255))
			
			timer.Simple(3, function()
				hg.organism.Vomit(org.owner)
			end)
		end
	end

	org.HeatDMGCd = org.HeatDMGCd or CurTime()
	if org.temperature > 38 and org.HeatDMGCd < CurTime() and not org.otrub then
		org.painadd = org.painadd + math.Rand(0.5, 1) * ((org.temperature - 38) / 38 * 6 + 1)
		org.HeatDMGCd = CurTime() + 0.5
	end

	org.heatbuff = math.Approach(org.heatbuff, isFreezing and -30 or 30 * MaxWarmMul, (timeValue * 1) * warmLoseMul)

	org.heatbuff = math.Approach(org.heatbuff, 120 * MaxWarmMul, timeValue * math.Clamp(warming * 1, 0, 4))

	//PrintTable(ents.FindInSphere(org.owner:GetPos(), 128))
end)