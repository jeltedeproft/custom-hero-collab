function Refresh(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local health_restored = ability:GetLevelSpecialValueFor( "health_restored", ability:GetLevel() - 1 )
	local mana_restored = ability:GetLevelSpecialValueFor( "mana_restored", ability:GetLevel() - 1 )
	local casterPos = caster:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeam()  , casterPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		local particleName = "particles/items2_fx/refresher.vpcf"
  		ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, v )
  		v:Heal(health_restored, caster)
  		v:GiveMana(mana_restored) 
  		for i=0,6 do
  			local ability = v:GetAbilityByIndex(i)
  			if ability ~= nil and ability:GetAbilityName() ~= "refresh" then
  				ability:EndCooldown()
  			end
  		end
	end
end