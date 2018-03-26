function StoneGazeHit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local facing_degree = ability:GetLevelSpecialValueFor( "facing_degree", ability:GetLevel() - 1 )
	local dirToCaster = (caster:GetAbsOrigin() - target:GetAbsOrigin())
	local targetFv = target:GetForwardVector()
	local diff = RotationDelta(VectorToAngles(dirToCaster), VectorToAngles(targetFv))
	local half = facing_degree/2
	if diff.y > -half and diff.y < half then
		EmitSoundOn("Hero_Medusa.StoneGaze.Target", target)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_stone_gaze", {})
	end
end