require('timers')

function bvo_brook_skill_5(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	caster.brook_skill_5_origin = caster:GetAbsOrigin()
	caster.brook_skill_5_point = target:GetAbsOrigin()
	caster.brook_skill_5_forward = caster:GetForwardVector()

	-- The reappear step sets this; if it runs before the hide below, skip the hide
	-- so the hero can never be left invisible.
	caster.brook_skill_5_hidden_done = false
	local max_runs = (delay / 2) / 0.03
	local runs = 0
	Timers:CreateTimer(0.03, function ()
		if runs < max_runs and not caster.brook_skill_5_hidden_done then
			runs = runs + 1
			caster:SetAbsOrigin( caster:GetAbsOrigin() - caster:GetForwardVector() * 4 )
			return 0.03
		end
		if not caster.brook_skill_5_hidden_done then
			caster:AddNoDraw()
		end
		return nil
	end)
end

function bvo_brook_skill_5_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster.brook_skill_5_point
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	local offset = 0
	local endPoint = point + ( caster.brook_skill_5_forward * 128 ) - caster.brook_skill_5_forward * offset
	while not GridNav:CanFindPath(caster.brook_skill_5_origin, endPoint) do
		offset = offset + 8
		endPoint = point + ( caster.brook_skill_4_forward * 128 ) - caster.brook_skill_5_forward * offset
	end
	FindClearSpaceForUnit(caster, endPoint, false)
	caster.brook_skill_5_hidden_done = true
	caster:RemoveNoDraw()
	caster:EmitSound("Hero_Beastmaster.Attack")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2, 3.0)

	local max_runs = (delay / 2) / 0.03
	local runs = 0
	Timers:CreateTimer(0.03, function ()
		if runs < max_runs then
			runs = runs + 1
			caster:SetAbsOrigin( caster:GetAbsOrigin() + caster:GetForwardVector() * 4 )
			return 0.03
		end
		return nil
	end)
end

function bvo_brook_skill_5_damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local multi = ability:GetLevelSpecialValueFor("hero_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = caster:GetLevel() * multi + damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
end