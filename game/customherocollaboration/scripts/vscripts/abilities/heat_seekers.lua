function HeatSeekersSendRockets(event)
	local caster = event.caster
	local ability = event.ability
	local range = ability:GetLevelSpecialValueFor( "range", ability:GetLevel() - 1 )
	local tank_range = ability:GetLevelSpecialValueFor( "tank_range", ability:GetLevel() - 1 )
	local speed = ability:GetLevelSpecialValueFor( "rocket_speed", ability:GetLevel() - 1 )
	local effect = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"

	if caster:HasModifier("modifier_tank_mode") then
		effect = "particles/units/heroes/hero_tinker/tinker_base_attack.vpcf"
		range = tank_range
	end

	local casterPos = caster:GetAbsOrigin()
	local sound = false
	local units = FindUnitsInRadius(caster:GetTeam()  , casterPos  , nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if units then
		for k,v in pairs(units) do
			if sound == false then
				sound = true
				EmitSoundOn("Hero_Gyrocopter.Rocket_Barrage.Launch", caster)
			end
			local info = 
			{
				Target = v,
				Source = caster,
				Ability = ability,	
				EffectName = effect,
				vSourceLoc= casterPos,
				iMoveSpeed = speed,
				iSourceAttachment = PATTACH_POINT,
				bDrawsOnMinimap = false, 
			    bDodgeable = true,
			    bIsAttack = false, 
			    bVisibleToEnemies = true,
			    bReplaceExisting = false,
			    flExpireTime = GameRules:GetGameTime() + 20,
				bProvidesVision = true,
				iVisionRadius = 100,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function HeatSeekersDealDamage(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local tank_damage = ability:GetLevelSpecialValueFor( "tank_damage", ability:GetLevel() - 1 )
	if caster:HasModifier("modifier_tank_mode") then 
		damage = tank_damage
	end
	ApplyDamage({victim = target, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
end