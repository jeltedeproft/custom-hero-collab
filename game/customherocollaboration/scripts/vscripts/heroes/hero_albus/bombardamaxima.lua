--[[Author: YOLOSPAGHETTI
	Date: March 28, 2016
	Gives the caster's team vision in the radius]]
function GiveVision(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() -1))
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", (ability:GetLevel() -1))
	
	AddFOWViewer(caster:GetTeam(), point, vision_radius, vision_duration, false)
end


function applymodifier(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", (ability:GetLevel() -1))
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", (ability:GetLevel() -1))
	local target = keys.target_points[1]
	local modifier = keys.modifiername
	
	local dummy = CreateUnitByName("npc_dummy_unit", target, true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, dummy, modifier, nil)
end