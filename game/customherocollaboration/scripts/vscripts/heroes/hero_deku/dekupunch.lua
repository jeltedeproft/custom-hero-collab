function punch(keys)
	local caster = keys.caster
	local caster_position = caster:GetAbsOrigin()
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local target = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local modifier = keys.modifiername
	local width = ability:GetLevelSpecialValueFor("width", ability:GetLevel() - 1 )
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1 )
	local damagetodo = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
	local flags = DOTA_UNIT_TARGET_FLAG_NONE
	local particle2_delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	local gust_particle = keys.primal_roar_particle

	--talent
	local talent = caster:FindAbilityByName("deku_punch_damage_bonus")

	if talent:GetLevel() > 0 then
		local damagetodo = damagetodo + talent:GetSpecialValueFor("value") 
	end

	--turn hero in right direction
	caster:FaceTowards(target)

	local direction = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	local powershot_mov_speed = 8
	local gust_mov_speed = 6

	local crack_ending = caster_position + direction * range
	local effect_delay = 0.1

	--calculate end spot
	local endspot = direction
	endspot.x = direction.x * range
	endspot.y = direction.y * range

	--find units in a straight line
	local units = FindUnitsInLine(caster:GetTeam(), caster:GetAbsOrigin(), crack_ending, caster, width, teams, types, flags)

	-- Add start particle effect
	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 1, crack_ending)
	ParticleManager:SetParticleControl(particle_start_fx, 3, Vector(0, effect_delay, 0))

	-- Wait for the effect delay
	Timers:CreateTimer(effect_delay, function()
		ParticleManager:ReleaseParticleIndex(particle_start_fx)
	end)

	-- wind effect
	Timers:CreateTimer(particle2_delay, function()
		-- Create arrow projectile
	    local projectileTable =
	    {
	        EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
	        Ability = ability,
	        vSpawnOrigin = caster_position,
	        vVelocity = Vector(direction.x * powershot_mov_speed, direction.y * powershot_mov_speed, 0),
	        fDistance = range,
	        fStartRadius = width,
	        fEndRadius = width,
	        Source = caster,
	        bHasFrontalCone = false,
	        bReplaceExisting = true,
	        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        iVisionRadius = width,
	        iVisionTeamNumber = caster:GetTeamNumber()
	    }
	    local powershot_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

    	--aply modifier and damge
    	for _,unit in pairs(units) do
    		--apply modifer
       		ability:ApplyDataDrivenModifier(caster, unit, modifier, nil)

       		--do damage
       		local damageTable = {
    					victim = unit,
    					attacker = caster,
    					damage = damagetodo,
    					damage_type = DAMAGE_TYPE_PHYSICAL,
    				}			
    		ApplyDamage(damageTable)
    	end

    	-- Destroy trees in the radius
    	GridNav:DestroyTreesAroundPoint(crack_ending, width, false)
	end)
end