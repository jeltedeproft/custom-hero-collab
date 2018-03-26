STUN_EXLCUDE_MODIFIERS = {
	[1] = "modifier_channeling_heat_seekers",
	[2] = "modifier_equipping_tank"
}

function PulseBullet(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local dir = point - caster:GetAbsOrigin()
	dir.z = 0
	dir = dir:Normalized()
	local particle = nil
	local bullet = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
	Timers:CreateTimer(function()
		bullet:SetForwardVector(dir)
		particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, bullet)
	end)
	Timers:CreateTimer(function()
		if IsValidEntity(bullet) == false then
			return
		end
		local pos = bullet:GetAbsOrigin()
		local groundPos = GetGroundPosition(pos, bullet)
		bullet:SetAbsOrigin(groundPos + Vector(0,0,120))
		if IsValidEntity(bullet) then
			return 0.03
		end
	end)
	ability:ApplyDataDrivenModifier(caster, bullet, "dummy_pulse_bullet_passive_modifier", {duration = 1.8})
	bullet.hit = {}
end

function Tick(event)
	local source = event.caster
	local caster = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam() , caster:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local front_position = origin + fv * 30
	for k,v in pairs(units) do
		if caster.hit[v] == nil then
			caster.hit[v] = true
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
		end
		if IsValidEntity(v) then
			local stun = true
			local push = v:GetAbsOrigin() + fv * 30
			FindClearSpaceForUnit(v, push, false)
			for k,modifier in pairs(STUN_EXLCUDE_MODIFIERS) do
				if v:HasModifier(modifier) then
					stun = false
					break
				end
			end
			if stun == true then
				v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
			end
		end
	end

	if GameRules.TEAM_KNOCKBACK == true then
		local units = FindUnitsInRadius(caster:GetTeam() , caster:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			if v ~= source and IsValidEntity(v) then
				local push = v:GetAbsOrigin() + fv * 30
				FindClearSpaceForUnit(v, push, false)
				v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
			end
		end
	end

	caster:SetAbsOrigin(front_position)
end
