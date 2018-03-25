function releasesouls( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local level 			= ability:GetLevel() - 1
	local damage_per_charge	= ability:GetLevelSpecialValueFor("damage_per_charge", level)
	local damage_aoe		= ability:GetLevelSpecialValueFor("damage_aoe", level)
	local line_count		= ability:GetLevelSpecialValueFor("line_count", level)
	local mana_cost_per_permanent_charge		= ability:GetLevelSpecialValueFor("mana_cost_per_permanent_charge", level)
	local modifier_temporary= "modifier_death_charge_stack_counter_temporary"
	local modifier_permanent= "modifier_death_charge_stack_counter_permanent"
	local current_permanent_souls 	= caster:GetModifierStackCount(modifier_permanent, ability)
	local current_temporary_souls 	= caster:GetModifierStackCount(modifier_temporary, ability)
	local location 			= caster:GetAbsOrigin()
	local particle_caster_souls          = keys.particlesouls
	local particle_caster_ground          = keys.particleground

	--talent
	local talent = caster:FindAbilityByName("haunter_wings_damage_bonus")

	if talent:GetLevel() > 0 then
		damage_per_charge = damage_per_charge + talent:GetSpecialValueFor("value"))
	end

	local total_damage = damage_per_charge * (current_permanent_souls + current_temporary_souls)
	local mana_to_expend = current_permanent_souls * mana_cost_per_permanent_charge
	local caster_mana = caster:GetMana()

	if caster_mana < mana_to_expend then
		UTIL_MessageText(caster:GetPlayerID(),"not enough mana",255,0,0,150)--needs fix
		return
	end

	caster:SetModifierStackCount(modifier_temporary, ability, 0)

	if not ability then
		return nil
	end

	-- Add particles for the caster
	local particle_caster_souls_fx = ParticleManager:CreateParticle(particle_caster_souls, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 1, Vector(6, 0, 0))
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_caster_souls_fx)

	-- Add particles for the ground
	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(6, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)

	-- Add particles for the lines
	-- Calculate the first line location, in front of the caster
	local line_position = caster:GetAbsOrigin() + caster:GetForwardVector() * damage_aoe

	-- Create the first line
	CreateRequiemSoulLine(caster, ability, line_position, death_cast)

	-- Calculate the location of every other line
	local qangle_rotation_rate = 360 / line_count
	for i = 1, line_count - 1 do
	    local qangle = QAngle(0, qangle_rotation_rate, 0)
	    line_position = RotatePosition(caster:GetAbsOrigin(), qangle, line_position)

	    -- Create every other line
	    CreateRequiemSoulLine(caster, ability, line_position, death_cast)
	end

	local damageTable = {}
	damageTable.attacker 	= caster
	damageTable.ability 	= ability
	damageTable.damage_type = DAMAGE_TYPE_MAGICAL

	local unitsToDamage 	= FindUnitsInRadius(caster:GetTeam(), location, nil, damage_aoe, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	
	for _,v in ipairs(unitsToDamage) do
		damageTable.damage = total_damage
		if damageTable.damage < 0 then
			damageTable.damage = damageTable.damage * (-1)
		end
		print("applying " .. total_damage .. " damage to " .. v:GetName())
		damageTable.victim = v
		ApplyDamage(damageTable)
	end

	--expend mana
	caster:SetMana(caster_mana - mana_to_expend) 
end

function choosemodifier( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local level 			= ability:GetLevel() - 1

	local temporary_modifier = keys.temporarymodifier
	local permanent_modifier = keys.permanentmodifier

	local temporary_modifier_stack_count = caster:GetModifierStackCount(temporary_modifier, ability)
	local permanent_modifier_stack_count = caster:GetModifierStackCount(permanent_modifier, ability)

	local attacker = keys.attacker
	local killed = keys.unit

	if attacker == caster then
		if killed:IsHero() then
			caster:SetModifierStackCount(permanent_modifier, ability, permanent_modifier_stack_count + 1)
		else
			if not caster:HasModifier(temporary_modifier) then
				ability:ApplyDataDrivenModifier(caster, caster, temporary_modifier, nil)
			end
			caster:SetModifierStackCount(temporary_modifier, ability, temporary_modifier_stack_count + 1)
		end
	else
		if not killed:IsIllusion() then
			if not caster:HasModifier(temporary_modifier) then
				ability:ApplyDataDrivenModifier(caster, caster, temporary_modifier, nil)
			end
			caster:SetModifierStackCount(temporary_modifier, ability, temporary_modifier_stack_count + 1)
		end
	end
end

function CreateRequiemSoulLine(caster, ability, line_end_position, death_cast)
    -- Ability properties
    local particle_lines = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
    local scepter = caster:HasScepter()

    -- Ability specials
    local travel_distance = ability:GetSpecialValueFor("damage_aoe")
    local lines_starting_width = ability:GetSpecialValueFor("lines_starting_width")
    local lines_end_width = ability:GetSpecialValueFor("lines_end_width")
    local lines_travel_speed = ability:GetSpecialValueFor("particle_speed")

    -- Calculate the time that it would take to reach the maximum distance
    local max_distance_time = travel_distance / lines_travel_speed

    -- Calculate velocity
    local velocity = (line_end_position - caster:GetAbsOrigin()):Normalized() * lines_travel_speed

    -- Launch the line
    projectile_info = {Ability = ability,
                       EffectName = particle_lines,
                       vSpawnOrigin = caster:GetAbsOrigin(),
                       fDistance = travel_distance,
                       fStartRadius = lines_starting_width,
                       fEndRadius = lines_end_width,
                       Source = caster,
                       bHasFrontalCone = false,
                       bReplaceExisting = false,
                       iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                       iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
                       iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                       bDeleteOnHit = false,
                       vVelocity = velocity,
                       bProvidesVision = false,
                       ExtraData = {scepter_line = false}
                       }

    -- Create the projectile
    ProjectileManager:CreateLinearProjectile(projectile_info)

    -- Create the particle
    local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle_lines_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
    ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
    ParticleManager:ReleaseParticleIndex(particle_lines_fx)
end