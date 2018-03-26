function JuggernautsChargeStart(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	ability.hit = {}
	local point = event.target_points[1]
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local diff = (point-casterPos):Length2D()
	local dir = (point-casterPos):Normalized()
	caster:SetForwardVector(dir)
	ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_flame_immortal1.vpcf", PATTACH_ABSORIGIN, caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_juggernauts_charge", {duration =diff/speed})
end

function JuggernautsChargeMove(event)
	local caster = event.target
	local casterPos = caster:GetAbsOrigin()
	local casterFv = caster:GetForwardVector()
	local ability = event.ability
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30
	local push_speed = ability:GetLevelSpecialValueFor( "push_speed", ability:GetLevel() - 1 )/30
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )

	GridNav:DestroyTreesAroundPoint(casterPos, radius, false) 
	DestroyRocksAroundPoint(casterPos, radius)

	local units = FindUnitsInRadius(caster:GetTeam() , casterPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		if ability.hit[v] ~= true then
			ability.hit[v] = true
			ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		end
		local rotation = 0
		local targetPos = v:GetAbsOrigin()
		local dir = (targetPos - casterPos):Normalized()
		local rotDiff = RotationDelta(VectorToAngles(casterFv), VectorToAngles(dir))
		if rotDiff.y > 0 then
			rotation = 90
		elseif rotDiff.y < 0 then
			rotation = -90
		end
		local newFv = RotatePosition(Vector(0,0,0), QAngle(0,rotation,0), casterFv)
		v:SetAbsOrigin(targetPos + newFv * push_speed)
		v:AddNewModifier(v, nil, "modifier_phased", {duration = 1/30})
	end


	caster:SetAbsOrigin(casterPos + casterFv * speed)
	caster:AddNewModifier(v, nil, "modifier_phased", {duration = 1/30})
end