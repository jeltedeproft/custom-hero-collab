function BlessingOfNature(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local heal = ability:GetLevelSpecialValueFor( "heal", ability:GetLevel() - 1 )
	local damage_per_tree = ability:GetLevelSpecialValueFor( "damage_per_tree", ability:GetLevel() - 1 )
	local heal_per_tree = ability:GetLevelSpecialValueFor( "heal_per_tree", ability:GetLevel() - 1 )
	local trees_cut = 0

	local particleName = "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf"
  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  	ParticleManager:SetParticleControl( particle1, 0, point )
  	ParticleManager:SetParticleControl( particle1, 1, point )
  	ParticleManager:SetParticleControl( particle1, 2, Vector(radius,0,0) )

  	local pdummy = CreateUnitByName("particle_dummy_unit", point, false, nil, nil, caster:GetTeam())
  	local dummy_modifier = pdummy:FindAbilityByName("particle_dummy_passive")
  	dummy_modifier:SetLevel(1)
  	ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_vine_glow_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, pdummy )

  	local trees = GridNav:GetAllTreesAroundPoint(point, radius, false)
  	for k,v in pairs(trees) do
  		trees_cut = trees_cut + 1
  	end
  	GridNav:DestroyTreesAroundPoint(point, radius, false)

	local units = FindUnitsInRadius(0 , point , nil, radius+55, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		if v:GetTeam() == caster:GetTeam() then
			v:Heal(heal + heal_per_tree * trees_cut, caster)
			local particleName = "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf"
  			ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, v )
		else
			ApplyDamage({ victim = v, attacker = caster, damage = damage + damage_per_tree * trees_cut, damage_type = DAMAGE_TYPE_MAGICAL })
			local particleName = "particles/units/heroes/hero_oracle/oracle_false_promise_dmg_ember.vpcf"
  			ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, v )
		end
	end
end