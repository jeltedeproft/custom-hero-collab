function Slam(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local force = ability:GetLevelSpecialValueFor( "force", ability:GetLevel() - 1 )
	local casterPos = caster:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeam()  , casterPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		local targetPos = v:GetAbsOrigin()
		local diff = targetPos - casterPos
		diffNormalized = diff:Normalized()
		v:AddPhysicsVelocity(diffNormalized * force)
	end
end