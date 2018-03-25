modifier_yagami_eyes_lua = class({})

function modifier_yagami_eyes_lua:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_TOOLTIP }

    return funcs
end

function modifier_yagami_eyes_lua:OnIntervalThink()
	print("amount of gold = " .. self:GetParent():GetGold())
	if IsServer() then
		self:SetStackCount( self:GetParent():GetGold() )
	end
end

function modifier_yagami_eyes_lua:OnTooltip(params)
	print("amount of gold = " .. self:GetParent():GetGold())
    return self:GetStackCount()
end