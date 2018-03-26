function PitfallStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local finalPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 50
	local pit = CreateUnitByName("dummy_unit", finalPos, false, nil, nil, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, pit, "modifier_pitfall", {duration = duration})

	EmitSoundOn("Ability.LightStrikeArray", caster)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_ABSORIGIN, pit)
	ParticleManager:SetParticleControl( particle, 0, finalPos + Vector(0,0,40))
	ParticleManager:SetParticleControl( particle, 1, finalPos + Vector(0,0,40))
	ParticleManager:SetParticleControl( particle, 3, finalPos + Vector(0,0,40))
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn_shockwave.vpcf", PATTACH_ABSORIGIN, pit)
	ParticleManager:SetParticleControl( particle, 0, finalPos)
	ParticleManager:SetParticleControl( particle, 1, Vector(1,1,1))
	ParticleManager:SetParticleControl( particle, 3, Vector(radius,0,0))


	local units = FindUnitsInRadius(caster:GetTeam() , finalPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
end

function PitfallPull(event)
	local pit = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local speed = ability:GetLevelSpecialValueFor( "pull_speed", ability:GetLevel() - 1 )/30

	local pitPos = pit:GetAbsOrigin()

	local units = FindUnitsInRadius(pit:GetTeam() , pitPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		local offset = speed
		local targetPos = v:GetAbsOrigin()
		local diff = pitPos - targetPos
		local dir = diff:Normalized()
		local diffLength = diff:Length2D()
		if diffLength < speed then
			offset = diffLength
		end
		v:SetAbsOrigin(targetPos + dir * offset)
		v:AddNewModifier(v, nil, "modifier_phased", {duration = 1/30})
	end
end