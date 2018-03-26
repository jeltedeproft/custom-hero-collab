function OfferDrinkEffect(event)
	local caster = event.caster
	local target = event.target
	local tplayer = PlayerResource:GetPlayer(target:GetPlayerID())
	if tplayer ~= nil then
		ParticleManager:CreateParticleForPlayer("particles/custom_particles/abilities/brawler/brawler_beer_drop.vpcf", PATTACH_EYES_FOLLOW, tplayer, tplayer) 
	end
end