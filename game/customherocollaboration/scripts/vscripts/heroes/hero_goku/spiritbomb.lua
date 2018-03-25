function spiritbombdummy( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local target_point = caster:GetAbsOrigin()
	local ability_level = ability:GetLevel() - 1
	local dummy_modifier = keys.dummy_aura

	local height = ability:GetLevelSpecialValueFor("height", ability_level)
	local charge_time = ability:GetLevelSpecialValueFor("charge_time", ability_level)

	-- Dummy
	local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = charge_time})

	ability.spiritdummy = dummy	
end

function chargespiritbomb( keys )
	local particle = keys.particlename
	local particle_bigger = keys.particlename_bigger
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local dummy = keys.target
	local center = dummy:GetAbsOrigin()

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local height = ability:GetLevelSpecialValueFor("height", ability_level)

	--talent
	local talent = caster:FindAbilityByName("goku_spirit_bomb_radius_bonus")

	if talent:GetLevel() > 0 then
		particle = particle_bigger
		radius = radius + talent:GetSpecialValueFor("value")
	end

	local upwards_vector = Vector(0,0,height)
	local new_target = center + upwards_vector

	-- Create particle
	local chrono_pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
	ParticleManager:SetParticleControl(chrono_pfx, 0, new_target)
	ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(radius, radius, 0))

	ability.spiritpfx = chrono_pfx
end

function StopSound( keys )
	StopSoundEvent( keys.soundname, keys.caster )
end


function stopcharge( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local dummy_modifier = keys.dummy_aura

	local dummy = ability.spiritdummy

	dummy:RemoveModifierByName("dummy_modifier")
	dummy:RemoveSelf()

	--destoy particle
	local pfx = ability.spiritpfx
	ParticleManager:DestroyParticle( pfx, false )
end

function move_spirit_bomb( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local caster_team = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target_points[1]
	local forward = (target - origin):Normalized()
	local damagetype = ability:GetAbilityDamageType()

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	local distance = (target - origin):Length2D()
	local traveled_distance = 0

	local dummy = ability.spiritdummy
	local dummy_location = dummy:GetAbsOrigin()

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_CREEP
	local flags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = damagetype,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = ability,
	}

	-- Moving the dummy
	Timers:CreateTimer(0, function()
		dummy_location = dummy_location + (forward * speed) * 0.03
		traveled_distance = (dummy_location - origin):Length2D()
		FindClearSpaceForUnit(dummy, dummy_location, false)

		--not reached end of the field
		if traveled_distance < distance then
			ParticleManager:SetParticleControl(ability.spiritpfx, 0, dummy_location)
			return 0.03
		else
			--apply explosion pfx
			local explosion =	ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf",
					PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(explosion, 0, dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(explosion, 3, dummy:GetAbsOrigin())

			--apply damage
			local enemies = FindUnitsInRadius(caster_team, target, nil, radius, teams, types, flags, FIND_ANY_ORDER, false)
			local neutrals = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, target, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, flags, FIND_ANY_ORDER, false)

			for _,enemy in pairs(enemies) do
			   -- Apply Damage
			   	damageTable.victim = enemy
			   	ApplyDamage(damageTable)
			end

			for _,neutral in pairs(neutrals) do
			   -- Apply Damage
			   	damageTable.victim = neutral
			   	ApplyDamage(damageTable)
			end
			
			--remove everything
			dummy:RemoveModifierByName("dummy_modifier")
			dummy:RemoveSelf()

			--destoy spirit bomb particle
			local pfx = ability.spiritpfx
			ParticleManager:DestroyParticle( pfx, false )

			--destoy explosion particle
			ParticleManager:DestroyParticle( explosion, false )
		end
	end)
end