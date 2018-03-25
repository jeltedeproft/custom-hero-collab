function kamehameha(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local particle = keys.particlename
	local target = keys.target_points[1]
	local direction = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local damagetype = ability:GetAbilityDamageType()

	local speed = ability:GetLevelSpecialValueFor("speed", ability:GetLevel() - 1 )
	local width = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_CREEP
	local flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE

	--talent
	local talent = caster:FindAbilityByName("goku_kamehameha_range")

	if talent:GetLevel() > 0 then
		distance = distance + talent:GetSpecialValueFor("value")
	end

	--endposition
	local endpos = caster_location + direction * distance

	-- Create particle FX
	pfx = ParticleManager:CreateParticle( particle, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( pfx, 1, endpos )

	local units = FindUnitsInLine(caster:GetTeam(), caster_location, endpos, caster, width, teams, types, flags)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = damagetype,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = ability,
	}
	 
	for _,unit in pairs(units) do
	   -- Apply Damage
	   	damageTable.victim = unit
	   	ApplyDamage(damageTable)
	end

		Timers:CreateTimer(duration, function ()
	        ParticleManager:DestroyParticle( pfx, false )
		end)
end

function StopSound( keys )
	StopSoundEvent( keys.soundname, keys.caster )
end

function cleanupstartparticle( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local modifier = keys.modifiername

	if caster:HasModifier(modifier) then
		caster:RemoveModifierByName(modifier)
	end
end