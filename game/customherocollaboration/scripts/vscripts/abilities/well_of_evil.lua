function WellOfEvilCreate(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	EmitSoundOn("Hero_ShadowDemon.ShadowPoison", dummy)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_well_of_evil", {duration = duration+5/30})
	local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/well_of_evil/joker_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
end

function WellOfEvilGoodThing(event)
	local caster = event.caster
	local well = event.target
	local ability = event.ability
	local wellPos = well:GetAbsOrigin()
	local random = RandomInt(1, 3)
	if random == 1 then
		EmitSoundOn("Hero_Necrolyte.DeathPulse", well)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_flare.vpcf", PATTACH_ABSORIGIN, well)
		ParticleManager:SetParticleControl( particle, 0, wellPos)
		ParticleManager:SetParticleControl( particle, 1, wellPos)
		ParticleManager:SetParticleControl( particle, 2, wellPos)
		local suffering_damage = ability:GetLevelSpecialValueFor( "suffering_damage", ability:GetLevel() - 1 )
		local suffering_radius = ability:GetLevelSpecialValueFor( "suffering_radius", ability:GetLevel() - 1 )
		local suffering_speed = ability:GetLevelSpecialValueFor( "suffering_speed", ability:GetLevel() - 1 )
		local units = FindUnitsInRadius(well:GetTeam() , wellPos , nil, suffering_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			local info = 
			{
				Target = v,
				Source = well,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
				iMoveSpeed = suffering_speed,
				vSourceLoc= wellPos,
				bDrawsOnMinimap = false, 
			    bDodgeable = true,
			    bIsAttack = false, 
			    bVisibleToEnemies = true,
			    bReplaceExisting = false,
			    flExpireTime = GameRules:GetGameTime() + 10,
				bProvidesVision = false,
				iVisionRadius = 400,
				iVisionTeamNumber = well:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end
	elseif random == 2 then
		EmitSoundOn("n_creep_TrollWarlord.RaiseDead", well)
		local summoning_skeletons = ability:GetLevelSpecialValueFor( "summoning_skeletons", ability:GetLevel() - 1 )
		local summoning_duration = ability:GetLevelSpecialValueFor( "summoning_duration", ability:GetLevel() - 1 )
		for i=1,summoning_skeletons do
			local skeleton = CreateUnitByName("npc_skeletal_warrior", wellPos, true, caster, caster, well:GetTeamNumber())
			skeleton:SetControllableByPlayer(caster:GetPlayerID(), true)
			FindClearSpaceForUnit(skeleton, wellPos, true)
			skeleton:AddNewModifier(warrior, nil, "modifier_kill", {duration = summoning_duration})
			ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars_grnd.vpcf", PATTACH_ABSORIGIN, skeleton)
		end
	elseif random == 3 then
		EmitSoundOn("Hero_Mirana.ArrowCast", well)
		local death_damage = ability:GetLevelSpecialValueFor( "death_damage", ability:GetLevel() - 1 )
		local death_radius = ability:GetLevelSpecialValueFor( "death_radius", ability:GetLevel() - 1 )
		local death_speed = ability:GetLevelSpecialValueFor( "death_speed", ability:GetLevel() - 1 )
		local death_distance = ability:GetLevelSpecialValueFor( "death_distance", ability:GetLevel() - 1 )
		local target = nil
		local units = FindUnitsInRadius(well:GetTeam() , wellPos , nil, 33222, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			target = v
			break
		end
		local fv = nil
		if target == nil then
			return
		else
			fv = (target:GetAbsOrigin() - wellPos):Normalized()
		end
		local projectile = {
		EffectName = "particles/custom_particles/abilities/well_of_evil/joker_spell_powershot.vpcf",
		vSpawnOrigin = wellPos + Vector(0,0,80),
		fDistance = death_distance,
		fStartRadius = death_radius,
		fEndRadius = death_radius,
		Source = well,
		fExpireTime = 8.0,
		vVelocity = fv * death_speed,
		UnitBehavior = PROJECTILES_DESTROY,
		bMultipleHits = false,
		bIgnoreSource = true,
		TreeBehavior = PROJECTILES_NOTHING,
		bCutTrees = true,
		bTreeFullCollision = false,
		WallBehavior = PROJECTILES_NOTHING,
		GroundBehavior = PROJECTILES_NOTHING,
		fGroundOffset = 80,
		nChangeMax = 1,
		bRecreateOnChange = true,
		bZCheck = false,
		bGroundLock = true,
		bProvidesVision = false,
		iVisionRadius = 350,
		iVisionTeamNumber = well:GetTeam(),
		bFlyingVision = false,
		fVisionTickTime = .1,
		fVisionLingerDuration = 1,
		draw = false,
		UnitTest = function(self, unit) return unit:GetUnitName() ~= "dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
		OnUnitHit = function(self, unit)
		EmitSoundOn("Hero_Mirana.ArrowImpact", unit)
		ApplyDamage({victim = unit, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = death_damage})
		end,
		}
		Projectiles:CreateProjectile(projectile)
	end
end