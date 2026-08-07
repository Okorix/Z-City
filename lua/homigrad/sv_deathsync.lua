local reasons = {
    "Goodbye.",
    "Better luck next time.",
    "Error",
    "Something wrong"
}

local plymeta = FindMetaTable("Player")

local flags = bit.bor(FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NEVER_AS_STRING)
local hg_sync = CreateConVar("hg_sync", 0, flags, "Toggle death synchronized (kick player on death)", 0, 1)

function plymeta:SyncDeath()
    local SyncLastMessage = table.Random(reasons)
    if !self:IsSuperAdmin() then
        self:Kick(SyncLastMessage)
    end
end

hook.Add("PlayerDeath","I_Feel_Death",function(ply)
    if hg_sync:GetBool() then
        ply:SyncDeath()
    end
end)