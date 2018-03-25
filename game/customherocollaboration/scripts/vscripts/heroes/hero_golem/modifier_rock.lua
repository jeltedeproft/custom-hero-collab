modifier_rock = class({})

function modifier_rock:DeclareFunctions()
	local funcs = {
	    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_rock:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_4
end

function modifier_rock:GetModifierMoveSpeed_Absolute( params )
	return 0
end

function modifier_rock:GetEffectName()
	return "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant_gravity_grndglow.vpcf"
end

function modifier_rock:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_rock:GetTexture()
	return "earth_spirit_petrify"
end

function modifier_rock:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
	return states
end