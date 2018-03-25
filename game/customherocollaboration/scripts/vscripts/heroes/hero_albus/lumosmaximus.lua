function allvision( keys )
	local caster = keys.caster
	local caster_team = caster:GetTeamNumber()
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier
	local radius = 50000
	local neg_radius = -50000

	local duration = ability:GetSpecialValueFor("duration")
	local pos_one = Vector(0,0,0)
	local pos_two = Vector(neg_radius,0,0)
	local pos_three = Vector(radius,0,0)
	local pos_four = Vector(0,radius,0)
	local pos_five = Vector(0,neg_radius,0)

	AddFOWViewer(caster_team,pos_one,radius,duration,false)
	AddFOWViewer(caster_team,pos_two,radius,duration,false)
	AddFOWViewer(caster_team,pos_three,radius,duration,false)
	AddFOWViewer(caster_team,pos_four,radius,duration,false)
	AddFOWViewer(caster_team,pos_five,radius,duration,false)

	--talent
	local talent = caster:FindAbilityByName("lumos_no_mana")

	if talent:GetLevel() > 0 then
		local mana_refund = talent:GetSpecialValueFor("value")
		caster:SetMana(caster:GetMana() + mana_refund)
	end
end