function JokerTreeDefense(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local position = caster:GetAbsOrigin()
	local forwardVector = (point - position):Normalized()
	local interval = ability:GetLevelSpecialValueFor( "interval", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	Timers:CreateTimer(0,function()
		position = position + forwardVector * distance
		if not IsOutOfBounds(position) then
			CreateTempTree(position, 9999) 

			local particle = ParticleManager:CreateParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", PATTACH_ABSORIGIN, caster )
			ParticleManager:SetParticleControl( particle, 0, position)
			ParticleManager:SetParticleControl( particle, 1, position)

			local units = FindUnitsInRadius(0 , position , nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for k,v in pairs(units) do
				FindClearSpaceForUnit(v, v:GetAbsOrigin(), false)
			end
			return interval
		end
	end)
end