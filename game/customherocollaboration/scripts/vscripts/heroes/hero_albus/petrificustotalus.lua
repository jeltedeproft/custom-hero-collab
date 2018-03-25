function waitforspell( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local victim = keys.target
	local swaphero = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local magic_missile_speed = ability:GetSpecialValueFor("magic_missile_speed")

	--time before hermione says petrificus totalus and spell being launched
	local waittime = 1.15

	Timers:CreateTimer(waittime, function ()
        --create projectile
        local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
			Ability = ability,
			iMoveSpeed = magic_missile_speed,
			Source = caster,
			Target = victim,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
        }

        ProjectileManager:CreateTrackingProjectile( info )
	end)
end

function applymodifer( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local target = keys.target
	local ability = keys.ability
	local stun_duration = ability:GetSpecialValueFor("duration")
	local modifier = keys.modifiername

	--talent
	local talent = caster:FindAbilityByName("petrificus_stun_duration_bonus")

	if talent:GetLevel() > 0 then
		stun_duration = stun_duration + talent:GetSpecialValueFor("value")
	end
	
	ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = stun_duration})
end