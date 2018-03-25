function RoshanSlam( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow
	local modifier_armor = keys.modifier_armor
	local sound_cast = keys.sound_cast
	local particle_slam = keys.particle_slam

	-- Parameters
	local slam_radius = ability:GetSpecialValueFor("slam_radius")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local caster_loc = caster:GetAbsOrigin()

	--talent
	local talent = caster:FindAbilityByName("golem_slam_bonus_damage")

	if talent:GetLevel() > 0 then
		base_damage = base_damage + talent:GetSpecialValueFor("value")
	end


	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local slam_pfx = ParticleManager:CreateParticle(particle_slam, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(slam_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(slam_pfx, 1, Vector(slam_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(slam_pfx)

	-- Iterate through targets
	local slam_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slam_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(slam_targets) do
		
		-- Apply slow and armor debuffs
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})

		-- Deal damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = base_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end

	-- Trigger reduced cooldown
	Timers:CreateTimer(0.1, function()
		ability:EndCooldown()
		ability:StartCooldown(math.max(ability:GetCooldown(1) - #slam_targets, 1))
	end)
end