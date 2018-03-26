function CreateTeleport(event)
	local caster = event.caster
	local ability = event.ability
	local portal = CreateUnitByName("dummy_unit", caster:GetAbsOrigin() + caster:GetForwardVector() * 300, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, portal, "modifier_portal", {})
	local particle = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, portal)
	ParticleManager:SetParticleControl(particle, 0, portal:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, portal:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, portal:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 4, portal:GetAbsOrigin())
	EmitSoundOn("Portal.Hero_Appear", portal)
end

function TeleportToSafebox(event)
	local target = event.target
	local ability = event.ability
	if GameRules.PLAYER_IS_PREDATOR[target:GetPlayerOwnerID()] == false and target:GetUnitName() == "npc_dota_hero_invoker" and target:IsRealHero() then
		GameRules:SendCustomMessage(GameRules.COLOURED_NAMES[target:GetPlayerOwnerID()].."<font color='#FFD700'> is now chilling in the safebox</font>", 0, 0) 
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Chen.TeleportOut", target) 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		FindClearSpaceForUnit(target, Entities:FindByName(nil, "target_safe_zone"):GetAbsOrigin()+RandomVector(50), false)
		ability:ApplyDataDrivenModifier(target, target, "modifier_chilling_out", {})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Chen.TeleportIn", target) 
		--Add an item in the safebox
		local itempos = Entities:FindByName(nil, "target_safe_zone"):GetAbsOrigin()+RandomVector(150)
		CreateItemOnPositionSync(itempos, CreateItem(GameRules.RANDOM_ITEMS[RandomInt(1, #GameRules.RANDOM_ITEMS)], nil, nil))
		local particle = ParticleManager:CreateParticle("particles/generic_hero_status/hero_levelup.vpcf", PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(particle, 0, itempos)
		--Play sound if it's possible
		local player = PlayerResource:GetPlayer(target:GetPlayerOwnerID())
		if player ~= nil then
			print('eeeemiiit')
			EmitSoundOnClient("ThePredator.SafeboxLoop", player) 
		end
	end
end

function ReturnFromSafebox(event)
	local target = event.target
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Chen.TeleportOut", target) 
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	FindClearSpaceForUnit(target, RandomPosOnMap(), false)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Chen.TeleportIn", target) 
	--Sounds
	local player = PlayerResource:GetPlayer(target:GetPlayerOwnerID())
	if player ~= nil then
		StopSoundOn("ThePredator.SafeboxLoop", player) 
		EmitSoundOnClient("ThePredator.SafeboxLeave", player) 
	end
end