function WaterClonesStart(event)
	local caster = event.caster
	local ability = event.ability
	local casterPos = caster:GetAbsOrigin()
	EmitSoundOn("Ability.GushImpact", caster)
	ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_cloning", {})
	local fv = caster:GetForwardVector()
	local leftFv = RotatePosition(Vector(0,0,0), QAngle(0,-90,0), fv)
	local rightFv = RotatePosition(Vector(0,0,0), QAngle(0,90,0), fv)
	local helper1 = CreateUnitByName("npc_naga_helper", casterPos + leftFv * 75, false, nil, nil, caster:GetTeam())
	local helper2 = CreateUnitByName("npc_naga_helper", casterPos + rightFv * 75, false, nil, nil, caster:GetTeam())
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, helper1 )
	ParticleManager:SetParticleControl( particle, 3, helper1:GetAbsOrigin() )
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, helper2 )
	ParticleManager:SetParticleControl( particle, 3, helper2:GetAbsOrigin() )
	caster.helper1 = helper1
	caster.helper2 = helper2
	helper1:SetAbsOrigin(casterPos + leftFv * 75)
	helper2:SetAbsOrigin(casterPos + rightFv * 75)
	helper1:StartGesture(ACT_DOTA_ATTACK) 
	helper2:StartGesture(ACT_DOTA_ATTACK) 
	ability:ApplyDataDrivenModifier(caster, helper1, "modifier_ritual", {})
	ability:ApplyDataDrivenModifier(caster, helper2, "modifier_ritual", {})
end

function WaterClonesRotate(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local casterPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()
	local dir = (targetPos - casterPos):Normalized()
	local rotatedDir = RotatePosition(Vector(0,0,0), QAngle(0,4,0), dir)
	target:SetAbsOrigin(casterPos + rotatedDir * 75)
	target:SetForwardVector(-dir)
end

function WaterClonesEnd(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local clones_duration = ability:GetLevelSpecialValueFor( "clones_duration", ability:GetLevel() - 1 )
	if IsValidEntity(caster.helper1) and caster.helper1:IsAlive() and IsValidEntity(caster.helper2) and caster.helper2:IsAlive() then
		EmitSoundOn("Ability.GushImpact", caster)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, caster.helper1 )
		ParticleManager:SetParticleControl( particle, 3, caster.helper1:GetAbsOrigin() )
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, caster.helper2 )
		ParticleManager:SetParticleControl( particle, 3, caster.helper2:GetAbsOrigin() )
		caster.helper1:RemoveSelf()
		caster.helper2:RemoveSelf()
		ProjectileManager:ProjectileDodge(caster)
		ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_water_cloning_disappear", {})
	else
		ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		EmitSoundOn("Hero_Tidehunter.KrakenShell", caster)
		if IsValidEntity(caster.helper1) and caster.helper1:IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, caster.helper1 )
			ParticleManager:SetParticleControl( particle, 3, caster.helper1:GetAbsOrigin() )
			caster.helper1:RemoveSelf()
		end
		if IsValidEntity(caster.helper2) and caster.helper2:IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, caster.helper2 )
			ParticleManager:SetParticleControl( particle, 3, caster.helper2:GetAbsOrigin() )
			caster.helper2:RemoveSelf()
		end
	end
end

function WaterClonesFinish(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local clones_duration = ability:GetLevelSpecialValueFor( "clones_duration", ability:GetLevel() - 1 )
	local clone_incoming_damage = ability:GetLevelSpecialValueFor( "clone_incoming_damage", ability:GetLevel() - 1 )
	local clone_outgoing_damage = ability:GetLevelSpecialValueFor( "clone_outgoing_damage", ability:GetLevel() - 1 )
	--Cloning part
	caster:Stop()
	local clone1 = SpawnIllusion( caster, ability, clones_duration, clone_incoming_damage, clone_outgoing_damage )
	local clone2 = SpawnIllusion( caster, ability, clones_duration, clone_incoming_damage, clone_outgoing_damage )
	local fv = RandomVector(1)
	local fv2 = RotatePosition(Vector(0,0,0), QAngle(0,120,0), fv)
	local fv3 = RotatePosition(Vector(0,0,0), QAngle(0,240,0), fv)
	FindClearSpaceForUnit(caster, casterPos + fv * 100, false)
	FindClearSpaceForUnit(clone1, casterPos + fv2 * 100, false)
	FindClearSpaceForUnit(clone2, casterPos + fv3 * 100, false)
	clone1:SetForwardVector(caster:GetForwardVector())
	clone2:SetForwardVector(caster:GetForwardVector())
	ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, clone1 )
	ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, clone2 )
end