function rewind_hero( keys )
	local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local currTime = GameRules:GetGameTime()
    local ability_level = ability:GetLevel() - 1
    local backtracktime = ability:GetLevelSpecialValueFor("time_back", ability_level)
    local waittime = ability:GetLevelSpecialValueFor("delay", ability_level)
    local sound = keys.soundname

    caster:StopSound(sound)

    if not target.positions or not target.positions[math.floor(currTime-backtracktime)] or not target:IsAlive() then
        ParticleManager:DestroyParticle( target.rewindpfx, false )
    	return 
    end

    FindClearSpaceForUnit(target, target.positions[math.floor(currTime-backtracktime)], true)

    ParticleManager:DestroyParticle( target.rewindpfx, false )

    if target == caster then
        FindClearSpaceForUnit(caster, caster.positions[math.floor(currTime-backtracktime)], true)
    end
end

function timerparticle(keys)
    local caster = keys.caster
    local ability = keys.ability
    local Target = keys.target
    local particle = keys.particlename
    local ability_level = ability:GetLevel() - 1

    local waittime = ability:GetLevelSpecialValueFor("delay", ability_level)

    -- Initialize the timer
    Target.rewind_timer = waittime
    
    local pfx = ParticleManager:CreateParticle( particle, PATTACH_OVERHEAD_FOLLOW, Target )

    local timerCP1_x = math.floor(waittime / 10)
    local timerCP1_y = waittime % 10
    ParticleManager:SetParticleControl( pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )

    Target.rewindpfx = pfx
end

function UpdateTimer( keys )
    local ability = keys.ability
    local Target = keys.target
    local modifier = keys.modifiername
    Target.rewind_timer = Target.rewind_timer - 1

    local pfx = Target.rewindpfx

    local timerCP1_x = math.floor(Target.rewind_timer / 10)
    local timerCP1_y = Target.rewind_timer % 10
    ParticleManager:SetParticleControl( pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )

    -- Checking if target is alive to decide if it needs to increase respawn time
    if not Target:IsAlive() then
        -- Destroy particle FXs
        ParticleManager:DestroyParticle( Target.rewindpfx, false )

        Target:RemoveModifierByName(modifier)
    end
end