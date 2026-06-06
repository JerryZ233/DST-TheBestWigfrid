local assets =
{
    Asset("ANIM", "anim/wathgrithr_shield.zip"),
    Asset("ANIM", "anim/swap_wathgrithr_shield.zip"),
}

local prefabs =
{
    "reticulearc",
    "reticulearcping",
}

------------------------------------------------------------------------------------------------------------------------
local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    -- inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
end
local function OnCaught(inst, catcher)
    if catcher ~= nil and catcher.components.inventory ~= nil and catcher.components.inventory.isopen then
        if inst.components.equippable ~= nil and not catcher.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
            catcher.components.inventory:Equip(inst)
        else
            catcher.components.inventory:GiveItem(inst)
        end
        catcher:PushEvent("catch")
    end
end

local function OnDropped(inst)
    -- inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.pushlandedevents = true
    inst:PushEvent("on_landed")
end

local function ReturnToOwner(inst, owner)
    
    if owner ~= nil and not (inst.components.finiteuses ~= nil and inst.components.finiteuses:GetUses() <= 0) then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst.components.projectile:Throw(owner, owner)
        -- inst.components.projectile:Catch(owner)
    end
end
local function OnPreHit(inst, owner, target)

end


local function OnHit(inst, owner, target)
    if owner == target or owner:HasTag("playerghost") then
        OnCaught(inst,owner)
    else
        ReturnToOwner(inst, owner)
    end
    if target ~= nil and target:IsValid() and target.components.combat then
        local impactfx = SpawnPrefab("impact")
        if impactfx ~= nil then
            local follower = impactfx.entity:AddFollower()
            follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
            impactfx:FacePoint(inst.Transform:GetWorldPosition())
        end
    end
end

local function OnMiss(inst, owner, target)
    if owner == target then
        OnCaught(inst,owner)
    else
        ReturnToOwner(inst, owner)
    end
end

local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

------------------------------------------------------------------------------------------------------------------------
local function DamageFn(inst)
    if inst:HasTag("thrown") then
        if inst._lastparrytime ~= nil and (inst._lastparrytime + TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_DURATION) >= GetTime() then
            return 34 + (inst._bonusdamage or 0)
        end
    
        return 34
    else
        if inst._lastparrytime ~= nil and (inst._lastparrytime + TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_DURATION) >= GetTime() then
            return TUNING.WATHGRITHR_SHIELD_DAMAGE + (inst._bonusdamage or 0)
        end
    
        return TUNING.WATHGRITHR_SHIELD_DAMAGE 
    end

end

local function ApplyDurabilit(inst)
    inst:RemoveTag("thrown")
    inst:RemoveTag("projectile")

    inst:RemoveComponent("projectile")

    inst.components.weapon:SetRange(1)

    TUNING.WATHGRITHR_SHIELD_DAMAGE = 51
    inst.components.weapon:SetDamage(DamageFn)

end

local function DetachDurabilit(inst)
    inst:AddTag("thrown")
    inst:AddTag("projectile")

    inst:RemoveComponent("projectile")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(10)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnCaughtFn(OnCaught)

    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE+2)

    TUNING.WATHGRITHR_SHIELD_DAMAGE = 34
    inst.components.weapon:SetDamage(DamageFn)

end

local function OnEquip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Show("lantern_overlay")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:HideSymbol("swap_object")

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("lantern_overlay", skin_build, "swap_shield", inst.GUID, "swap_wathgrithr_shield")
        owner.AnimState:OverrideItemSkinSymbol("swap_shield",     skin_build, "swap_shield", inst.GUID, "swap_wathgrithr_shield")
    else
        owner.AnimState:OverrideSymbol("lantern_overlay", "swap_wathgrithr_shield", "swap_shield")
        owner.AnimState:OverrideSymbol("swap_shield",     "swap_wathgrithr_shield", "swap_shield")
    end

    if inst.components.rechargeable:GetTimeToCharge() < TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONEQUIP then
        inst.components.rechargeable:Discharge(TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONEQUIP)
    end

    if owner:HasTag("battlesong_durability_buff") then
        ApplyDurabilit(inst)
    else
        DetachDurabilit(inst)
    end

end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:ClearOverrideSymbol("swap_shield")

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Hide("lantern_overlay")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ShowSymbol("swap_object")

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end

    
end

------------------------------------------------------------------------------------------------------------------------

local function SpellFn(inst, doer, pos)
    local duration_mult =
        doer.components.skilltreeupdater ~= nil and
        doer.components.skilltreeupdater:IsActivated("wathgrithr_arsenal_shield_2") and
        TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_DURATION_MULT or
        1

    inst.components.parryweapon:EnterParryState(doer, doer:GetAngleToPoint(pos), TUNING.WATHGRITHR_SHIELD_PARRY_DURATION * duration_mult)
    inst.components.rechargeable:Discharge(TUNING.WATHGRITHR_SHIELD_COOLDOWN)
end

local function OnParry(inst, doer, attacker, damage)
    doer:ShakeCamera(CAMERASHAKE.SIDE, 0.1, 0.03, 0.3)

    if inst.components.rechargeable:GetPercent() < TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION then
        inst.components.rechargeable:SetPercent(TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION)
    end

    if doer.components.skilltreeupdater ~= nil and doer.components.skilltreeupdater:IsActivated("wathgrithr_arsenal_shield_3") then
        inst._lastparrytime = GetTime()

        local tuning = TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE
        local scale =  TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_SCALE

        inst._bonusdamage = math.clamp(damage * scale, tuning.min, tuning.max)
    end
end

local function DamageFn(inst)
    if inst._lastparrytime ~= nil and (inst._lastparrytime + TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_DURATION) >= GetTime() then
        return TUNING.WATHGRITHR_SHIELD_DAMAGE + (inst._bonusdamage or 0)
    end

    return TUNING.WATHGRITHR_SHIELD_DAMAGE 

end

local function OnAttackFn(inst, attacker, target)
    inst._lastparrytime = nil
    inst._bonusdamage = nil

    inst.components.armor:TakeDamage(TUNING.WATHGRITHR_SHIELD_USEDAMAGE)
end

local function OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function OnCharged(inst)
    inst.components.aoetargeting:SetEnabled(true)
end



local function ChangeWeaponState(inst, data)

    if data.type == 0 then
        DetachDurabilit(inst)
    elseif data.type == 1 then
        ApplyDurabilit(inst)
    end
end

local function Battlesong_Durability(inst, data) ChangeWeaponState(inst, data) end
------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("wathgrithr_shield")
    inst.AnimState:SetBuild("wathgrithr_shield")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("toolpunch")
    inst:AddTag("battleshield")
    inst:AddTag("shield")

    inst:AddTag("thrown")
    inst:AddTag("projectile")


    --parryweapon (from parryweapon component) added to pristine state for optimization
    inst:AddTag("parryweapon")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --rechargeable (from rechargeable component) added to pristine state for optimization
    inst:AddTag("rechargeable")

    MakeInventoryFloatable(inst, nil, 0.2, {1.1, 0.6, 1.1})

    inst:AddComponent("aoetargeting")
    inst.components.aoetargeting:SetAlwaysValid(true)
    inst.components.aoetargeting:SetAllowRiding(false)
    inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
    inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
    inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
    inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
    inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
    inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
    inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
    inst.components.aoetargeting.reticule.ease = true
    inst.components.aoetargeting.reticule.mouseenabled = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.scrapbook_weapondamage = TUNING.WATHGRITHR_SHIELD_DAMAGE

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("weapon")
    TUNING.WATHGRITHR_SHIELD_DAMAGE = 34
    inst.components.weapon:SetDamage(DamageFn)
    inst.components.weapon:SetOnAttack(OnAttackFn)
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE+2)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.WATHGRITHR_SHIELD_ARMOR, TUNING.WATHGRITHR_SHIELD_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.restrictedtag = "wathgrithrshielduser"
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("aoespell")
    inst.components.aoespell:SetSpellFn(SpellFn)

    inst:AddComponent("parryweapon")
    inst.components.parryweapon:SetParryArc(TUNING.WATHGRITHR_SHIELD_PARRY_ARC)
    --inst.components.parryweapon:SetOnPreParryFn(OnPreParry)
    inst.components.parryweapon:SetOnParryFn(OnParry)

    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(10)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnPreHitFn(OnPreHit)

    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnCaughtFn(OnCaught)

    inst.OnBattlesongDurability = Battlesong_Durability
    inst:ListenForEvent("battlesong_durability", inst.OnBattlesongDurability)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("wathgrithr_shield", fn, assets, prefabs)