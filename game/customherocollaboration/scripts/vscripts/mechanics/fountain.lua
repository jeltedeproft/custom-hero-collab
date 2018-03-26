function FountainThink(event)
	local caster = event.target
	if caster:HasModifier("modifier_hell_spawn") then
		if GameRules.FOUNTAIN_BLOODSTAINED == true then
			local maxHealth = caster:GetMaxHealth()
			ApplyDamage({victim = caster, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = maxHealth*0.075})
		else
			local maxHealth = caster:GetMaxHealth()
			ApplyDamage({victim = caster, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = maxHealth*0.125})
		end
	else
		local maxMana = caster:GetMaxMana()
		caster:GiveMana(maxMana*0.10)
	end
end