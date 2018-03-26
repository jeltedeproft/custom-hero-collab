function SpawnGolem(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local random = RandomInt(1, 3)
	local unitname = nil
	if random == 3 then
		unitname = "npc_mud_golem"
	elseif random == 2 then
		unitname = "npc_rock_golem"
	elseif random == 1 then
		unitname = "npc_granite_golem"
	end
	local duration = RandomInt(15, 20)
	local golem = CreateUnitByName(unitname, casterPos, true, caster, caster, caster:GetTeamNumber())
	FindClearSpaceForUnit(golem, casterPos, true)
	golem:AddNewModifier(golem, nil, "modifier_kill", {duration = duration})
	caster:RemoveSelf()
end

function SpawnRock(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	while IsNearPit(casterPos) == true do
		casterPos = casterPos + Vector(16,0,0)
	end
	local rock = CreateUnitByName("npc_rock", casterPos, true, caster, caster, caster:GetTeamNumber())
	FindClearSpaceForUnit(rock, casterPos, true)
	rock:SetForwardVector(RandomVector(1))
end