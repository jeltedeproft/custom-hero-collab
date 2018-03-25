function bvo_akainu_skill_3_hit(keys)
	local caster = keys.caster
	local target = keys.target
    local ability = keys.ability

    local str_multi = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )

  	local damageTable = {
		victim = target,
		attacker = caster,
		damage = (caster:GetStrength() * str_multi),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
end