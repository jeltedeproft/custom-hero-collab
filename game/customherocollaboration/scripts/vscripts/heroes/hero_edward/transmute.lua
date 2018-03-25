transmute = class({})

LinkLuaModifier("modifier_fissure_blocker", "heroes/hero_edward/modifier_fissure_blocker", LUA_MODIFIER_MOTION_NONE)	
function transmutewall( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local ability = keys.ability
	local targetpoint = keys.target_points[1]
	local vDir = (targetpoint - caster_pos):Normalized()
	local fissure_range = ability:GetSpecialValueFor("fissure_range")
	local fDuration = ability:GetSpecialValueFor("fissure_duration")
	local fRadius = ability:GetSpecialValueFor("fissure_radius")
	local fStunDuration = ability:GetSpecialValueFor("fissure_stun_duration")
	local nDamage = ability:GetSpecialValueFor("fissure_damage")
	local fBlockerStep = 60
	local vStartPoint = caster_pos + vDir * fBlockerStep

	--talent
	local talent = caster:FindAbilityByName("edward_transmute_range_bonus")

	if talent:GetLevel() > 0 then
		fissure_range = fissure_range + talent:GetSpecialValueFor("value")
	end

	local vEndPoint = caster_pos + vDir * fissure_range

	-- Fire particle effect
	local p = ParticleManager:CreateParticle("particles/custom_particles/edward/edwarttransmute3.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(p, 0, vStartPoint)
	ParticleManager:SetParticleControl(p, 1, vEndPoint)
	ParticleManager:SetParticleControl(p, 2, Vector(8,0,0))

	-- Create blockers in radius.
	local range = fissure_range - fBlockerStep
	local vPos = vStartPoint
	while range > 0 do
		local step = math.min(fBlockerStep, range)
		vPos = vPos + vDir * step
		local blocker = CreateUnitByName("unit_fissure_blocker", vPos, false, caster, nil, DOTA_TEAM_NEUTRALS)
		blocker:AddNewModifier(caster, nil, "modifier_fissure_blocker",{duration = 8})
		range = range - step
	end
	FindClearSpaceForUnit(caster,caster:GetOrigin(),true)

	local targets = FindUnitsInLine(caster:GetTeam(), caster_pos, vEndPoint, nil, fRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
	
	for _,target in pairs(targets) do
		local damage = {
			victim = target,
			attacker = caster,
			ability = ability,
			damage = nDamage,
			damage_type = ability:GetAbilityDamageType(),
		}
		ApplyDamage(damage)

		target:AddNewModifier(caster,nil,"modifier_stunned",{duration = fStunDuration})
	end
end