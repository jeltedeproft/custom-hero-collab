function Submerge(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )

	local length = (point - caster:GetAbsOrigin()):Length2D()
	local duration = length/speed
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_submerged", {duration = duration})
	Timers:CreateTimer(duration,function()
		--caster:RemoveModifierByName("modifier_submerged")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle, 1, point )
		FindClearSpaceForUnit(caster, point, false)
		EmitSoundOnLocationWithCaster(point, "Hero_Morphling.AdaptiveStrike", caster)
		local units = FindUnitsInRadius(caster:GetTeam() , point , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	    for k,v in pairs(units) do
	    	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_morphling/morphling_base_attack_explosion.vpcf", PATTACH_WORLDORIGIN, v )
			ParticleManager:SetParticleControl( particle, 3, v:GetAttachmentOrigin(v:ScriptLookupAttachment("attach_hitloc")) )
	      	ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	    end

	end)
end