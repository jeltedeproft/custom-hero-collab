function bvo_kissshot_skill_1(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
    local multi = ability:GetLevelSpecialValueFor("agi_multi", ability:GetLevel() - 1 )

    local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( caster:GetAgility() * multi ) + damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
end