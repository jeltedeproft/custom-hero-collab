function StampedeStart(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_stampede_channel", {})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_stampede_animation", {})
end

function StampedeStop(event)
	local caster = event.caster
	caster:RemoveModifierByName("modifier_stampede_channel")
	caster:RemoveModifierByName("modifier_stampede_animation")
end

function StampedeAnimation(event)
	local caster = event.caster
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_channeling", {duration = 0.9})
end

function StampedeSpawn(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", caster)
	local fv = caster:GetForwardVector()
	local spawn_radius = ability:GetLevelSpecialValueFor( "spawn_radius", ability:GetLevel() - 1 )
	local startPos = caster:GetAbsOrigin() - fv * spawn_radius
	local rotatedFv = RotatePosition(Vector(0,0,0), QAngle(0,90,0), fv)
	local offset = RandomInt(-spawn_radius, spawn_radius)
	local finalPos = startPos + rotatedFv * offset

	local beast = CreateUnitByName("dummy_unit", finalPos, true, caster, caster, caster:GetTeamNumber())
	beast:SetAbsOrigin(finalPos)
	beast:SetForwardVector(fv)
	ParticleManager:CreateParticle("particles/custom_particles/general/stampede/light_entity.vpcf", PATTACH_ABSORIGIN_FOLLOW, beast)
	ability:ApplyDataDrivenModifier(caster, beast, "modifier_stampede_beast", {})
end

function StampedeMove(event)
	local caster = event.caster
	local beast = event.target
	local ability = event.ability
	local beast_speed = ability:GetLevelSpecialValueFor( "beast_speed", ability:GetLevel() - 1 )
	local beast_collision_radius = ability:GetLevelSpecialValueFor( "beast_collision_radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	beast:SetAbsOrigin(beast:GetAbsOrigin() + beast:GetForwardVector() * (beast_speed/30))

	local units = FindUnitsInRadius(caster:GetTeam() , beast:GetAbsOrigin() , nil, beast_collision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
		EmitSoundOn("Hero_Wisp.Spirits.Target", victim)
		ParticleManager:CreateParticle("particles/custom_particles/general/stampede/light_entity_hit.vpcf", PATTACH_ABSORIGIN, victim)
		ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		beast:RemoveSelf()
		break
	end
end