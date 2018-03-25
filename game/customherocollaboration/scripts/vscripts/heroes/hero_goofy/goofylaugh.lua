function laughsound(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local sound = keys.soundname

	caster:EmitSound(sound)

	Timers:CreateTimer(duration, function ()
	        caster:StopSound(sound)
	end)
end

function stoplaughsound(keys)
	local caster = keys.caster
	local ability = keys.ability
	local sound = keys.soundname

	caster:StopSound(sound)
end