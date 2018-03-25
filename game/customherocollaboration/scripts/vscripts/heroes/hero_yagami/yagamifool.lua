function fool(keys)
    local caster = keys.caster
    local caster_position = caster:GetAbsOrigin()
    local caster_team = caster:GetTeamNumber()
    local player = caster:GetPlayerOwner()
    local playerid = player:GetPlayerID()
    local ability = keys.ability
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
    local modifier = keys.modifiername

    --talent
    local talent = caster:FindAbilityByName("yagami_fool_extra_time")

    if talent:GetLevel() > 0 then
        duration = duration + talent:GetSpecialValueFor("value")
    end


    --make fake yagami
    local fake_yagami = CreateUnitByName("npc_dota_hero_bane", caster_position, true, caster, nil, caster_team)

    FindClearSpaceForUnit(fake_yagami, caster_position, true)
    fake_yagami:SetControllableByPlayer(playerid, true)
    fake_yagami:SetOwner(caster:GetOwner())
    fake_yagami:SetPlayerID(caster:GetPlayerID())
    ability:ApplyDataDrivenModifier(caster, fake_yagami, modifier, nil)

    --same level
    local caster_level = caster:GetLevel()
    for i = 1, caster_level do
        fake_yagami:HeroLevelUp(false)
        --fake_yagami:CreatureLevelUp(1)
    end

    --give fake abilities
    for ability_id = 0, 15 do
        local ability = fake_yagami:GetAbilityByIndex(ability_id)
        if ability then 
            if ability:GetName() == "yagamifool" then
                fake_yagami:RemoveAbility("yagamifool")
                fake_yagami:AddAbility("fakeyagamifool")
            elseif ability:GetName() == "yagamiwords" then
                fake_yagami:RemoveAbility("yagamiwords")
                fake_yagami:AddAbility("fakeyagamiwords")
            elseif ability:GetName() == "yagamieyes" then
                fake_yagami:RemoveAbility("yagamieyes")
                fake_yagami:AddAbility("fakeyagamieyes")
            elseif ability:GetName() == "yagamideathnote" then
                fake_yagami:RemoveAbility("yagamideathnote")
                fake_yagami:AddAbility("fakeyagamideathnote")
            end
        end
    end
    
    --make sure all ability levels are the same
    for ability_id = 0, 15 do
        local ability = fake_yagami:GetAbilityByIndex(ability_id)
        if ability then
            ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
        end
    end

    --items
    for item_id = 0, 5 do
        local item_in_caster = caster:GetItemInSlot(item_id)
        --new update gives players a tp scroll, so dont add it, if the charges dont match, so be it, its no big deal, they still dont know which is which
        if item_in_caster ~= nil and item_in_caster:GetName() ~= "item_tpscroll" then
            local item_name = item_in_caster:GetName()
            local item_created = CreateItem( item_in_caster:GetName(), fake_yagami, fake_yagami)
            fake_yagami:AddItem(item_created)

            if item_in_caster:GetCurrentCharges() > 1 then
                item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges())
            end 
        end
    end

    fake_yagami:SetAbilityPoints(0)

    fake_yagami:SetMaximumGoldBounty(100)
    fake_yagami:SetMinimumGoldBounty(100)
    fake_yagami:SetDeathXP(100) 

    --fake_yagami:SetHasInventory(false)
    fake_yagami:SetCanSellItems(false)

    --store for killing later
    ability.fakeyagami = fake_yagami

    --hp and mp
    local yagamiHP = caster:GetHealth()
    local yagamiMP = caster:GetMana()

    fake_yagami:SetHealth(yagamiHP)
    fake_yagami:SetMana(yagamiMP)

    fake_yagami:MakeIllusion()
end

function destroythisunit(keys)
    local ability = keys.ability
    local caster = keys.caster
    local modifier = keys.modifiername

    --destroy fake yagami after time runs out
    ability.fakeyagami:RemoveModifierByName(modifier)
    ability.fakeyagami:Kill(ability,caster)
end


