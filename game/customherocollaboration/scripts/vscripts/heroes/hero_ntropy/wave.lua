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
	local travel_distance = ability:GetLevelSpecialValueFor("range", ability_level) 
	local travel_speed = ability:GetLevelSpecialValueFor("wave_speed", ability_level) 
	local radius_start = ability:GetLevelSpecialValueFor("width", ability_level) 
	local radius_end = ability:GetLevelSpecialValueFor("width", ability_level) 
	local dummy_ability_name = keys.dummy_ability_name
	local projectile_name = keys.projectile_name

	local target = keys.target_points[1]

	local direction = (target - caster_location):Normalized()

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
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = nil,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
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
			deafening_dummy:RemoveSelf()
		end
	end)
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
	local owner_ability = caster_owner:FindAbilityByName("ntropywave")


	-- Ability variables
	local damage = owner_ability:GetLevelSpecialValueFor("damage", ability_level)

	--talent
	print("caster = " .. caster:GetName())
	local talent = caster:FindAbilityByName("wave_damage_bonus")

	if talent:GetLevel() > 0 then
		damage = damage + talent:GetSpecialValueFor("value")
	end  

	-- Initialize the damage table and deal the damage
	local damage_table = {}
	damage_table.attacker = caster_owner
	damage_table.victim = target
	damage_table.ability = owner_ability
	damage_table.damage_type = owner_ability:GetAbilityDamageType() 
	damage_table.damage = damage

	ApplyDamage(damage_table)
end