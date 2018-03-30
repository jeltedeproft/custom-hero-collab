function HuntingNets(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local offset = ability:GetLevelSpecialValueFor( "offset", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )

	EmitSoundOn("Hero_Meepo.Earthbind.Cast", caster)

	local casterPos = caster:GetAbsOrigin()
	local casterTeam = caster:GetTeam()
	local casterFv = caster:GetForwardVector()

	local net1Fv = RotatePosition(Vector(0,0,0), QAngle(0,-offset,0), casterFv)
	local net2Fv = casterFv
	local net3Fv = RotatePosition(Vector(0,0,0), QAngle(0,offset,0), casterFv)

	local net1 = CreateUnitByName("dummy_unit", casterPos, false, nil, nil, casterTeam)
	local dummy_modifier = net1:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	net1.particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/hunting_nets/hunting_nets.vpcf", PATTACH_ABSORIGIN_FOLLOW, net1)
	ability:ApplyDataDrivenModifier(caster, net1, "modifier_hunting_net", {duration = distance/speed})
	
	local net2 = CreateUnitByName("dummy_unit", casterPos, false, nil, nil, casterTeam)
	local dummy_modifier = net2:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	net2.particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/hunting_nets/hunting_nets.vpcf", PATTACH_ABSORIGIN_FOLLOW, net2)
	ability:ApplyDataDrivenModifier(caster, net2, "modifier_hunting_net", {duration = distance/speed})

	local net3 = CreateUnitByName("dummy_unit", casterPos, false, nil, nil, casterTeam)
	local dummy_modifier = net3:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	net3.particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/hunting_nets/hunting_nets.vpcf", PATTACH_ABSORIGIN_FOLLOW, net3)
	ability:ApplyDataDrivenModifier(caster, net3, "modifier_hunting_net", {duration = distance/speed})

	Timers:CreateTimer(0,function()
		net1:SetAbsOrigin(casterPos)
		net1:SetForwardVector(net1Fv)
		net2:SetAbsOrigin(casterPos)
		net2:SetForwardVector(net2Fv)
		net3:SetAbsOrigin(casterPos)
		net3:SetForwardVector(net3Fv)
	end)
end

function HuntingNetsMove(event)
	local caster = event.caster
	local net = event.target
	local ability = event.ability
	local netPos = net:GetAbsOrigin()
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	--local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(net:GetTeam() , netPos , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k,v in pairs(units) do
		EmitSoundOn("Hero_Meepo.Earthbind.Target", v)
		--ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
		ability:ApplyDataDrivenModifier(caster, v, "modifier_hunting_netted", {duration = duration})
		net:RemoveSelf()
		return
	end
	net:SetAbsOrigin(netPos + net:GetForwardVector() * speed)
end