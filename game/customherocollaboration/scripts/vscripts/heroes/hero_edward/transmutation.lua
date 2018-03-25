function revive( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local caster_team = caster:GetTeamNumber()
	local ability = keys.ability
	local respawn_added_time_pct = ability:GetSpecialValueFor("respawn_added_time_pct")

	local allHeroes = HeroList:GetAllHeroes()
	local deadalliedheroes = {}
	local numberofdeadalliedheroes = 0

	for index,hero in pairs(allHeroes) do
		if hero:GetTeamNumber() == caster_team and not hero:IsAlive() then
			numberofdeadalliedheroes = numberofdeadalliedheroes + 1
			deadalliedheroes[numberofdeadalliedheroes] = hero
		end
	end

	if numberofdeadalliedheroes == 0 then
		--do nothing
	else
		local randomdeadhero = RandomInt(1, numberofdeadalliedheroes)
		deadalliedheroes[randomdeadhero]:RespawnUnit()
	end
end

function sacrifice( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local ability = keys.ability
	local respawn_added_time_pct = ability:GetSpecialValueFor("respawn_added_time_pct")

	caster:Kill(ability, caster)
end