function JokerPulseBullet(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local dir = point - caster:GetAbsOrigin()
	dir.z = 0
	dir = dir:Normalized()
	local particle = nil
	local bullet = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
	local dummy_modifier = bullet:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)

	Timers:CreateTimer(function()
		bullet:SetForwardVector(dir)
		particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/joker_pulse_bullet/joker_fire_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, bullet)
	end)
	Timers:CreateTimer(function()
		if IsValidEntity(bullet) == false then
			return
		end
		local pos = bullet:GetAbsOrigin()
		local groundPos = GetGroundPosition(pos, bullet)
		bullet:SetAbsOrigin(groundPos + Vector(0,0,120))
		if IsValidEntity(bullet) then
			return 0.03
		end
	end)
	ability:ApplyDataDrivenModifier(caster, bullet, "dummy_joker_pulse_bullet_passive_modifier", {duration = 1.8})
end

function JokerTick(event)
	local caster = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam() , caster:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()

	-- if IsOutOfBounds(caster:GetAbsOrigin()) == true then
	-- 	local pos = Entities:FindByName(nil, "target_predator_spawn"):GetAbsOrigin()
	-- 	caster:SetAbsOrigin(pos)
	-- 	origin = pos
	-- 	local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/joker_blink/joker_spell_blink.vpcf", PATTACH_ABSORIGIN, caster)
	-- 	ParticleManager:SetParticleControl( particle, 0, pos + Vector(0,0,50))
	-- end


	local front_position = origin + fv * 30
	for k,v in pairs(units) do
		if IsValidEntity(v) then
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
			local push = v:GetAbsOrigin() + fv * 30
			FindClearSpaceForUnit(v, push, false)
			v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
		end
	end
	caster:SetAbsOrigin(front_position)
end
