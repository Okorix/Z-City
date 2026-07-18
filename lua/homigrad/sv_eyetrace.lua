local PLAYER = FindMetaTable("Player")
local oldGetEyeTrace = PLAYER.GetEyeTrace
local oldGetEyeTraceNoCursor = PLAYER.GetEyeTraceNoCursor

local whitelist = {
	weapon_physgun = true,
	gmod_tool = true,
	gmod_camera = true,
}

local function shouldUseHgTrace(ply)
	if not IsValid(ply) then return false end
	if not ply.LookupBone or not ply:LookupBone("ValveBiped.Bip01_Head1") then return false end
	if not ply.GetAimVector then return false end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and whitelist[wep:GetClass()] then return false end

	return true
end

local function hgTrace(ply)
	local ok, tr = pcall(hg.eyeTrace, ply, 8192)
	if ok and tr then return tr end
	return nil
end

function PLAYER:GetEyeTrace(...)
	if shouldUseHgTrace(self) then
		return hgTrace(self) or oldGetEyeTrace(self, ...)
	end
	return oldGetEyeTrace(self, ...)
end

function PLAYER:GetEyeTraceNoCursor(...)
	if shouldUseHgTrace(self) then
		return hgTrace(self) or oldGetEyeTraceNoCursor(self, ...)
	end
	return oldGetEyeTraceNoCursor(self, ...)
end
