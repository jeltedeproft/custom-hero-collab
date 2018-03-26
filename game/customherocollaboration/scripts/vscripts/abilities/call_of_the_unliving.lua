function CallOfTheUnliving(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local raise_duration = ability:GetLevelSpecialValueFor( "raise_duration", ability:GetLevel() - 1 )
	local unit_count = ability:GetLevelSpecialValueFor( "unit_count", ability:GetLevel() - 1 )
	local night_bonus = ability:GetLevelSpecialValueFor( "night_bonus", ability:GetLevel() - 1 )
	EmitSoundOn("Hero_Undying.Tombstone", caster) 
	local pID = caster:GetPlayerID()
	local casterPos = caster:GetAbsOrigin()
	if GameRules:IsDaytime() == false then
		unit_count = unit_count + night_bonus
	end
	for i=1,unit_count do 
		local pos = casterPos + RandomVector(150)
		local zombie = CreateUnitByName("npc_zombie", pos, true, caster, caster, caster:GetTeamNumber())
		zombie:AddNewModifier(warrior, nil, "modifier_kill", {duration = duration + raise_duration})
        FindClearSpaceForUnit(zombie, pos, true)
        zombie:AddNewModifier(zombie, nil, "modifier_phased", {duration=0.03})
        ability:ApplyDataDrivenModifier(caster, zombie, "modifier_raising_from_the_dead", {duration = raise_duration})
        zombie:SetControllableByPlayer(pID, true)
        ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars_grnd.vpcf", PATTACH_ABSORIGIN_FOLLOW, zombie)
        --local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, zombie)
        --ParticleManager:SetParticleControl( particle, 0, zombie:GetAbsOrigin())
		--ParticleManager:SetParticleControl( particle, 1, zombie:GetAbsOrigin())
		--ParticleManager:SetParticleControl( particle, 2, zombie:GetAbsOrigin())
		--ParticleManager:SetParticleControl( particle, 3, zombie:GetAbsOrigin())
		--Timers:CreateTimer(raise_duration,function()
		--	ParticleManager:DestroyParticle(particle, false) 
		--end)
    end
end