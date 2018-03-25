function mist(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local particle = keys.particlename
	local drainparticle = keys.drainparticlename
	local target = keys.target_points[1]
	local damagetype = ability:GetAbilityDamageType()

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local manacost = ability:GetLevelSpecialValueFor("manacost", ability:GetLevel() - 1 )
	local ancients_hp_loss = ability:GetLevelSpecialValueFor("ancients_hp_loss", ability:GetLevel() - 1 )
	local particle_duration = ability:GetLevelSpecialValueFor("particle_duration", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", (ability:GetLevel() -1))

	local teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local types = DOTA_UNIT_TARGET_ALL
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES

	local earlybreak = false

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = nil,
		damage_type = damagetype,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = ability,
	}

	--apply particle
	local pfx = ParticleManager:CreateParticle(particle, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(pfx, 0, target)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))

	--find neutrals
	local neutrals = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, target, nil, radius, teams, types, flags, FIND_ANY_ORDER, false)

	if TableCount(neutrals) ~= 0 then

		--sort neutrals from low-hp to high-hp
		-- table.sort( neutrals, function (left,right)
		-- 	return left:GetHealth() <= right:GetHealth()
		-- end)

		for _,neutral in ipairs(neutrals) do
			local mana = caster:GetMana()
			local mana_needed = neutral:GetGoldBounty() * manacost
			local hp_loss = 1
			local neutral_hp = neutral:GetHealth()

		   if mana < mana_needed then
		   		-- not enough mana to take this units hp away,stop spell
		   		earlybreak = true
		   		break
		   	else
		   		--we do have enough mana, proceed
		   		if neutral:IsAncient() then
		   			hp_loss = ancients_hp_loss
		   		end

		   		--kill unit and remove mana
		   		-- Apply Damage equal to unit's hp effectively killing the unit
		   		damageTable.victim = neutral
		   		damageTable.damage = neutral_hp
		   		ApplyDamage(damageTable)

		   		caster:SetMana(caster:GetMana() - mana_needed)

		   		-- Create the drain projectile
		   		local info = {
			   		Target = caster,
			   		Source = neutral,
			   		Ability = ability,
			   		EffectName = drainparticle,
			   		bDodgeable = false,
			   		bProvidesVision = false,
			   		iMoveSpeed = projectile_speed,
			   		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		   		}
		   		ProjectileManager:CreateTrackingProjectile( info )
		   	end

		    if earlybreak then
		   		break
		   	end
		end
	end

	--remove particle
	Timers:CreateTimer(particle_duration, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end