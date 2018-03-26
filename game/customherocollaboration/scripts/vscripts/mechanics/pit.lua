function PitCheck(event)
	local caster = event.target
	if caster:HasModifier("modifier_hell_spawn") == false then
		if caster:IsRealHero() then
			local pID = caster:GetPlayerID()
			GameRules:SendCustomMessage(GameRules.COLOURED_NAMES[pID].." got scorched in the pit", 0, 0) 
		end
		local casterPos = caster:GetAbsOrigin()
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle, 0, casterPos + Vector(0,0,80))
		ParticleManager:SetParticleControl( particle, 1, Vector(150,150,150))
		EmitSoundOn("Hero_OgreMagi.Fireblast.Target", caster)
		caster:ForceKill(false)
	end
end

function PitThink(event)
	local caster = event.target
	if caster:HasModifier("modifier_hell_spawn") then
		local maxMana = caster:GetMaxMana()
		caster:GiveMana(maxMana*0.10)
	else
		if caster:IsRealHero() then
			local pID = caster:GetPlayerID()
			GameRules:SendCustomMessage(GameRules.COLOURED_NAMES[pID].." got scorched in the pit", 0, 0) 
		end
		local casterPos = caster:GetAbsOrigin()
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle, 0, casterPos + Vector(0,0,80))
		ParticleManager:SetParticleControl( particle, 1, Vector(150,150,150))
		EmitSoundOn("Hero_OgreMagi.Fireblast.Target", caster)
		caster:ForceKill(false)
	end
end

function PitDestroyTrees(event)
	local caster = event.caster
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 256, false)
end