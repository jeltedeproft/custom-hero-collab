function Learn_EnergyShield()
	local caster = keys.caster
    local energy_shield = caster:FindAbilityByName("shielder_energy_shield")
    if energy_shield then energy_shield:SetLevel(1) end
end

function Spawn(entityKV)
    Learn_EnergyShield()
end