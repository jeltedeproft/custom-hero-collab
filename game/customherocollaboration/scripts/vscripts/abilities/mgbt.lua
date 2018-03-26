HAPPY_EMOTES = {
	[1] = ":)",
	[2] = ":-)",
	[3] = ":D",
	[4] = ":]",
	[5] = ":3",
	[6] = ":>",
	[7] = "=]",
	[8] = "=)",
	[9] = "^.^",
	[10] = "=3",
	[11] = "=D",
	[12] = ":P"
}

SAD_EMOTES = {
	[1] = ":(",
	[2] = ":-(",
	[3] = "D:",
	[4] = "D:<",
	[5] = "DX",
	[6] = "v.v",
	[7] = "D=",
	[8] = "D;",
	[9] = ":<",
	[10] = ":c",
	[11] = ":[",
	[12] = ";-;"
}

MGBT_CONSTRUCTIONS = {
	[1] = "npc_guard_tower"
}
 
function MGBT(event)
	local caster = event.caster
	local casterTeam = caster:GetTeam()
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local point = event.target_points[1]
	local checker = CreateUnitByName("mgbt_dummy_unit", point, true, caster, caster, casterTeam)
	point = checker:GetAbsOrigin()
	Timers:CreateTimer(0.2,function()
		checker:RemoveSelf()
	end)
	local build_time = ability:GetLevelSpecialValueFor( "build_time", ability:GetLevel() - 1 )
	local current_build_time = 0.0
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local diff = casterPos - point
	local diffNormalized = diff:Normalized()
	local goblin1 = nil
	local goblin2 = nil
	local goblin3 = nil
	local foundGoblin1 = false
	local foundGoblin2 = false
	local foundGoblin3 = false
	local rot1 = RotatePosition(Vector(0,0,0), QAngle(0,120,0), diffNormalized)
	local rot2 = RotatePosition(Vector(0,0,0), QAngle(0,240,0), diffNormalized)
	local rot3 = RotatePosition(Vector(0,0,0), QAngle(0,360,0), diffNormalized)
	local pos1 = point + rot1 * radius
	local pos2 = point + rot2 * radius
	local pos3 = point + rot3 * radius
	local fv1 = point - pos1
	local fv1Normalized = fv1:Normalized()
	local fv2 = point - pos2
	local fv2Normalized = fv2:Normalized()
	local fv3 = point - pos3
	local fv3Normalized = fv3:Normalized()
	--local facepos1 = point + rot1 * radius - 30
	--local facepos2 = point + rot2 * radius - 30
	--local facepos3 = point + rot3 * radius - 30

	Timers:CreateTimer(0.3,function()
		goblin1 = CreateUnitByName("npc_goblin_mecha", casterPos, true, caster, caster, casterTeam)
		ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, goblin1 )
		EmitSoundOn("Hero_Wisp.TeleportIn", goblin1)
		--FindClearSpaceForUnit(goblin1, casterPos, false)
		goblin1:AddNewModifier(goblin1, nil, "modifier_phased", {duration=0.3})
		Timers:CreateTimer(0.06,function()
			goblin1:MoveToPosition(pos1)
		end)
	end)
	Timers:CreateTimer(0.6,function()
		goblin2 = CreateUnitByName("npc_goblin_mecha", casterPos, true, caster, caster, casterTeam)
		ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, goblin2 )
		EmitSoundOn("Hero_Wisp.TeleportIn", goblin2)
		--FindClearSpaceForUnit(goblin2, casterPos, false)
		goblin2:AddNewModifier(goblin2, nil, "modifier_phased", {duration=0.3})
		Timers:CreateTimer(0.06,function()
			goblin2:MoveToPosition(pos2)
		end)
	end)
	Timers:CreateTimer(0.9,function()
		goblin3 = CreateUnitByName("npc_goblin_mecha", casterPos, true, caster, caster, casterTeam)
		ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, goblin3 )
		EmitSoundOn("Hero_Wisp.TeleportIn", goblin3)
		--FindClearSpaceForUnit(goblin3, casterPos, false)
		goblin3:AddNewModifier(goblin3, nil, "modifier_phased", {duration=0.3})
		Timers:CreateTimer(0.06,function()
			goblin3:MoveToPosition(pos3)
		end)
	end)

	Timers:CreateTimer(1.0,function()
		if IsValidEntity(goblin1) == false or IsValidEntity(goblin2) == false or IsValidEntity(goblin3) == false then
			return
		end
		foundGoblin1 = false
		foundGoblin2 = false
		foundGoblin3 = false

		if goblin1:IsAlive() == false or goblin2:IsAlive() == false or goblin3:IsAlive() == false then
			if IsValidEntity(goblin1) == false or IsValidEntity(goblin2) == false or IsValidEntity(goblin3) == false then
				return
			end
			--goblin1:AddSpeechBubble(1, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
			--goblin2:AddSpeechBubble(2, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
			--goblin3:AddSpeechBubble(3, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
			Timers:CreateTimer(1.5,function()
				if goblin1:IsAlive() then
					local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl( particle, 0, goblin2:GetAbsOrigin())
					EmitSoundOnLocationWithCaster(goblin2:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
					goblin1:RemoveSelf()
				end
				if goblin2:IsAlive() then
					local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl( particle, 0, goblin2:GetAbsOrigin())
					EmitSoundOnLocationWithCaster(goblin2:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
					goblin2:RemoveSelf()
				end
				if goblin3:IsAlive() then
					local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl( particle, 0, goblin3:GetAbsOrigin())
					EmitSoundOnLocationWithCaster(goblin3:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
					goblin3:RemoveSelf()
				end
			end)
			return
		end

		local unitsGoblin1 = FindUnitsInRadius(caster:GetTeam()  , pos1  , nil, 15, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(unitsGoblin1) do
			if v == goblin1 then
				foundGoblin1 = true
			end
		end

		local unitsGoblin2 = FindUnitsInRadius(caster:GetTeam()  , pos2  , nil, 15, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(unitsGoblin2) do
			if v == goblin2 then
				foundGoblin2 = true
			end
		end

		local unitsGoblin3 = FindUnitsInRadius(caster:GetTeam()  , pos3  , nil, 15, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for k,v in pairs(unitsGoblin3) do
			if v == goblin3 then
				foundGoblin3 = true
			end
		end

		if foundGoblin1 == true and foundGoblin2 == true and foundGoblin3 == true then
			print('found all goblins')
			Timers:CreateTimer(0.1,function()
				goblin1:Stop()
				goblin1:SetForwardVector(fv1Normalized)
				StartAnimation(goblin1, {duration=1.0, activity=ACT_DOTA_ATTACK , rate=1.0})

				goblin2:Stop()
				goblin2:SetForwardVector(fv2Normalized)
				StartAnimation(goblin2, {duration=1.0, activity=ACT_DOTA_ATTACK , rate=1.0})
	
				goblin3:Stop()
				goblin3:SetForwardVector(fv3Normalized)
				StartAnimation(goblin3, {duration=1.0, activity=ACT_DOTA_ATTACK , rate=1.0})

				Timers:CreateTimer(1.0,function()
					StartAnimation(goblin1, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
					StartAnimation(goblin2, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
					StartAnimation(goblin3, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
				end)
				Timers:CreateTimer(2.0,function()
					StartAnimation(goblin1, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
					StartAnimation(goblin2, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
					StartAnimation(goblin3, {duration=2.0, activity=ACT_DOTA_ATTACK , rate=1.0})
				end)
			end)
			Timers:CreateTimer(0.1,function()
				current_build_time = current_build_time + 0.1
				if current_build_time >= build_time then
					if goblin1:IsAlive() == false or goblin2:IsAlive() == false or goblin3:IsAlive() == false then
						--goblin1:AddSpeechBubble(1, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
						--goblin2:AddSpeechBubble(2, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
						--goblin3:AddSpeechBubble(3, SAD_EMOTES[RandomInt(1, #SAD_EMOTES)], 2.0, 0, 0) 
						Timers:CreateTimer(1.5,function()
							if goblin1:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin1:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin1:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin1:RemoveSelf()
							end
							if goblin2:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin2:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin2:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin2:RemoveSelf()
							end
							if goblin3:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin3:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin3:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin3:RemoveSelf()
							end
						end)
					else
						local tower = CreateUnitByName(MGBT_CONSTRUCTIONS[RandomInt(1, #MGBT_CONSTRUCTIONS)], point, true, caster, caster, casterTeam)
						tower:SetAbsOrigin(point)
						ParticleManager:CreateParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", PATTACH_ABSORIGIN, tower )
						EmitSoundOn("Hero_Techies.StasisTrap.Plant", tower)
						--FindClearSpaceForUnit(tower, point, false)
						--goblin1:AddSpeechBubble(1, HAPPY_EMOTES[RandomInt(1, #HAPPY_EMOTES)], 2.0, 0, 0) 
						--goblin2:AddSpeechBubble(2, HAPPY_EMOTES[RandomInt(1, #HAPPY_EMOTES)], 2.0, 0, 0) 
						--goblin3:AddSpeechBubble(3, HAPPY_EMOTES[RandomInt(1, #HAPPY_EMOTES)], 2.0, 0, 0) 
						Timers:CreateTimer(1.5,function()
							if goblin1:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin1:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin1:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin1:RemoveSelf()
							end
							if goblin2:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin2:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin2:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin2:RemoveSelf()
							end
							if goblin3:IsAlive() then
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, goblin3:GetAbsOrigin())
								EmitSoundOnLocationWithCaster(goblin3:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
								goblin3:RemoveSelf()
							end
						end)
					end
				else
					return 0.1
				end
			end)
		else
			return 0.1
		end
	end)
	Timers:CreateTimer(10.0,function()
		if IsValidEntity(goblin1) == false or IsValidEntity(goblin2) == false or IsValidEntity(goblin3) == false then
			return
		end
		if goblin1:IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, goblin1:GetAbsOrigin())
			EmitSoundOnLocationWithCaster(goblin1:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
			goblin1:RemoveSelf()
		end
		if goblin2:IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, goblin2:GetAbsOrigin())
			EmitSoundOnLocationWithCaster(goblin2:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
			goblin2:RemoveSelf()
		end
		if goblin3:IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti5/teleport_end_ground_flash_ti5.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, goblin3:GetAbsOrigin())
			EmitSoundOnLocationWithCaster(goblin3:GetAbsOrigin(),"Hero_Wisp.TeleportOut", caster)
			goblin3:RemoveSelf()
		end
	end)
end