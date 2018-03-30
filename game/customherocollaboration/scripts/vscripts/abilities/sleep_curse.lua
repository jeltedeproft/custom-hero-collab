function SleepCurse(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	local dummy_modifier = dummy:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	EmitSoundOn("Hero_Bane.Nightmare", caster)
	EmitSoundOn("Hero_Bane.Nightmare.Loop", caster)
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_sleep_curse_dummy", {duration = duration})
	ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_area_beam.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:CreateParticle("particles/custom_particles/abilities/sleep_curse/vampire_effigy_ambient_radiant.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	--local particle = ParticleManager:CreateParticle("particles/customgames/capturepoints/cp_allied_wind.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	--ParticleManager:SetParticleControl( particle, 0, point )
	--ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
	--ParticleManager:SetParticleControl( particle, 2, point + Vector(0,0,50))
	--ParticleManager:SetParticleControl( particle, 3, point )
	Timers:CreateTimer(duration,function()
		StopSoundOn("Hero_Bane.Nightmare.Loop", caster)
	end)
	dummy.slept = {}
end

function SleepTick(event)
	local caster = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam()  , caster:GetAbsOrigin()  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		if caster.slept[v] == nil then
			caster.slept[v] = true
			ability:ApplyDataDrivenModifier(caster, v, "modifier_sleep_curse", {duration = duration})
		end
	end
end