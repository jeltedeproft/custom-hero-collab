function FrozenPrison(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local tick_rate = ability:GetLevelSpecialValueFor( "tick_rate", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	local dummy_modifier = dummy:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_frozen_prison_buildup", {duration = duration + delay})
	ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_frozen_sigil.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
	ParticleManager:SetParticleControl( particle, 2, point + Vector(0,0,50))
	ParticleManager:SetParticleControl( particle, 3, point )
	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", dummy)
	Timers:CreateTimer(delay,function()
		if IsValidEntity(dummy) then
			ability:ApplyDataDrivenModifier(caster, dummy, "modifier_frozen_prison", {duration = duration})
			EmitSoundOn("Hero_Ancient_Apparition.ColdFeetFreeze", dummy)
		end
	end)
end