function DashStart(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local point = event.target_points[1]
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local diff = (point-casterPos):Length2D()
	local dir = (point-casterPos):Normalized()
	caster:SetForwardVector(dir)
	ability.particle = ParticleManager:CreateParticle("particles/econ/items/bristleback/bristle_spikey_spray/bristle_spikey_quill_spray_warp.vpcf", PATTACH_ABSORIGIN, caster)
	--ParticleManager:SetParticleControl( ability.particle, 0, casterPos+Vector(0,0,60))
	--ParticleManager:SetParticleControl( ability.particle, 1, casterPos+Vector(0,0,60))
	--ParticleManager:SetParticleControl( ability.particle, 2, casterPos+Vector(0,0,60))
	--ParticleManager:SetParticleControl( ability.particle, 3, casterPos+Vector(0,0,60))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dash_move", {duration =diff/speed})
end

function DashMove(event)
	local caster = event.target
	local casterPos = caster:GetAbsOrigin()
	local casterFv = caster:GetForwardVector()
	local ability = event.ability
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )

	GridNav:DestroyTreesAroundPoint(casterPos, radius, false) 
	DestroyRocksAroundPoint(casterPos, radius)

	caster:SetAbsOrigin(casterPos + casterFv * speed)
	caster:AddNewModifier(v, nil, "modifier_phased", {duration = 2/30})
end

function DashParticle(event)
	local caster = event.caster
	local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/dash/assassin_dash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlForward(particle, 0, caster:GetForwardVector()) 
	ParticleManager:SetParticleControlForward(particle, 1, caster:GetForwardVector()) 
	ParticleManager:SetParticleControlForward(particle, 2, caster:GetForwardVector()) 
end

function DashCritParticle(event)
	local caster = event.attacker 
	local unit = event.target
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin()+Vector(0,0,50))
	ParticleManager:SetParticleControl( particle, 1, unit:GetAbsOrigin()+Vector(0,0,50))
	ParticleManager:SetParticleControlForward(particle, 0, -caster:GetForwardVector()) 
	ParticleManager:SetParticleControlForward(particle, 1, -caster:GetForwardVector()) 
end