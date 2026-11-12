modifier_rapid_strike_target = class({})

function modifier_rapid_strike_target:OnDestroy()
    local caster = self:GetCaster()
    if IsServer() and caster and not caster:IsNull() then
        caster:RemoveModifierByName("modifier_rapid_strike")
    end
end

function modifier_rapid_strike_target:IsHidden()
    return true
end

function modifier_rapid_strike_target:IsPurgable()
    return false
end