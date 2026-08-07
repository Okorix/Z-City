local MaxLookX,MinLookX = 55,-55
local MaxLookY,MinLookY = 45,-45

util.AddNetworkString("LookAway")
net.Receive("LookAway",function(len,ply)
	if len > 64 or !IsValid(ply) then return end
	if !ply:Alive() then return end
	if (ply.cooldown_lookaway or 0) > CurTime() then return end
	ply.cooldown_lookaway = CurTime() + 0.1

	local rf = RecipientFilter()
	rf:AddPVS(ply:GetPos())
	rf:RemovePlayer(ply)

	local MaxLookX,MinLookX = hg.MaxLookX or MaxLookX, hg.MinLookX or MinLookX
	local MaxLookY,MinLookY = hg.MaxLookY or MaxLookY, hg.MinLookY or MinLookY

	local LookX = net.ReadFloat()
	local LookY = net.ReadFloat()

	-- THE MOST TERIBLE EXPLOIT EVER!!!!!!
	if ( LookX > MaxLookX or LookX < MinLookX ) or ( LookY > MaxLookY or LookY < MinLookY ) then
		hg.BreakNeck(ply)
	end

	net.Start("LookAway", true)
		net.WriteEntity(ply)
		net.WriteFloat(LookX)
		net.WriteFloat(LookY)
	net.Send(rf)
end)