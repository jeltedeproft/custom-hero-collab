LinkLuaModifier( "modifier_rock","heroes/hero_golem/modifier_rock", LUA_MODIFIER_MOTION_NONE )

--[[Author: Pizzalol
	Date: 21.04.2015.
	Creates a dummy with a dummy deafening spell
	The dummy acts as the projectile while following the particle projectile]]
function deafening_blast_start( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local Vforward = caster:GetForwardVector()

	-- Ability and projectile variables
	local knockback_duration = ability:GetLevelSpecialValueFor("knockback_duration", ability_level)
	local travel_distance = ability:GetLevelSpecialValueFor("travel_distance", ability_level) 
	local travel_speed = ability:GetLevelSpecialValueFor("travel_speed", ability_level) 
	local radius_start = ability:GetLevelSpecialValueFor("radius_start", ability_level) 
	local radius_end = ability:GetLevelSpecialValueFor("radius_end", ability_level)
	local stone_duration = ability:GetLevelSpecialValueFor("stone_duration", ability_level) 
	local dummy_ability_name = keys.dummy_ability_name
	local projectile_name = keys.projectile_name

	local target_points = {
		caster_location + (Vforward * travel_distance),
		caster_location + (RotatePosition(Vforward, QAngle(0, 90, 0),caster_location) * travel_distance),
		caster_location + (RotatePosition(Vforward, QAngle(0, -90, 0),caster_location) * travel_distance),
		caster_location + (RotatePosition(Vforward, QAngle(0, 180, 0),caster_location) * travel_distance)	
	}

	for _,target_point in pairs(target_points) do

		local direction = (target_point - caster_location):Normalized()

		-- Create the dummy
		local deafening_dummy = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeamNumber())
		deafening_dummy:AddAbility(dummy_ability_name)

		-- Set up the dummy ability
		local dummy_ability = deafening_dummy:FindAbilityByName(dummy_ability_name)
		dummy_ability:SetLevel(1)

		-- Initialize the dummy calculation variables
		local distance_traveled = 0
		local dummy_speed = travel_speed * 1/30


		-- Create projectile
		local projectile_table =
		{
			EffectName = projectile_name,
			Ability = dummy_ability,
			vSpawnOrigin = caster_location,
			vVelocity = direction * travel_speed,
			fDistance = travel_distance,
			fStartRadius = radius_start,
			fEndRadius = radius_end,
			Source = deafening_dummy,
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = ability:GetAbilityTargetTeam(),
			iUnitTargetFlags = ability:GetAbilityTargetFlags(),
			iUnitTargetType = ability:GetAbilityTargetType()
		}
		ProjectileManager:CreateLinearProjectile( projectile_table )

		-- Move the dummy
		Timers:CreateTimer(function()
			-- If the dummy traveled the whole distance then kill it
			if distance_traveled < travel_distance then
				-- Otherwise keep track of the distance traveled and set the new position
				local dummy_location = deafening_dummy:GetAbsOrigin() + direction * dummy_speed
				deafening_dummy:SetAbsOrigin(dummy_location)
				distance_traveled = distance_traveled + dummy_speed

				return 1/30
			else
				-- Remove the dummy after the knockback duration to allow all the modifiers to be applied
				Timers:CreateTimer(knockback_duration,function()
					deafening_dummy:RemoveSelf()
				end)
			end
		end)
	end
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers upon hitting a target
	Deals damage depending on Exort and applies the knockback modifier depending on Quas]]
function deafening_blast_hit( keys )
	local caster = keys.caster -- Dummy
	local caster_owner = caster:GetOwner() -- Hero
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local owner_ability = caster_owner:FindAbilityByName("golemsolitude")


	-- Ability variables
	local damage = owner_ability:GetLevelSpecialValueFor("damage", ability_level) 
	local knockback_duration = owner_ability:GetLevelSpecialValueFor("knockback_duration",ability_level) 
	local knockback_modifier = keys.knockback_modifier

	-- Apply the knockback modifier
	ability:ApplyDataDrivenModifier(caster, target, knockback_modifier, {duration = knockback_duration}) 

	-- Initialize the damage table and deal the damage
	local damage_table = {}
	damage_table.attacker = caster_owner
	damage_table.victim = target
	damage_table.ability = owner_ability
	damage_table.damage_type = owner_ability:GetAbilityDamageType() 
	damage_table.damage = damage

	ApplyDamage(damage_table)
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Keeps track of the caster and the direction in which to be knocked back]]
function deafening_blast_knockback_start( keys )
	local caster = keys.caster -- Dummy
	local caster_owner = caster:GetOwner() -- Hero
	local caster_location = caster:GetAbsOrigin() 
	local target = keys.target
	local target_location = target:GetAbsOrigin()

	target.deafening_direction = (target_location - caster_location):Normalized()
	target.deafening_caster = caster_owner
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers on an interval in the knockback modifier, moves the target]]
function deafening_blast_knockback( keys )
	local target = keys.target
	local target_location = target:GetAbsOrigin() 
	local knockback_speed = 6

	local new_location = target_location + target.deafening_direction * knockback_speed
	target:SetAbsOrigin(GetGroundPosition(new_location, target))
end

function turn_to_rock( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local stone_duration = ability:GetLevelSpecialValueFor("stone_duration", ability_level) 

	--turn caster to stone
	caster:AddNewModifier(caster, ability, "modifier_rock", {duration = stone_duration})
end


--[[Author: Pizzalol
	Date: 26.09.2015.
	Checks if the target is a unit owned by the player that cast the Chronosphere
	If it is then it applies the no collision and extra movementspeed modifier
	otherwise it applies the stun modifier]]
function ChronosphereAura( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local knockback_speed = 15
	local push_direction = (target_location - caster_location):Normalized()

	-- Ability variables
	local aura_modifier = keys.aura_modifier
	local duration = ability:GetLevelSpecialValueFor("aura_interval", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local ignore_golem = true

	--talent
	local talent = caster:FindAbilityByName("golem_solitude_bonus_range")

	if talent:GetLevel() > 0 then
		radius = radius + talent:GetSpecialValueFor("value")
	end

	-- Check if it is a caster controlled unit or not
	-- Caster controlled units get the phasing and movement speed modifier
	if target ~= caster then
		--immobilized and stunned
		target:InterruptMotionControllers(false)
		ability:ApplyDataDrivenModifier(caster, target, aura_modifier, {duration = duration})

		--if target is not caster and is still inside, push him out
		local spread = target_location - caster_location
		local distance = spread:Length2D()
		if distance < radius then
			local new_location = target_location + push_direction * knockback_speed
			target:SetAbsOrigin(GetGroundPosition(new_location, target))
		end
	end
end

--[[Author: Pizzalol
	Date: 26.09.2015.
	Creates a dummy at the target location that acts as the Chronosphere]]
function create_bubble( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local target_point = caster:GetAbsOrigin()
	local ability_level = ability:GetLevel() - 1
	local dummy_modifier = keys.dummy_aura

	-- Special Variables
	local stone_duration = ability:GetLevelSpecialValueFor("stone_duration", ability_level) 

	--talent
	local talent = caster:FindAbilityByName("golem_solitude_bonus_range")

	if talent:GetLevel() > 0 then
		dummy_modifier = keys.talent_aura
	end

	-- Dummy
	local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {duration = stone_duration})	

	-- Timer to remove the dummy
	Timers:CreateTimer(stone_duration, function() dummy:RemoveSelf() end)
end

function make_bubble_effect( keys )
	local particle = keys.particlename
	local particle_bigger = keys.particlename_bigger
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local dummy = keys.target
	local center = dummy:GetAbsOrigin()

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	--talent
	local talent = caster:FindAbilityByName("golem_solitude_bonus_range")

	if talent:GetLevel() > 0 then
		particle = particle_bigger
		radius = radius + talent:GetSpecialValueFor("value")
	end

	-- Create particle
	local chrono_pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
	ParticleManager:SetParticleControl(chrono_pfx, 0, center)
	ParticleManager:SetParticleControl(chrono_pfx, 1, Vector(radius, radius, 0))
end

