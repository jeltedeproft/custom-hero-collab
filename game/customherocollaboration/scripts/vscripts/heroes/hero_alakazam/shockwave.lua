--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers upon hitting a target
	Deals damage depending on Exort and applies the knockback modifier depending on Quas]]
function shockwave( keys )
	local caster = keys.caster -- Dummy
	local caster_owner = caster:GetOwner() -- Hero
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local team = caster:GetTeamNumber()
	local duration = 5
	local modifier = keys.modifiername


	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local mana_loss = ability:GetLevelSpecialValueFor("mana_loss", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local spell_effect_delay = ability:GetLevelSpecialValueFor("spell_effect_delay", ability_level)

	Timers:CreateTimer(spell_effect_delay, function()
		-- Create particle effect phoenix
		local pfxName = "particles/custom_particles/alakazam/alakazam_shockwave.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "follow_origin", caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )

		--create particle EMP
		local emp_explosion_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf",  MAX_PATTACH_TYPES, caster)

		-- Create particle riki tricks of the trade
		local pfxName = "particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
		local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius,0,0))

		local enemies = FindUnitsInRadius(team,caster_location,nil,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,false)

		for _,enemy in pairs(enemies) do

			-- Deal damage
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			--remove mana
			--Burn an amount of mana dependent on Exort or the current mana the target has, whichever is lesser.
			local unit_mana = enemy:GetMana()
			if mana_loss < unit_mana then
				unit_mana = mana_loss
			end
			
			enemy:ReduceMana(unit_mana)

			--apply shocked modifier for effect
			ability:ApplyDataDrivenModifier(caster, enemy, modifier, nil)
		end
	end)
	
	--talent
	local talent = caster:FindAbilityByName("alakazam_shockwave_reduced_cooldown")

	if talent:GetLevel() > 0 then
		-- Trigger reduced cooldown
		Timers:CreateTimer(0.1, function()
			ability:EndCooldown()
			ability:StartCooldown(ability:GetCooldown(6) - talent:GetSpecialValueFor("value"))
		end)
	end
end