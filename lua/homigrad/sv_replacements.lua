hook.Add( "PostCleanupMap", "MapReadyHook", function() hook.Run("MapReady") end)
hook.Add("InitPostEntity", "MapReadyHook", function() hook.Run("MapReady") end)


local TrackedEnts = {
	["weapon_crowbar"]={"weapon_hg_crowbar"},
	["weapon_stunstick"]={"weapon_pocketknife"},
	["weapon_pistol"]={"weapon_hk_usp"},
	["weapon_357"]={"weapon_revolver2"},
	["weapon_shotgun"]={"weapon_remington870"},
	["weapon_crossbow"]={"weapon_ar15","weapon_mp7"},
	["weapon_ar2"]={"weapon_akm","weapon_m4a1"},
	["weapon_smg1"]={"weapon_mp7"},
	["weapon_slam"]={"weapon_hg_molotov_tpik"},
	["weapon_rpg"]={"*ammo*"},
	["item_ammo_ar2_altfire"]={"weapon_hg_molotov_tpik"},
	["item_ammo_357"]={"*ammo*"},
	["item_ammo_357_large"]={"*ammo*"},
	["item_ammo_pistol"]={"*ammo*"},
	["item_ammo_pistol_large"]={"*ammo*"},
	["item_ammo_ar2"]={"*ammo*"},
	["item_ammo_ar2_large"]={"*ammo*"},
	["item_ammo_ar2_smg1"]={"*ammo*"},
	["item_ammo_ar2_large"]={"*ammo*"},
	["item_ammo_smg1"]={"*ammo*"},
	["item_ammo_smg1_large"]={"*ammo*"},
	["item_box_buckshot"]={"*ammo*"},
	["item_box_buckshot_large"]={"*ammo*"},
	["item_rpg_round"]={"*ammo*"},
	["item_healthvial"]={"weapon_bandage_sh"},
	["item_healthkit"]={"weapon_medkit_sh"},
	["item_battery"]={"weapon_painkillers"},
	["item_suit"]={"*ammo*"},
	["weapon_alyxgun"] = {"weapon_smallconsumable","weapon_bigconsumable"},
	["weapon_frag"] = {"weapon_hg_hl2nade_tpik"},
	["Grenade"] = {"weapon_hg_hl2nade_tpik"},
	["npc_grenade_frag"] = {"ent_hg_grenade_hl2grenade"},
	["ent_jack_hmcd_ducttape"] = {"weapon_ducttape"},
}

local TrackedEntsHalfLife = {
	["weapon_crowbar"]={"weapon_hg_crowbar"},
	["weapon_stunstick"]={"weapon_hg_stunstick"},
	["weapon_pistol"]={"weapon_hk_usp"},
	["weapon_357"]={"weapon_revolver357"},
	["weapon_shotgun"]={"weapon_spas12"},
	["weapon_crossbow"]={"weapon_hg_crossbow"},
	["weapon_ar2"]={"weapon_osipr"},
	["weapon_smg1"]={"weapon_mp7"},
	["weapon_slam"]={"weapon_hg_slam"},
	["weapon_rpg"]={"weapon_hg_rpg"},
	["item_ammo_357"]={"ent_ammo_.357magnum"},
	["item_ammo_357_large"]={"ent_ammo_.357magnum"},
	["item_ammo_pistol"]={"ent_ammo_9x19mmparabellum"},
	["item_box_srounds"]={"ent_ammo_9x19mmparabellum"},
	["item_ammo_pistol_large"]={"ent_ammo_9x19mmparabellum"},
	["item_ammo_ar2"]={"ent_ammo_pulse"},
	["item_ammo_ar2_large"]={"ent_ammo_pulse"},
	["item_ammo_ar2_altfire"]={"ent_ammo_pulse"},--TODO: add altfire!!!!
	["item_ammo_smg1"]={"ent_ammo_4.6x30mm"},
	["item_box_mrounds"]={"ent_ammo_4.6x30mm"},
	["item_ammo_smg1_grenade"]={"ent_ammo_4.6x30mm"},--add smg grenade
	["item_ar2_grenade"]={"ent_ammo_4.6x30mm"},--add smg grenade
	["item_ammo_crossbow"]={"ent_ammo_armature"},
	["item_ammo_smg1_large"]={"ent_ammo_4.6x30mm"},
	["item_box_buckshot"]={"ent_ammo_12/70gauge","ent_ammo_12/70slug"},
	["item_box_buckshot_large"]={"ent_ammo_12/70gauge","ent_ammo_12/70slug"},
	["item_rpg_round"]={"ent_ammo_rpg-7projectile"},
	["item_healthvial"]={"weapon_bandage_sh","item_healthvial"},
	["item_healthkit"]={"weapon_medkit_sh","item_healthkit"},
	["item_battery"]={"weapon_painkillers","item_battery"},
	["item_suit"]={"item_suit"},
	["ent_hmcd_mansion_cup"]={"weapon_hg_mug"},
	["ent_hmcd_mansion_knife"]={"weapon_pocketknife"},
	["ent_hmcd_mansion_cuestick"]={"weapon_hg_spear"},
}

local TrackedModels = {
	["models/props_interiors/pot02a.mdl"] = "ent_armor_helmet4",
	["models/props_c17/metalPot002a.mdl"] = "weapon_pan",
	["models/props_junk/Shovel01a.mdl"] = "weapon_hg_shovel",
	["models/props_junk/glassbottle01a.mdl"] = "weapon_hg_bottle",
	["models/props_junk/glassbottle01a_chunk01a.mdl"] = "weapon_hg_bottlebroken",
	["models/props_junk/garbage_glassbottle003a.mdl"] = "weapon_hg_bottle",
	["models/props_junk/garbage_glassbottle003a_chunk01.mdl"] = "weapon_hg_bottlebroken",
	["models/props_canal/mattpipe.mdl"] = "weapon_leadpipe",
	["models/props_junk/harpoon002a.mdl"] = "weapon_hg_spear",
	["models/props_junk/garbage_coffeemug001a.mdl"] = "weapon_hg_mug",
	["models/props/cs_office/fire_extinguisher.mdl"] = "weapon_hg_extinguisher",
	["models/weapons/w_fire_extinguisher.mdl"] = "weapon_hg_extinguisher",
	["models/props_junk/glassbottle01a_chunk01a.mdl"] = "weapon_hg_bottlebroken",
	["models/props/CS_militia/axe.mdl"] = "weapon_hg_axe",
	["models/weapons/w_knife_t.mdl"] = "weapon_pocketknife",
	["models/weapons/w_knife_ct.mdl"] = "weapon_pocketknife",
	["models/props_canal/mattpipe.mdl"] = "weapon_leadpipe",
}

for str, ent in pairs(TrackedModels) do
	TrackedModels[string.lower(str)] = ent
end

local TrackedEntsNpc = table.Copy(TrackedEnts)

TrackedEntsNpc["weapon_ar2"] = {"weapon_osipr"}
TrackedEntsNpc["weapon_crowbar"] = {"weapon_bat"}
TrackedEntsNpc["weapon_stunstick"] = {"weapon_hg_stunstick"}
TrackedEntsNpc["weapon_shotgun"] = {"weapon_spas12"}
TrackedEntsNpc["npc_grenade_frag"] = {"ent_hg_grenade_hl2grenade"}

local kvExceptions = {
	["attach1"] = true,
	["attach2"] = true,
	["hammerid"] = true
}

local mapExceptions = {
    ["ttt_clue_2022"] = {
        "models/props_canal/mattpipe.mdl",
    },
}
 
local function isMapException(map, model)
    local models = mapExceptions[map]
    if not models then return false end
 
    for _, exceptionModel in ipairs(models) do
        if exceptionModel == model then return true end
    end
 
    return false
end

local ReplaceEntCD = 0
hook.Add("PreCleanupMap","ReplaceEntCD",function()
	ReplaceEntCD = CurTime() + 5
end)

hook.Add("OnEntityCreated", "ReplaceEnt", function(ent)
    hook.Run("ZB_OnEntCreated", ent)
    if OverrideWeaponSpawn then return end

	if not IsValid(ent) then return end
	
	timer.Simple(ReplaceEntCD > CurTime() and 5 or 0, function()
		if not IsValid(ent) then return end

		local isTrackedClass = TrackedEnts[ent:GetClass()] or TrackedEntsHalfLife[ent:GetClass()]
		local isTrackedModel = TrackedModels[ent:GetModel()]
		if not isTrackedClass and not isTrackedModel then return end
		
		local function doReplace()
			local entclass = ent:GetClass()
			local model = string.lower(ent:GetModel())
			
			if TrackedModels[model] then
				local isProp = string.find(entclass, "prop_") ~= nil
				local mapException = isMapException(game.GetMap(), model)
				if isProp and mapException and not ent.notprop then
					return
				end
			end


			local replacementEnt = (CurrentRound and CurrentRound().name == "coop" and TrackedEntsHalfLife[entclass])
				or TrackedEnts[entclass]
				or TrackedModels[model]

			if istable(replacementEnt) then
				replacementEnt = table.Random(replacementEnt)
			end

			if replacementEnt == "*ammo*" then
				replacementEnt = "ent_ammo_" .. table.Random(hg.ammotypeshuy).name
			end

			if not replacementEnt or replacementEnt == "" or replacementEnt == entclass then return end
			if not IsValid(ent) then return end

			if entityio and entityio.HasConnections(ent) then
				return
			end

			OverrideWeaponSpawn = true

			local owner = ent.GetOwner and ent:GetOwner()
			local entPos = ent:GetPos()
			local entAngles = ent:GetAngles()
			local oldPhys = ent:GetPhysicsObject()
			local vel = ent:GetVelocity()
			if IsValid(oldPhys) then
				oldPhys:EnableMotion(false)
			end

			if IsValid(oldPhys) then
				vel = oldPhys:GetVelocity()
			end
			
			local physCons = {}
			local entName = ent:GetName()

			for _, v in pairs(ents.GetAll()) do
				if not IsValid(v) then continue end
				if not string.StartsWith(v:GetClass(), "phys_") then continue end

				local kv = v:GetKeyValues()
				if entName == "" then continue end

				if kv.attach1 == entName or kv.attach2 == entName then
					physCons[v] = {
						kv = kv,
						attach1 = kv.attach1,
						attach2 = kv.attach2,
					}
				end
			end

			SafeRemoveEntity(ent)

			if owner and owner:IsNPC() and entclass ~= "npc_grenade_frag" then
				local npcReplacements = TrackedEntsNpc[entclass]
				if not npcReplacements or #npcReplacements == 0 then
					OverrideWeaponSpawn = false
					return
				end

				local cap = owner:CapabilitiesGet()
				if bit.band(cap, CAP_USE_WEAPONS) != CAP_USE_WEAPONS then
					OverrideWeaponSpawn = false
					return
				end

				owner:Give(npcReplacements[math.random(#npcReplacements)])
				OverrideWeaponSpawn = false
				return
			end

			local Replacement = ents.Create(replacementEnt)
			if not IsValid(Replacement) then
				OverrideWeaponSpawn = false
				return
			end

			Replacement.dontAddPos = true
			Replacement:SetPos(entPos)
			Replacement:SetAngles(entAngles)
			Replacement.IsSpawned = true
			Replacement.init = true
			Replacement:Spawn()

			local newPhys = Replacement:GetPhysicsObject()
			if IsValid(newPhys) then
				newPhys:EnableMotion(false)
			end

			for consEnt, data in pairs(physCons) do
				local kv = data.kv

				local ent1 = (data.attach1 == entName) and Replacement or ents.FindByName(data.attach1)[1]
				local ent2 = (data.attach2 == entName) and Replacement or ents.FindByName(data.attach2)[1]

				local phys1 = IsValid(ent1) and ent1:GetPhysicsObject() or Entity(0):GetPhysicsObject()
				local phys2 = IsValid(ent2) and ent2:GetPhysicsObject() or Entity(0):GetPhysicsObject()

				local newCons = ents.Create(consEnt:GetClass())
				newCons:SetPos(consEnt:GetPos())
				for kvName, kvValue in pairs(data.kv) do
					if not kvExceptions[kvName] then
						newCons:SetKeyValue(kvName, tostring(kvValue))
					end
				end
				newCons:SetPhysConstraintObjects(phys1, phys2)
				newCons:Spawn()
				newCons:Activate()
				if IsValid(consEnt) then
					consEnt:Fire("TurnOff")
					consEnt:Fire("Break")
				end
			end

			if owner then
				Replacement.owner = owner
			end

			if IsValid(newPhys) then
				newPhys:SetVelocity(vel)
			end

			timer.Simple(2, function()
				if IsValid(newPhys) then
                    newPhys:Wake()
					newPhys:EnableMotion(true)
				end
			end)

			if entclass == "npc_grenade_frag" then
				Replacement.timer = CurTime()
			end

			OverrideWeaponSpawn = false
		end

		timer.Simple(0.1, function()
			if not IsValid(ent) then return end
			local conTable = constraint.GetTable(ent)
			if conTable and #conTable > 0 then return end
			doReplace()
		end)
	end)
end)

local mansionItemsReplacementTbl = {
	["hmcd_cuess"] = "wep_hmcd_mansion_cuestick",
	["hmcd_pokers"] = "wep_hmcd_mansion_poker",
	["hmcd_pencil"] = "wep_hmcd_mansion_pencils",
	["hmcd_knives"] = "wep_hmcd_mansion_knife",
	["hmcd_cup"] = "weapon_hg_mug",
	["hmcd_food"] = "weapon_bigconsumable",
	["hmcd_sheet"] = "ent_hmcd_mansion_sheet",
}

local function replaceMansionItems()
	for i,v in pairs(mansionItemsReplacementTbl) do
		for k,ent in pairs(ents.FindByName(i)) do
			local pos = ent:GetPos()
			local ang = ent:GetAngles()
			ent:Remove()

			local newEnt = ents.Create(v)
			newEnt:SetPos(pos)
			newEnt:SetAngles(ang)
			newEnt:Spawn()
			newEnt.init = true
			newEnt.IsSpawned = true
			newEnt:GetPhysicsObject():EnableMotion(false)
			timer.Simple(1, function()
				if IsValid(newEnt) and IsValid(newEnt:GetPhysicsObject()) then
					newEnt:GetPhysicsObject():EnableMotion(true)
				end
			end)
		end
	end
end

hook.Add("MapReady", "replaceMansionItems", replaceMansionItems)

local canisterModels = {
	["models/props_c17/canister01a.mdl"] = true,
    ["models/props_c17/canister02a.mdl"] = true,
    ["models/props_c17/canister_propane01a.mdl"] = true,
	["models/props_junk/propanecanister001a.mdl"] = true
}

local function setupCanister(ent)
    if not IsValid(ent) then return end

    local model = string.lower(ent:GetModel() or "")
    if not canisterModels[model] then return end
    if ent:GetClass() == "physics_cannister" then return end

    local pos = ent:GetPos()
    local ang = ent:GetAngles()
    SafeRemoveEntityDelayed(ent, 0.1)

	timer.Simple(0.1, function()
	    local canister = ents.Create("physics_cannister")
		if not IsValid(canister) then return end

		canister:SetModel(model)
		canister:SetPos(pos)
		canister:SetAngles(ang)
		canister:SetKeyValue("gassound", "ambient/gas/cannister_loop.wav")
		canister:SetKeyValue("renderamt", "255")
		canister:SetKeyValue("rendercolor", "255 255 255")

		canister:Spawn()

		local physObj = canister:GetPhysicsObject()
		if IsValid(physObj) then
			physObj:Wake()

			local mass = math.floor(physObj:GetMass())
			local thrust = math.floor(mass * 50)
			local fuel = math.floor(mass * 0.5)
			local health = math.floor(mass * 3)

			canister:SetKeyValue("health", tostring(health))
			canister:SetKeyValue("thrust", tostring(thrust))
			canister:SetKeyValue("fuel", tostring(fuel))
		end
	end)
end

local function replaceCanisters()
    for model, _ in pairs(canisterModels) do
        for _, ent in pairs(ents.FindByModel(model)) do
            timer.Simple(1, function()
				setupCanister(ent)
			end)
        end
    end
end

hook.Add("MapReady", "replaceCanisters", replaceCanisters)
hook.Add("OnEntityCreated", "replaceCanisters", function(ent)
	timer.Simple(0, function()
		local conTable = constraint.GetTable(ent)
		if conTable and #conTable > 0 then return end
		setupCanister(ent)
	end)
end)


function hg.CreateJeepSeats(ent)
	local seatsDebug = false
	timer.Simple(0.1, function()
		if !IsValid(ent) then return end

		local entang = ent:GetAngles()
		local pos = ent:GetPos() + entang:Right() * 37 + entang:Forward() * 14 + entang:Up() * 18
		local chair = ents.Create("prop_vehicle_prisoner_pod")
		chair:SetModel("models/nova/jeep_seat.mdl")
		chair:SetKeyValue( "limitview", 0 )
		chair.shitass = true
		chair:SetPos(pos)
		chair:SetAngles(entang)
		chair:SetColor4Part(255, 255, 255, 255)
		chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
		chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		chair:Spawn()
		chair:SetVehicleEntryAnim(false)

		local weld = constraint.Weld(chair, ent, 0, 0, 0, true, true)

		local physobj = chair:GetPhysicsObject()
		if physobj:IsValid() then
			physobj:EnableCollisions(false)
		end

		local entang = ent:GetAngles()
		local pos = ent:GetPos() + entang:Right() * 70 + entang:Up() * 75
		local chair = ents.Create("prop_vehicle_prisoner_pod")
		chair:SetModel("models/nova/airboat_seat.mdl")
		chair:SetKeyValue( "limitview", 0 )
		chair.shitass = true
		chair:SetPos(pos)
		chair:SetAngles(entang + Angle(0, 0, 0))
		chair:SetColor4Part(255, 255, 255, seatsDebug and 255 or 0)
		chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
		chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		chair:Spawn()
		chair:SetVehicleEntryAnim(false)

		local weld = constraint.Weld( chair, ent, 0, 0, 0, true, true )

		local physobj = chair:GetPhysicsObject()
		if physobj:IsValid() then
			physobj:EnableCollisions(false)
		end

		local entang = ent:GetAngles()
		local pos = ent:GetPos() + entang:Right() * 90 + entang:Up() * 45 + entang:Forward() * 30
		local chair = ents.Create("prop_vehicle_prisoner_pod")
		chair:SetModel("models/nova/airboat_seat.mdl")
		chair:SetKeyValue( "limitview", 0 )
		chair.shitass = true
		chair:SetPos(pos)
		chair:SetAngles(entang+Angle(0,-90,0))
		chair:SetColor4Part(255,255,255,seatsDebug and 255 or 0)
		chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
		chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		chair:Spawn()
		chair:SetVehicleEntryAnim(false)

		local weld = constraint.Weld(chair, ent, 0, 0, 0, true, true)

		local physobj = chair:GetPhysicsObject()
		if physobj:IsValid() then
			physobj:EnableCollisions(false)
		end

		local entang = ent:GetAngles()
		local pos = ent:GetPos() + entang:Right() * 90 + entang:Up() * 45 + entang:Forward() * -30
		local chair = ents.Create("prop_vehicle_prisoner_pod")
		chair:SetModel("models/nova/airboat_seat.mdl")
		chair:SetKeyValue( "limitview", 0 )
		chair.shitass = true
		chair:SetPos(pos)
		chair:SetAngles(entang + Angle(0, 90, 0))
		chair:SetColor4Part(255, 255, 255, seatsDebug and 255 or 0)
		chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
		chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		chair:Spawn()
		chair:SetVehicleEntryAnim(false)

		local weld = constraint.Weld(chair, ent, 0, 0, 0, true, true)

		local physobj = chair:GetPhysicsObject()
		if physobj:IsValid() then
			physobj:EnableCollisions(false)
		end
	end)
end

function hg.CreateAirboatSeats(ent)
	local seatsDebug = false
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		ent:GetPhysicsObject():SetMass(ent:GetPhysicsObject():GetMass() * 2)
		for i = 1, 4 do
			local entang = ent:GetAngles()
			local pos = ent:GetPos() + entang:Right() * 25 * i + entang:Forward() * 25 + entang:Up() * 20 + entang:Right() * -60
			local chair = ents.Create("prop_vehicle_prisoner_pod")
			chair:SetModel("models/nova/airboat_seat.mdl")
			chair:SetKeyValue( "limitview", 0 )
			chair.shitass = true
			chair:SetPos(pos)
			chair:SetAngles(entang + Angle(0, -80, 0))
			chair:SetColor4Part(255, 255, 255, seatsDebug and 255 or 0)
			chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
			chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			chair:Spawn()
			chair:SetVehicleEntryAnim(false)

			local weld = constraint.Weld(chair, ent, 0, 0, 0, true, true)

			local physobj = chair:GetPhysicsObject()
			if physobj:IsValid() then
				physobj:EnableCollisions(false)
			end
		end

		for i = 1, 4 do
			local entang = ent:GetAngles()
			local pos = ent:GetPos() + entang:Right() * 25 * i + entang:Forward() * -25 + entang:Up() * 20 + entang:Right() * -60
			local chair = ents.Create("prop_vehicle_prisoner_pod")
			chair:SetModel("models/nova/airboat_seat.mdl")
			chair:SetKeyValue( "limitview", 0 )
			chair.shitass = true
			chair:SetPos(pos)
			chair:SetAngles(entang + Angle(0, 80, 0))
			chair:SetColor4Part(255, 255, 255, seatsDebug and 255 or 0)
			chair:SetRenderMode(RENDERGROUP_TRANSLUCENT)
			chair:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			chair:Spawn()
			chair:SetVehicleEntryAnim(false)

			local weld = constraint.Weld(chair, ent, 0, 0, 0, true, true)

			local physobj = chair:GetPhysicsObject()
			if physobj:IsValid() then
				physobj:EnableCollisions(false)
				physobj:SetMass(1)
			end
		end
	end)
end

hook.Add("OnEntityCreated", "FunnySimfphys", function(ent)
	if IsValid(ent) and ent:GetClass() == "prop_vehicle_jeep" then
		timer.Simple(0, function()
			if !IsValid(ent) then return end
			local conTable = constraint.GetTable(ent)
			if conTable and #conTable > 0 then return end
			local pos, ang = ent:GetPos(), ent:GetAngles()
			pos = pos + vector_up * 10

			SafeRemoveEntity(ent)
			local ent2 = simfphys.SpawnVehicleSimple( "sim_fphys_jeep", pos, ang)
			hg.CreateJeepSeats(ent2)
		end)
	end
end)

hook.Add("PlayerSpawnedVehicle","FunnySimfphysPlayers",function(ply,ent)
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		local conTable = constraint.GetTable(ent)
		if conTable and #conTable > 0 then return end
		if ent.VehicleName and ent.VehicleName == "sim_fphys_jeep" then
			hg.CreateJeepSeats(ent)
		end
	end)
end)