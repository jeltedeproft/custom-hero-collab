function HuntingAxes(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local starting_offset = ability:GetLevelSpecialValueFor( "starting_offset", ability:GetLevel() - 1 )
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local rotation = speed * ability:GetLevelSpecialValueFor( "rotation", ability:GetLevel() - 1 )
	local cast_range = ability:GetCastRange()

	EmitSoundOn("Hero_Beastmaster.Wild_Axes", caster)

	local casterPos = caster:GetAbsOrigin()
	local casterTeam = caster:GetTeam() 
	local fv = caster:GetForwardVector()

	local diff = point - casterPos
	local diffNormalized = diff:Normalized()

	local axe1 = CreateUnitByName("dummy_unit", casterPos, false, nil, nil, casterTeam)
	local dummy_modifier = axe1:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	axe1.hit = {}
	axe1.rotation = rotation
	ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxe.vpcf", PATTACH_ABSORIGIN_FOLLOW, axe1)
	ability:ApplyDataDrivenModifier(caster, axe1, "modifier_hunting_axe", {})

	local axe2 = CreateUnitByName("dummy_unit", casterPos, false, nil, nil, casterTeam)
	local dummy_modifier = axe2:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxe.vpcf", PATTACH_ABSORIGIN_FOLLOW, axe2)
	axe2.hit = {}
	axe2.rotation = rotation
	ability:ApplyDataDrivenModifier(caster, axe2, "modifier_hunting_axe", {})

	Timers:CreateTimer(0,function()
		axe1:SetAbsOrigin(casterPos)
		axe1:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,starting_offset,0), diffNormalized))
		axe2:SetAbsOrigin(casterPos)
		axe2:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,-starting_offset,0), diffNormalized))
	end)

	Timers:CreateTimer(cast_range/speed,function()
		axe1.retreat = true
		axe2.retreat = true
	end)


end

function HuntingAxesMove(event)
	local caster = event.caster
	local axe = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local dataSpeed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local rotation_gain = dataSpeed * ability:GetLevelSpecialValueFor( "rotation_gain", ability:GetLevel() - 1 )
	local speed = dataSpeed/30

	local axePos = axe:GetAbsOrigin()
	local axeFv = axe:GetForwardVector()

	GridNav:DestroyTreesAroundPoint(axePos, radius, false)
	DestroyRocksAroundPoint(axePos, radius)
	local units = FindUnitsInRadius(axe:GetTeam() , axePos , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		if axe.hit[v] == nil then
			axe.hit[v] = true
			EmitSoundOn("Hero_Beastmaster.Wild_Axes_Damage", v)
			ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_wildaxes_hit.vpcf", PATTACH_ABSORIGIN, v)
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
		end
	end

	if axe.retreat == true then
		local destFv = (caster:GetAbsOrigin() - axePos):Normalized()
		local rotDiff = RotationDelta(VectorToAngles(axeFv), VectorToAngles(destFv))
		local rotation = axe.rotation
	
		if rotDiff.y<0 then
			if rotDiff.y < rotation then
				rotation = -rotation
			else
				rotation = rotDiff.y
			end
		elseif rotDiff.y>0 then
			if rotDiff.y > rotation then
				rotation = rotation
			else
				rotation = rotDiff.y
			end
		else
			rotation = 0
		end
	
		local newFv = RotatePosition(destFv, QAngle(0,rotation,0), axeFv)
		axe:SetForwardVector(newFv)
		axe:SetAbsOrigin(axePos + axeFv * speed)

		axe.rotation = axe.rotation + rotation_gain

		if (axe:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() < 75 then
			axe:RemoveSelf()
		end
	else
		axe:SetAbsOrigin(axePos + axeFv * speed)
	end
end