function RagedSpiritCheck(event)
	local caster = event.caster
	local ability = event.ability
	local mana_threshold = ability:GetLevelSpecialValueFor( "mana_threshold", ability:GetLevel() - 1 )
	local mana = caster:GetMana()
	if mana < mana_threshold then
		if caster:HasModifier("modifier_raged_spirit") == true then
			return
		else
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_raged_spirit", {})
		end
	else
		if caster:HasModifier("modifier_raged_spirit") == true then
			caster:RemoveModifierByName("modifier_raged_spirit") 
		end
	end
end

function RagedSpiritShower(event)
	local caster = event.caster
	local target = event.target
	local targetPos = target:GetAbsOrigin()
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local bursts = ability:GetLevelSpecialValueFor( "bursts", ability:GetLevel() - 1 )
	local time_between_bursts = ability:GetLevelSpecialValueFor( "time_between_bursts", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local particleName = "particles/units/heroes/hero_invoker/invoker_sun_strike_ray.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, target )
    ParticleManager:SetParticleControl( particle1, 0, targetPos )
    ParticleManager:SetParticleControl( particle1, 1, Vector(10,10,10) )
    ParticleManager:SetParticleControl( particle1, 2, targetPos )
    ParticleManager:SetParticleControl( particle1, 3, targetPos )
    ParticleManager:SetParticleControl( particle1, 4, targetPos )
    ParticleManager:SetParticleControl( particle1, 5, targetPos )
    EmitSoundOn("Hero_Invoker.SunStrike.Charge", target) 
	local bursts_left = bursts
	Timers:CreateTimer(delay,function()
		bursts_left = bursts_left - 1
		local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf"
    	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    	ParticleManager:SetParticleControl( particle1, 0, targetPos )
    	ParticleManager:SetParticleControl( particle1, 1, Vector(0,0,0) )
    	ParticleManager:SetParticleControl( particle1, 3, targetPos )  
		local units = FindUnitsInRadius(caster:GetTeam()  , targetPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			ApplyDamage({ victim = v, attacker = caster, damage = damage , damage_type = DAMAGE_TYPE_MAGICAL })
			EmitSoundOn("Hero_Phoenix.FireSpirits.ProjectileHit", v) 
		end
		if bursts_left > 0 then
			return time_between_bursts
		end
	end)
end