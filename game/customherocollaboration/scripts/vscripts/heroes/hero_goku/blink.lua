--[[Author: Amused/D3luxe
	Used by: Pizzalol
	Date: 11.07.2015.
	Blinks the target to the target point, if the point is beyond max blink range then blink the maximum range]]
function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	local blinkIndex = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
end

function upgradeother( keys )
	local caster = keys.caster -- Main wall dummy
	local this_ability = keys.ability
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	local other_ability_name = keys.otherability
	local other_ability = caster:FindAbilityByName(other_ability_name)
	local other_ability_level = other_ability:GetLevel()

	-- Check to not enter a level up loop
	if other_ability_level ~= this_abilityLevel then
		other_ability:SetLevel(this_abilityLevel)
	end
end