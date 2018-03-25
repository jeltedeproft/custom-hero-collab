modifier_fissure_blocker = class({})

function modifier_fissure_blocker:CheckState()
	local states = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return states
end

function modifier_fissure_blocker:OnCreated(kv)
	if not IsServer() then return end
	local parent = self:GetParent()
	parent:SetHullRadius(60)

	-- Check for any units inside parents hull
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, 60, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		if unit:GetUnitName() ~= "unit_fissure_blocker" and not unit:IsUnselectable() then
			-- FindClearSpaceForUnit (still) does not factor in modified hull size on units. This works however.
			unit:AddNewModifier(unit, nil, "modifier_phased", { duration = 0.1 })
		end
	end 
end

function modifier_fissure_blocker:OnDestroy()
	if not IsServer() then return end

	if not self:GetParent():IsNull() then
		UTIL_Remove(self:GetParent())
	end
end
