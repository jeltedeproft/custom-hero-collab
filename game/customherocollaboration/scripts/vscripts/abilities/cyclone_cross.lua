function CycloneCross(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local blades = ability:GetLevelSpecialValueFor( "blades", ability:GetLevel() - 1 )
	local blade_distance = ability:GetLevelSpecialValueFor( "blade_distance", ability:GetLevel() - 1 )
	local blade_speed = ability:GetLevelSpecialValueFor( "blade_speed", ability:GetLevel() - 1 )
	local blade_radius = ability:GetLevelSpecialValueFor( "blade_radius", ability:GetLevel() - 1 )
	local cyclone_duration = ability:GetLevelSpecialValueFor( "cyclone_duration", ability:GetLevel() - 1 )
	local cyclone_damage = ability:GetLevelSpecialValueFor( "cyclone_damage", ability:GetLevel() - 1 )
	local cyclone_radius = ability:GetLevelSpecialValueFor( "cyclone_radius", ability:GetLevel() - 1 )


	EmitSoundOnLocationWithCaster(point, "Brewmaster_Storm.WindWalk", caster) 

	local casterPos = caster:GetAbsOrigin()
	local casterTeam = caster:GetTeam() 

	local rotation = 360/blades
	local diff = casterPos - point
	local diffNormalized = diff:Normalized()

	for i=1,blades do
		local rotated = rotation * i
		local direction = RotatePosition(Vector(0,0,0), QAngle(0,rotated,0), diffNormalized)
		local pos = direction * blade_distance
		local destination = point + pos

		local blade = CreateUnitByName("dummy_unit", destination , true, nil, nil, casterTeam)
		blade:SetAbsOrigin(destination)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence_wave_ground_dust.vpcf", PATTACH_ABSORIGIN, blade)
		ParticleManager:SetParticleControl( particle, 0, destination)
		ParticleManager:SetParticleControl( particle, 1, destination)
		ParticleManager:SetParticleControl( particle, 2, destination)
		ParticleManager:SetParticleControl( particle, 3, destination)
		ParticleManager:SetParticleControl( particle, 4, destination)
		ParticleManager:SetParticleControl( particle, 5, destination)
		ParticleManager:SetParticleControl( particle, 6, destination)
		ParticleManager:SetParticleControl( particle, 7, destination)
		ParticleManager:SetParticleControl( particle, 8, destination)
		ParticleManager:SetParticleControl( particle, 9, destination)
		ability:ApplyDataDrivenModifier(caster, blade, "modifier_blade_delay", {})


		local face = point - destination
		local faceNormalized = face:Normalized()
		Timers:CreateTimer(0,function()
			blade:SetForwardVector(faceNormalized)
		end)
	end

	local blade_delay = blade_distance / blade_speed
	Timers:CreateTimer(delay + blade_delay,function()
		local cyclone = CreateUnitByName("dummy_unit", point , true, nil, nil, casterTeam)
		cyclone:SetAbsOrigin(point)
		ability:ApplyDataDrivenModifier(caster, cyclone, "modifier_cyclone", {duration = cyclone_duration})
		ParticleManager:CreateParticle("particles/items_fx/cyclone.vpcf", PATTACH_ABSORIGIN_FOLLOW, cyclone)
		EmitSoundOn("DOTA_Item.Cyclone.Activate", cyclone)
	end)
end

function BladeDelayPassed(event)
	local caster = event.target
	local ability = event.ability
	local blade_distance = ability:GetLevelSpecialValueFor( "blade_distance", ability:GetLevel() - 1 )
	local blade_speed = ability:GetLevelSpecialValueFor( "blade_speed", ability:GetLevel() - 1 )
	local casterPos = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	caster:RemoveModifierByName("modifier_blade_delay")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_blade_thinker", {})
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence_wave_ground_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, fv)
	ParticleManager:SetParticleControl( particle, 3, casterPos + fv * -125)
	ParticleManager:SetParticleControl( particle, 4, fv)
	ParticleManager:SetParticleControl( particle, 5, fv)
	ParticleManager:SetParticleControl( particle, 9, fv)
	ParticleManager:SetParticleControlForward(particle, 0, fv) 
	ParticleManager:SetParticleControlForward(particle, 3, fv) 
	ParticleManager:SetParticleControlForward(particle, 4, fv) 
	ParticleManager:SetParticleControlForward(particle, 5, fv) 
	ParticleManager:SetParticleControlForward(particle, 9, fv) 

	EmitSoundOn("Hero_DrowRanger.Silence", caster)

	Timers:CreateTimer(0,function()
		if IsValidEntity(caster) then
			ParticleManager:SetParticleControl( particle, 3, caster:GetAbsOrigin() + fv * -125)
			return 1/30
		end
	end)

end

function BladeTick(event)
	local caster = event.target
	local ability = event.ability
	local blade_speed = ability:GetLevelSpecialValueFor( "blade_speed", ability:GetLevel() - 1 )
	local blade_radius = ability:GetLevelSpecialValueFor( "blade_radius", ability:GetLevel() - 1 )
	blade_speed = blade_speed/30
	local origin = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local change = fv * blade_speed
	local front_position = origin + change
	GridNav:DestroyTreesAroundPoint(origin, blade_radius, false)
	local units = FindUnitsInRadius(caster:GetTeam() , origin , nil, blade_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		local push = v:GetAbsOrigin() + change
		FindClearSpaceForUnit(v, push, false)
		v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
	end
	caster:SetAbsOrigin(front_position)
end


function CycloneTick(event)
	local target = event.target
	local ability = event.ability
	local cyclone_radius = ability:GetLevelSpecialValueFor( "cyclone_radius", ability:GetLevel() - 1 )
	local casterPos = target:GetAbsOrigin()
	local units = FindUnitsInRadius(target:GetTeam() , target:GetAbsOrigin() , nil, cyclone_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		ability:ApplyDataDrivenModifier(target, v, "modifier_cycloned", {duration = 2/30})
		v:StartGesture(ACT_DOTA_FLAIL) 
		local targetPos = v:GetAbsOrigin()
		local diff = targetPos - casterPos
		local offset = 40
		local diffNormalized = diff:Normalized()
		local directionRotate = RotatePosition(Vector(0,0,0), QAngle(0,15,0), diffNormalized)
		v:SetAbsOrigin(casterPos + directionRotate * offset)
	end
end

function CycloneDamage(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local targetPos = target:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_windwalk.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, targetPos)
	EmitSoundOnLocationWithCaster(targetPos,"Brewmaster_Storm.DispelMagic", caster)
	local cyclone_damage = ability:GetLevelSpecialValueFor( "cyclone_damage", ability:GetLevel() - 1 )
	local cyclone_radius = ability:GetLevelSpecialValueFor( "cyclone_radius", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam() , targetPos , nil, cyclone_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		v:RemoveModifierByName("modifier_cycloned")
		v:RemoveGesture(ACT_DOTA_FLAIL) 
		ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = cyclone_damage})
	end
end