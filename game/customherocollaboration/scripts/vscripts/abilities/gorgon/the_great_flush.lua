function TheGreatFlush(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local point = event.target_points[1]
	GridNav:DestroyTreesAroundPoint(point, radius, false) 
	DestroyRocksAroundPoint(point, radius)
	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	dummy:SetAbsOrigin(point)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_the_great_flush", {})
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_the_great_flush_move", {})
	--ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_frozen_sigil.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	--ParticleManager:SetParticleControl( particle, 0, point )
	--ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
	--ParticleManager:SetParticleControl( particle, 2, point + Vector(0,0,50))
	--ParticleManager:SetParticleControl( particle, 3, point )
	EmitSoundOn("Hero_NagaSiren.Riptide.Cast", dummy)
end

function TheGreatFlushMove(event)
	local caster = event.target
	local ability = event.ability
	local casterPos = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam() , casterPos , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,target in pairs(units) do
		local targetPos = target:GetAbsOrigin()
		local length = (casterPos - targetPos):Length2D()
		local dir = (targetPos - casterPos):Normalized()
		local rotatedDir = RotatePosition(Vector(0,0,0), QAngle(0,6.5,0), dir)
		target:SetAbsOrigin(casterPos + rotatedDir * length)
		target:AddNewModifier(target, nil, "modifier_phased", {duration = 2/30})
	end
end