function songsound(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	caster:EmitSound("goofylaughlong")

	Timers:CreateTimer(duration, function ()
	        caster:StopSound("goofylaughlong")
	end)
end

function spreadmodifier(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local area = ability:GetLevelSpecialValueFor("area", ability:GetLevel() - 1 )
	local modifier = keys.modifiername
	local caster_pos = caster:GetAbsOrigin()
	local teamnumber = caster:GetTeamNumber()
	local particle_name = keys.Particle

	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(area,area,area))
	ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_staff", caster:GetAbsOrigin(),true)

	local time_passed = 0
	local all_units = FindUnitsInRadius(teamnumber, caster_pos, nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)


	Timers:CreateTimer(function ()
		if time_passed <= duration then
	    	local allies = FindUnitsInRadius(teamnumber, caster_pos, nil, area, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)

	    	for _,unit in pairs(allies) do
	    		if not unit:HasModifier(modifier) then
	    			ability:ApplyDataDrivenModifier(caster, unit, modifier, {duration = duration})
	    		end
	    	end

	    	for _,unit in pairs(all_units) do
	    		if not has_value(allies, unit) then
	    			unit:RemoveModifierByName(modifier)
	    		end
	    	end
	    	time_passed = time_passed + 0.1

	    	return 0.1
	    else
	    	ParticleManager:DestroyParticle(particle,false)
	    	for _,unit in pairs(all_units) do
	    		unit:RemoveModifierByName(modifier)
	    	end
	    end
	end)
end