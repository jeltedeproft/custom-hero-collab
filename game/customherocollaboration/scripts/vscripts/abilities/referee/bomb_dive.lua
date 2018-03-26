function BombDive(event)
	local caster = event.caster
	local ability = event.ability
	local flight_duration = ability:GetLevelSpecialValueFor( "flight_duration", ability:GetLevel() - 1 )
	local point = event.target_points[1]
	ability.point = point
	ability.fv = (ability.point - caster:GetAbsOrigin()):Normalized()
	ability.distance = (caster:GetAbsOrigin() - ability.point):Length2D()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bomb_dive", {})
end

function BombDiveStart(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bomb_dive_up", {})
	EmitSoundOn("Ability.PreLightStrikeArray", caster)
end

function BombStartMove(event)
	local caster = event.caster
	local ability = event.ability
	local height = ability:GetLevelSpecialValueFor( "height", ability:GetLevel() - 1 )
	local going_up_duration = ability:GetLevelSpecialValueFor( "going_up_duration", ability:GetLevel() - 1 )
	caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,(height/30)/going_up_duration))
end

function BombDownMove(event)
	local caster = event.caster
	local ability = event.ability
	local height = ability:GetLevelSpecialValueFor( "height", ability:GetLevel() - 1 )
	local flight_duration = ability:GetLevelSpecialValueFor( "flight_duration", ability:GetLevel() - 1 )
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*(ability.distance/30)/flight_duration - Vector(0,0,(height/30)/flight_duration))
end

function BombDiveDown(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Lina.DragonSlave", caster)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bomb_dive_down", {})
end

function BombDiveEnd(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	GridNav:DestroyTreesAroundPoint(ability.point, radius, false)
	EmitSoundOn("Ability.LightStrikeArray", caster)
	caster:RemoveModifierByName("modifier_bomb_dive")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, ability.point )
  	ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )

  	local units = FindUnitsInRadius(caster:GetTeam() , ability.point , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
		ParticleManager:CreateParticle("particles/custom_particles/general/stampede/light_entity_hit.vpcf", PATTACH_ABSORIGIN, victim)
		ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
	FindClearSpaceForUnit(caster, ability.point, false)
end