local assets_lightning_charged = {
    -- Asset("ANIM", "anim/spear_lance.zip"),
    -- Asset("ANIM", "anim/swap_spear_lance.zip"),

    Asset("ANIM", "anim/spear_lightning_pro.zip"),
    Asset("ANIM", "anim/swap_spear_lightning_pro.zip"),
    Asset("ATLAS", "images/inventoryimages/spear_lightning_pro.xml"),

    Asset("ANIM", "anim/spear_lightning_white.zip"),
    Asset("ANIM", "anim/swap_spear_lightning_white.zip"),
    Asset("ATLAS", "images/inventoryimages/spear_lightning_white.xml"),

    Asset("ANIM", "anim/spear_lightning_pink.zip"),
    Asset("ANIM", "anim/swap_spear_lightning_pink.zip"),
    Asset("ATLAS", "images/inventoryimages/spear_lightning_pink.xml")
}

------------------------------------------------------------------------------
local function RefreshAttunedSkills(inst, owner, prevowner)
    local skilltreeupdater = owner and owner.components.skilltreeupdater or nil

    if owner and owner.components.singinginspiration then
        local skill_level = skilltreeupdater and
                                skilltreeupdater:CountSkillTag("inspirationgain") or
                                0
        if skill_level > 0 then
            owner.components.singinginspiration.gainratemultipliers:SetModifier(
                inst,
                TUNING.SKILLS.WATHGRITHR.INSPIRATION_GAIN_MULT[skill_level],
                "arsenal_spear")
        else
            owner.components.singinginspiration.gainratemultipliers:RemoveModifier(
                inst, "arsenal_spear")
        end
    end

    if prevowner and prevowner.components.singinginspiration then
        prevowner.components.singinginspiration.gainratemultipliers:RemoveModifier(
            inst, "arsenal_spear")
    end

    if _G.IsAoeSkill ~= false then
        if inst.is_lightning_spear then
            inst.components.aoetargeting:SetEnabled(
                inst.components.rechargeable:IsCharged() and skilltreeupdater and
                    skilltreeupdater:IsActivated("wathgrithr_arsenal_spear_4") or
                    false)
        end
    end

end

local function WatchSkillRefresh(inst, owner)
    if inst._owner then
        inst:RemoveEventCallback("onactivateskill_server", inst._onskillrefresh,
                                 inst._owner)
        inst:RemoveEventCallback("ondeactivateskill_server",
                                 inst._onskillrefresh, inst._owner)
    end
    inst._owner = owner
    if owner then
        inst:ListenForEvent("onactivateskill_server", inst._onskillrefresh,
                            owner)
        inst:ListenForEvent("ondeactivateskill_server", inst._onskillrefresh,
                            owner)
    end
end

------------------------------------------------------------------------------------------------------------------------

local CHARGE_SOUND_LOOP_NAME = "soundloop"

local function Lightning_CanElectrocuteTarget(inst, target)
    return not (target:HasTag("electricdamageimmune") or
               (target.components.inventory ~= nil and
                   target.components.inventory:IsInsulated())) and
               target:GetIsWet()
end

local function Lightning_SpellFn_Type0(inst, doer, pos)
    doer:PushEvent("combat_superjump", {targetpos = pos, weapon = inst})
end
local function Lightning_SpellFn_Type1(inst, doer, pos)
    doer:PushEvent("combat_lunge", {targetpos = pos, weapon = inst})
end

local function ApplyDurabilit(inst)
    inst:RemoveTag("jab")
    inst:RemoveTag("superjump")

    inst.components.weapon:SetRange(1)

    inst.components.weapon:SetDamage(TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE1 *
                                         inst.rate)
    inst.components.planardamage:SetBaseDamage(
        TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE1 * inst.rate)

    if _G.IsAoeSkill ~= false then
        inst:RemoveTag("aoeweapon_leap")
        inst:AddTag("aoeweapon_lunge")
        inst.components.aoespell:SetSpellFn(Lightning_SpellFn_Type1)
    end

end

local function DetachDurabilit(inst)
    inst:AddTag("jab")
    inst:AddTag("superjump")

    inst.components.weapon:SetRange(2)

    inst.components.weapon:SetDamage(TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE0 *
                                         inst.rate)

    inst.components.planardamage:SetBaseDamage(
        TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE0 * inst.rate)

    if _G.IsAoeSkill ~= false then
        inst:RemoveTag("aoeweapon_lunge")
        inst:AddTag("aoeweapon_leap")
        inst.components.aoespell:SetSpellFn(Lightning_SpellFn_Type0)
    end
end

local function OnEquip(inst, owner)

     if owner and owner.components.singinginspiration ~= nil and
        owner.components.singinginspiration:IsSongActive({
            NAME = "battlesong_durability_buff"
        }) then
        ApplyDurabilit(inst)

    else
        DetachDurabilit(inst)
    end

    if inst.fx then
        inst.fx:Remove()
        inst.fx = nil
    end

    if inst.components.inventoryitem.imagename == "spear_lightning_pink" then
        local frame =
            math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1
        inst.AnimState:SetFrame(frame)
        inst.fx = SpawnPrefab(inst.components.inventoryitem.imagename .. "_fx")
        inst.fx.AnimState:SetFrame(frame)
    end

    owner.AnimState:OverrideSymbol("swap_object", "swap_" ..
                                       inst.components.inventoryitem.imagename,
                                   "swap_" ..
                                       inst.components.inventoryitem.imagename)

    -- owner.AnimState:OverrideSymbol("swap_object", inst._swapbuild,
    --                                inst._swapsymbol)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner.components.worker == nil then owner:AddComponent("worker") end

    WatchSkillRefresh(inst, owner)
    RefreshAttunedSkills(inst, owner)

    if _G.IsAoeSkill ~= false then
        if inst.components.aoetargeting ~= nil and
            inst.components.aoetargeting:IsEnabled() and
            inst.components.rechargeable ~= nil and
            inst.components.rechargeable:GetTimeToCharge() < inst._cooldown then
            inst.components.rechargeable:Discharge(inst._cooldown)
        end
    end

    if inst.fx ~= nil then
        inst:SetFxOwner(owner)

        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:PlaySound(
                "meta3/wigfrid/spear_wathrithr_lightning_charged",
                CHARGE_SOUND_LOOP_NAME)
        end
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    WatchSkillRefresh(inst, nil)
    RefreshAttunedSkills(inst, nil, owner)
    if inst.fx ~= nil then
        inst:SetFxOwner(nil)

        if owner.SoundEmitter ~= nil then
            owner.SoundEmitter:KillSound(CHARGE_SOUND_LOOP_NAME)
        end
    end
end

------------------------------------------------------------------------------------------------------------------------

local function Lightning_OnAttack(inst, attacker, target)
    if inst.fx then
        SpawnPrefab("spear_lightning_pink_attack_fx"):AlignToTarget(target,
                                                                    attacker,
                                                                    true)
    else
        if target ~= nil and target:IsValid() and
            inst:CanElectrocuteTarget(target) and attacker ~= nil and
            attacker:IsValid() then
            SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker,
                                                           true)
        end
    end

end

local function LightningPink_OnAttack(inst, attacker, target)
    SpawnPrefab("spear_lightning_pink_attack_fx"):AlignToTarget(target,
                                                                attacker, true)
end
------------------------------------------------------------------------------------------------------------------------

local function Lighting_OnLeapPre(inst, doer, startpos, endpos)
    -- 防止吓跑目标
    inst:RemoveTag("scarytoprey")
    inst:AddTag("notarget")

    doer.components.health.externalabsorbmodifiers:SetModifier(doer, 0.6,
                                                               "wathgrithr_spear_leap") -- 减伤
    doer:AddTag("light_pro_nointerrupt") -- 霸体
    local colorf = .2
    doer.components.colouradder:PushColour("wathgrithr_spear_leap", colorf,
                                           colorf, colorf, 0) -- 光效
    doer:DoTaskInTime(2, function(doer)
        doer.components.health.externalabsorbmodifiers:RemoveModifier(doer,
                                                                      "wathgrithr_spear_leap")
        doer.components.colouradder:PopColour("wathgrithr_spear_leap")
        doer:RemoveTag("light_pro_nointerrupt")
    end)

    for _, v in pairs(TheSim:FindEntities(endpos.x, endpos.y, endpos.z, 2)) do
        if v.components and v.components.rideable and
            v.components.rideable.saddle and not v.components.rideable.rider then
            doer.components.rider:Mount(v, true)
            return
        end
    end
end

local function Lightning_OnLeap(inst, doer, startingpos, targetpos)
    SpawnPrefab("superjump_fx"):SetTarget(inst)
    inst.components.rechargeable:Discharge(inst._cooldown)

    local new = SpawnPrefab("lightning")
    new.Transform:SetPosition(targetpos:Get())

    inst._lunge_hit_count = nil

    inst:AddTag("scarytoprey")
    inst:RemoveTag("notarget")
end

local function Lightning_OnLunged(inst, doer, startingpos, targetpos)
    local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx")
    fx.Transform:SetPosition(targetpos:Get())
    fx.Transform:SetRotation(doer:GetRotation())

    inst.components.rechargeable:Discharge(inst._cooldown)

    inst._lunge_hit_count = nil
end

local function Lightning_OnLungedHit(inst, doer, target)
    inst._lunge_hit_count = inst._lunge_hit_count or 0

    if inst._lunge_hit_count < TUNING.SPEAR_LIGHTNING_PRO_MAX_REPAIRS_PER_LUNGE and
        doer.IsValidVictim ~= nil and doer.IsValidVictim(target) then
        inst.components.finiteuses:Repair(
            TUNING.SPEAR_LIGHTNING_PRO_LUNGE_REPAIR_AMOUNT)
        inst._lunge_hit_count = inst._lunge_hit_count + 1
    end
end

local function Lightning_OnLungedHit2(inst, doer, target)
    inst._lunge_hit_count = inst._lunge_hit_count or 0

    if inst._lunge_hit_count < TUNING.SPEAR_LIGHTNING_PRO_MAX_REPAIRS_PER_LUNGE and
        doer.IsValidVictim ~= nil and doer.IsValidVictim(target) then
        inst.components.finiteuses:Repair(
            TUNING.SPEAR_LIGHTNING_PRO_LUNGE_REPAIR_AMOUNT * 2)
        inst._lunge_hit_count = inst._lunge_hit_count + 1

        for i = 1, 7, 1 do
            inst:DoTaskInTime(0.4 + 0.15 * i, function(inst)
                doer.components.combat:DoAttack(target, inst, inst, "strong", 0,
                                                999, inst:GetPosition())

                local pos = target:GetPosition()
                local new = SpawnPrefab("electrichitsparks")
                new.Transform:SetPosition(pos:Get())

                inst.components.finiteuses:Repair(1)
            end)
        end
    end
end

local function Lightning_OnDischarged(inst)
    inst.components.aoetargeting:SetEnabled(false)
end

local function Lightning_OnCharged(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()

    if owner ~= nil and owner.components.skilltreeupdater ~= nil and
        owner.components.skilltreeupdater:IsActivated(
            "wathgrithr_arsenal_spear_4") then
        inst.components.aoetargeting:SetEnabled(true)
    end
end
local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    -- Cast range is 8, leave room for error
    -- 2 is the aoe range
    for r = 5, 0, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and
            not ground:IsGroundTargetBlocked(pos) then return pos end
    end
    return pos
end

local function Lightning_ReticuleTargetFn()
    -- Cast range is 8, leave room for error (6.5 lunge)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end

local function Lightning_ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then return inst.components.reticule.targetpos end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end

local function Lightning_ReticuleUpdatePositionFn(inst, pos, reticule, ease,
                                                  smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp(
                  (drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or
                      rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end

-----------------------------------------------------------------------------------------------------------------------
local function LightningCharged_SetFxOwner(inst, owner)
    if inst.fx == nil then return end

    if inst._fxowner ~= nil and inst._fxowner.components.colouradder ~= nil then
        inst._fxowner.components.colouradder:DetachChild(inst.fx)
    end

    inst._fxowner = owner

    -- local offset = {-35, -40, 0}
    local offset = {0, 0, 0}

    if owner ~= nil then
        inst.fx.entity:SetParent(owner.entity)

        inst.fx.Follower:FollowSymbol(owner.GUID, "swap_object", offset[1],
                                      offset[2], offset[3], true)
        inst.fx.components.highlightchild:SetOwner(owner)

        if owner.components.colouradder ~= nil then
            owner.components.colouradder:AttachChild(inst.fx)
        end
    else
        inst.fx.entity:SetParent(inst.entity)

        -- For floating.
        inst.fx.Follower:FollowSymbol(inst.GUID, "swap_spear", offset[1],
                                      offset[2], offset[3], true)
        inst.fx.components.highlightchild:SetOwner(inst)
    end
end

local function PushIdleLoop(inst) inst.AnimState:PushAnimation("idle") end

local function LightningCharged_OnStopFloating(inst)
    if inst.fx == nil then return end

    inst.fx.AnimState:SetFrame(0)
    inst:DoTaskInTime(0, PushIdleLoop) -- #V2C: #HACK restore the looping anim, timing issues.
end

local function LightningCharged_OnEntityWake(inst)
    if inst:IsInLimbo() or inst:IsAsleep() then return end

    if not inst.SoundEmitter:PlayingSound(CHARGE_SOUND_LOOP_NAME) then
        inst.SoundEmitter:PlaySound(
            "meta3/wigfrid/spear_wathrithr_lightning_charged",
            CHARGE_SOUND_LOOP_NAME)
    end
end

local function LightningCharged_OnEntitySleep(inst)
    inst.SoundEmitter:KillSound(CHARGE_SOUND_LOOP_NAME)
end

local function ChangeWeaponState(inst, data)
    local owner = inst.components.inventoryitem.owner

    if owner and owner.components.singinginspiration ~= nil and
        owner.components.singinginspiration:IsSongActive({
            NAME = "battlesong_durability_buff"
        }) then
        ApplyDurabilit(inst)

    else
        DetachDurabilit(inst)
    end

    -- if data.type == 0 then
    --     DetachDurabilit(inst)
    -- elseif data.type == 1 then
    --     ApplyDurabilit(inst)
    -- end
end

local function Battlesong_Durability(inst, data) ChangeWeaponState(inst, data) end

------------------------------------------------------------------------------------------------------------------------

local function CommonFn(data)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(data.res)
    inst.AnimState:SetBuild(data.res)
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("battlespear")
    -- inst:AddTag("superjump")

    -- weapon (from weapon component) added to pristine state for optimization.
    inst:AddTag("weapon")

    -- MakeInventoryFloatable(inst, "med", 0.1, { 0.7, 0.5, 0.7 }, true, -9,
    --     { sym_build = data.swapbuild, sym_name = data.swapsymbol })
    MakeInventoryFloatable(inst)

    inst:AddTag("jab")

    if data.commonfn ~= nil then data.commonfn(inst) end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst._swapbuild = "swap_" .. data.res
    inst._swapsymbol = "swap_" .. data.res

    inst._onskillrefresh = function(owner) RefreshAttunedSkills(inst, owner) end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = data.res
    inst.components.inventoryitem.atlasname = data.atlas

    inst:AddComponent("weapon")
    inst.rate = data.rate
    inst.components.weapon:SetDamage(data.damage * inst.rate)
    inst.components.weapon:SetOnAttack(data.attack)
    inst.components.weapon:SetElectric(1,
                                       TUNING.SPEAR_WATHGRITHR_LIGHTNING_WET_DAMAGE_MULT)
    inst.components.weapon:SetRange(TUNING.WHIP_RANGE)
    if data.planardamage ~= nil then
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(data.planardamage)
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(data.uses)
    inst.components.finiteuses:SetUses(data.uses)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)

    inst.SetFxOwner = LightningCharged_SetFxOwner
    inst.OnStopFloating = LightningCharged_OnStopFloating

    inst:ListenForEvent("floater_stopfloating", inst.OnStopFloating)

    inst:SetFxOwner(nil)

    inst.OnBattlesongDurability = Battlesong_Durability
    inst:ListenForEvent("inspirationsongchanged", inst.OnBattlesongDurability)

    if data.postinitfn ~= nil then data.postinitfn(inst) end

    return inst
end

local function LightningSpearCommonFn_ChargedPro(inst)
    if _G.IsAoeSkill ~= false then
        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting:SetAllowRiding(true)
        inst.components.aoetargeting:SetRange(32)
        inst.components.aoetargeting.reticule.reticuleprefab =
            "reticuleaoesmall"
        inst.components.aoetargeting.reticule.pingprefab =
            "reticuleaoesmallping"
        inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
        inst.components.aoetargeting.reticule.validcolour = {1, .75, 0, 1}
        inst.components.aoetargeting.reticule.invalidcolour = {.5, 0, 0, 1}
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true
        inst.entity:AddSoundEmitter()
    end

    inst.AnimState:PlayAnimation("idle", true)

    inst.itemtile_lightning = true
end

local function SpearWathgrithr_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function SpearWathgrithr_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end
    local spear = SpawnPrefab("spear_lightning_pro2")

    if spear.components.rechargeable then
        spear.components.rechargeable:Discharge(spear._cooldown)
        spear.components.rechargeable:SetPercent(
            inst.components.rechargeable:GetPercent())
    end

    if spear.components.finiteuses then
        spear.components.finiteuses:SetPercent(
            inst.components.finiteuses:GetPercent())
    end

    local container = inst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local slot = inst.components.inventoryitem:GetSlotNum()
        inst:Remove()
        container:GiveItem(spear, slot)
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:Remove()
        spear.Transform:SetPosition(x, y, z)
    end
end

local function LightningSpearPostInitFn_ChargedPro(inst)
    inst.scrapbook_weapondamage = {
        TUNING.SPEAR_WATHGRITHR_LIGHTNING_DAMAGE,
        TUNING.SPEAR_WATHGRITHR_LIGHTNING_DAMAGE *
            (1 + TUNING.SPEAR_WATHGRITHR_LIGHTNING_WET_DAMAGE_MULT)
    }

    inst.CanElectrocuteTarget = Lightning_CanElectrocuteTarget

    inst.is_lightning_spear = true

    if _G.IsAoeSkill ~= false then
        inst.components.aoetargeting:SetEnabled(false)

        -- 冲天刺技能
        inst:AddTag("superjump")
        inst:AddTag("aoeweapon_leap")
        inst:AddComponent("aoeweapon_leap")
        inst.components.aoeweapon_leap:SetAOERadius(2.5)
        inst.components.aoeweapon_leap:SetDamage(
            TUNING.SPEAR_LIGHTNING_PRO_SKILL_DAMAGE_TYPE0)
        inst.components.aoeweapon_leap:SetStimuli("electric")
        inst.components.aoeweapon_leap:SetOnLeaptFn(Lightning_OnLeap)
        inst.components.aoeweapon_leap:SetOnPreLeapFn(Lighting_OnLeapPre)
        inst.components.aoeweapon_leap:SetOnHitFn(Lightning_OnLungedHit)
        inst.components.aoeweapon_leap:SetTags("_combat")
        inst.components.aoeweapon_leap:SetNoTags("FX", "DECOR", "INLIMBO",
                                                 "moonstorm_static", "wall")
        inst.components.aoeweapon_leap:SetWorkActions(ACTIONS.CHOP, ACTIONS.MINE)

        -- 冲刺技能
        inst:AddComponent("aoeweapon_lunge")
        inst.components.aoeweapon_lunge:SetDamage(
            TUNING.SPEAR_LIGHTNING_PRO_SKILL_DAMAGE_TYPE1)
        inst.components.aoeweapon_lunge:SetSound(
            "meta3/wigfrid/spear_lighting_lunge")
        inst.components.aoeweapon_lunge:SetSideRange(1)
        inst.components.aoeweapon_lunge:SetOnLungedFn(Lightning_OnLunged)
        inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)
        inst.components.aoeweapon_lunge:SetStimuli("electric")
        inst.components.aoeweapon_lunge:SetWorkActions()
        inst.components.aoeweapon_lunge:SetTags("_combat")

        -- 默认使用冲天刺
        inst:AddComponent("aoespell")
        inst.components.aoespell:SetSpellFn(Lightning_SpellFn_Type0)

        inst:AddTag("rechargeable")
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnDischargedFn(Lightning_OnDischarged)
        inst.components.rechargeable:SetOnChargedFn(Lightning_OnCharged)
        inst.scrapbook_tex = "spear_wathgrithr_lightning_charged"

        inst._cooldown = TUNING.SPEAR_LIGHTNING_PRO_LUNGE_COOLDOWN

        inst.OnEntityWake = LightningCharged_OnEntityWake
        inst.OnEntitySleep = LightningCharged_OnEntitySleep

        inst:ListenForEvent("exitlimbo", inst.OnEntityWake)
        inst:ListenForEvent("enterlimbo", inst.OnEntitySleep)
    end

    inst.components.inspectable:SetNameOverride("spear_lightning_pro")
    inst.components.equippable.walkspeedmult =
        TUNING.SPEAR_LIGHTNING_PRO_SPEED_MULT

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype =
        UPGRADETYPES.Wathgrithr_NewConstantSpear
    inst.components.upgradeable:SetOnUpgradeFn(SpearWathgrithr_OnUpgraded)
    inst.components.upgradeable:SetCanUpgradeFn(SpearWathgrithr_CanBeUpgraded)
end

local function LightningSpearPostInitFn_ChargedPro2(inst)
    LightningSpearPostInitFn_ChargedPro(inst)

    if _G.IsAoeSkill ~= false then
        inst.components.aoeweapon_leap:SetOnHitFn(Lightning_OnLungedHit2)

    end
end

local function LightningSpearChargedProFn()
    return CommonFn({
        atlas = "images/inventoryimages/spear_lightning_pro.xml",
        res = "spear_lightning_pro",
        damage = TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE0,
        planardamage = TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE0,
        rate = 1,
        uses = TUNING.SPEAR_LIGHTNING_PRO_USES,
        commonfn = LightningSpearCommonFn_ChargedPro,
        postinitfn = LightningSpearPostInitFn_ChargedPro,
        attack = Lightning_OnAttack

    })
end

local function LightningSpearChargedPro2Fn()
    return CommonFn({
        atlas = "images/inventoryimages/spear_lightning_pro.xml",
        res = "spear_lightning_pro",
        damage = TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE0,
        planardamage = TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE0,
        rate = 1.5,
        uses = TUNING.SPEAR_LIGHTNING_PRO_USES * 2,
        commonfn = LightningSpearCommonFn_ChargedPro,
        postinitfn = LightningSpearPostInitFn_ChargedPro2,
        attack = Lightning_OnAttack
    })
end

------------------------------------------------------------------------------

return Prefab("spear_lightning_pro", LightningSpearChargedProFn,
              assets_lightning_charged),
       Prefab("spear_lightning_pro2", LightningSpearChargedPro2Fn,
              assets_lightning_charged)

