local freelooking, LookX, LookY, InitialAng, CoolAng, ZeroAngle = false, 0, 0, Angle(), Angle(), Angle()

concommand.Add("+freelook", function(ply, cmd, args) freelooking = true end)
concommand.Add("-freelook", function(ply, cmd, args) freelooking = false end)

local function isinsights(ply) -- arccw, arc9, tfa, mgbase
    local weapon = ply:GetActiveWeapon()
    return ix.config.Get("FreelookBlockADS", true) and (ply:KeyDown(IN_ATTACK2) or (weapon.GetInSights and weapon:GetInSights()) or (weapon.ArcCW and weapon:GetState() == ArcCW.STATE_SIGHTS) or (weapon.GetIronSights and weapon:GetIronSights()))
end

local function holdingbind(ply)
    if !input.LookupBinding("freelook") then 
        return ply:KeyDown(IN_WALK)
    else
        return freelooking
    end
end

hook.Add("CalcView", "FreelookView", function(ply, origin, angles, fov)
    if !ply:GetCharacter() then return end
    if !ix.config.Get("FreelookEnabled", true) then return end

    local smoothness = math.Clamp(ix.config.Get("FreelookSmooth", 1), 0.1, 2)

    CoolAng = LerpAngle(0.15 * smoothness, CoolAng, Angle(LookY, -LookX, 0))

    if not holdingbind(ply) and CoolAng.p < 0.05 and CoolAng.p > -0.05 or isinsights(ply) and CoolAng.p < 0.05 and CoolAng.p > -0.05 or not system.HasFocus() or ply:ShouldDrawLocalPlayer() then 
        InitialAng = angles + CoolAng
        LookX, LookY = 0, 0 

        CoolAng = ZeroAngle

        return 
    end

    angles.p = angles.p + CoolAng.p
    angles.y = angles.y + CoolAng.y
end)

hook.Add("CalcViewModelView", "FreelookVM", function(wep, vm, oPos, oAng, pos, ang)
    local lp = LocalPlayer()
    if !lp:GetCharacter() then return end
    if !ix.config.Get("FreelookEnabled", true) then return end

    local MWBased = wep.m_AimModeDeltaVelocity and -1.5 or 1

    ang.p = ang.p + CoolAng.p/2.5 * MWBased
    ang.y = ang.y + CoolAng.y/2.5 * MWBased
end)

hook.Add("InputMouseApply", "FreelookMouse", function(cmd, x, y, ang)
    local lp = LocalPlayer()
    if !lp:GetCharacter() then return end
    if !ix.config.Get("FreelookEnabled", true) then return end

    if not holdingbind(lp) or isinsights(lp) or lp:ShouldDrawLocalPlayer() then LookX, LookY = 0, 0 return end
    
    InitialAng.z = 0
    cmd:SetViewAngles(InitialAng)

    LookX = math.Clamp(LookX + x * 0.02, -ix.config.Get("FreelookLimH", 90), ix.config.Get("FreelookLimH", 90))
    LookY = math.Clamp(LookY + y * 0.02, -ix.config.Get("FreelookLimV", 65), ix.config.Get("FreelookLimV", 65))
    
    return true
end)

hook.Add("StartCommand", "FreelookBlockShoot", function(ply, cmd)
    if !ply:IsPlayer() or !ply:Alive() then return end
    if !ply:GetCharacter() then return end
    if !ix.config.Get("FreelookBlockFire", true) then return end
    
    if not holdingbind(ply) or isinsights(ply) or ply:ShouldDrawLocalPlayer() then return end
    cmd:RemoveKey(IN_ATTACK)
end)