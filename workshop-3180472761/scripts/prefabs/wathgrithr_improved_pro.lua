local assets = {
    Asset("ANIM", "anim/hat_wathgrithr_improved.zip"),
    Asset("ANIM", "anim/hat_recharger.zip"),

    Asset("ANIM", "anim/wathgrithr_improved_pro.zip"),
    Asset("ATLAS", "images/inventoryimages/wathgrithr_improved_pro.xml"),
    Asset("IMAGE", "images/inventoryimages/wathgrithr_improved_pro.tex"),

    Asset("ANIM", "anim/wathgrithr_hat_pro.zip"),
    Asset("ATLAS", "images/inventoryimages/wathgrithr_hat_pro.xml"),
    Asset("IMAGE", "images/inventoryimages/wathgrithr_hat_pro.tex")

}

-- local prefabname = symname

-- do not pass this function to equippable:SetOnEquip as it has different a parameter listing
local function _onequip(inst, owner, symbol_override, headbase_hat_override)
    owner.AnimState:OverrideSymbol("swap_hat", inst.data.fname, "swap_hat")
    owner.AnimState:Show("HAT")
    -- owner.AnimState:Show("HAIR_HAT")
    -- owner.AnimState:Show("HEAD_HAT")
    -- owner.AnimState:Hide("HAIR_NOHAT")
    -- owner.AnimState:Hide("HAIR")
    -- owner.AnimState:Hide("HEAD")
end

local function _onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    -- owner.AnimState:Hide("HAIR_HAT")
    -- owner.AnimState:Hide("HEAD_HAT")

    -- owner.AnimState:Show("HAIR_NOHAT")
    -- owner.AnimState:Show("HAIR")
    -- owner.AnimState:Show("HEAD")
end

local simple_onequiptomodel = function(inst, owner, from_ground)
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local wathgrithr_watchskillrefresh = function(inst, owner)
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

local wathgrithr_refreshattunedskills = function(inst, owner)
    local skilltreeupdater = owner and owner.components.skilltreeupdater or nil

    if inst.components.armor then
        local skill_level = skilltreeupdater and
                                skilltreeupdater:CountSkillTag("helmetcondition") or
                                0
        if skill_level > 0 then
            inst.components.armor.conditionlossmultipliers:SetModifier(inst,
                                                                       TUNING.SKILLS
                                                                           .WATHGRITHR
                                                                           .WATHGRITHRHAT_DURABILITY_MOD[skill_level],
                                                                       "arsenal_helm")
        else
            inst.components.armor.conditionlossmultipliers:RemoveModifier(inst,
                                                                          "arsenal_helm")
        end
    end

    if inst._is_improved_hat then
        if skilltreeupdater and
            skilltreeupdater:IsActivated("wathgrithr_arsenal_helmet_4") then
            inst.components.planardefense:AddBonus(inst, TUNING.SKILLS
                                                       .WATHGRITHR
                                                       .HELM_PLANAR_DEF,
                                                   "wathgrithr_arsenal_helmet_4")
        else
            inst.components.planardefense:RemoveBonus(inst,
                                                      "wathgrithr_arsenal_helmet_4")
        end

        if skilltreeupdater and
            skilltreeupdater:IsActivated("wathgrithr_arsenal_helmet_5") then
            inst:AddTag("battleborn_repairable")
        else
            inst:RemoveTag("battleborn_repairable")
        end
    end
end

-- 攻击召唤虚影
local function alterguardian_spawngestalt_fn(inst, owner, data)
    if owner ~= nil and
        (owner.components.health == nil or not owner.components.health:IsDead()) then
        local target = data.target
        if target and target ~= owner and target:IsValid() and
            (target.components.health == nil or
                not target.components.health:IsDead() and
                not target:HasTag("structure") and not target:HasTag("wall")) then
            -- In combat, this is when we're just launching a projectile, so don't spawn a gestalt yet
            if data.weapon ~= nil and data.projectile == nil and
                (data.weapon.components.projectile ~= nil or
                    data.weapon.components.complexprojectile ~= nil or
                    data.weapon.components.weapon:CanRangedAttack()) then
                return
            end

            local x, y, z = target.Transform:GetWorldPosition()

            local gestalt = SpawnPrefab("alterguardianhat_projectile")
            local r = GetRandomMinMax(3, 5)
            local delta_angle = GetRandomMinMax(-90, 90)
            local angle = (owner:GetAngleToPoint(x, y, z) + delta_angle) *
                              DEGREES
            gestalt.Transform:SetPosition(x + r * math.cos(angle), y,
                                          z + r * -math.sin(angle))
            gestalt:ForceFacePoint(x, y, z)
            gestalt:SetTargetPosition(Vector3(x, y, z))
            gestalt.components.follower:SetLeader(owner)
        end
    end
end

local wathgrithr_onequip = function(inst, owner)
    _onequip(inst, owner)

    if inst.data.light == true then
        inst.alterguardian_spawngestalt_fn =
            function(_owner, _data)
                alterguardian_spawngestalt_fn(inst, _owner, _data)
            end
        inst:ListenForEvent("onattackother", inst.alterguardian_spawngestalt_fn,
                            owner)

        if inst._light == nil then
            inst._light = SpawnPrefab("alterguardianhatlight")
            inst._light.entity:SetParent(owner.entity)

            inst._light.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
        end
    end

    wathgrithr_watchskillrefresh(inst, owner)
    wathgrithr_refreshattunedskills(inst, owner)
end

local wathgrithr_onunequip = function(inst, owner)
    _onunequip(inst, owner)

    if inst.data.light then
        inst:RemoveEventCallback("onattackother",
                                 inst.alterguardian_spawngestalt_fn, owner)
        if inst._light ~= nil then
            inst._light:Remove()
            inst._light = nil
        end
    end

    wathgrithr_watchskillrefresh(inst, nil)
    wathgrithr_refreshattunedskills(inst, nil)
end

local function WathgrithrHat_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function WathgrithrHat_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end
    local hat = SpawnPrefab("wathgrithr_improved_pro2", nil, nil)
    hat.components.armor:SetPercent(inst.components.armor:GetPercent())

    local container = inst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local slot = inst.components.inventoryitem:GetSlotNum()
        inst:Remove()
        container:GiveItem(hat, slot)
    else
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:Remove()
        hat.Transform:SetPosition(x, y, z)
    end
end

local function SetKeepOnFinished(inst)
    if inst.components.armor.SetKeepOnFinished == nil then -- 有的mod替换了这个组件，导致没兼容官方的新函数
        inst.components.armor.keeponfinished = true
    else
        inst.components.armor:SetKeepOnFinished(true) -- 耐久为0不消失
    end
end

local function OnRepaired_sivmask2(inst, amount)
    if amount > 0 and inst._broken then
        inst._broken = nil
        inst.components.armor:SetAbsorption(inst.data.absorption)
        inst.components.planardefense:SetBaseDefense(inst.data.planardefense)

        if inst.data.speed then
            inst.components.equippable.walkspeedmult = inst.data.speed
        end

        inst.components.equippable.insulated = true
        inst.components.waterproofer:SetEffectiveness(
            TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_WATERPROOFNESS)

    end
end
local function OnBroken_sivmask2(inst)
    if not inst._broken then
        inst._broken = true
        inst.components.armor:SetAbsorption(0)
        inst.components.planardefense:SetBaseDefense(0)

        if inst.data.speed then
            inst.components.equippable.walkspeedmult = 1
        end

        inst.components.equippable.insulated = false
        inst.components.waterproofer:SetEffectiveness(0)

    end
end

local function MakeHat(data)
    local inst = CreateEntity()

    inst.data = data

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(data.symname)
    inst.AnimState:SetBuild(data.fname)
    inst.AnimState:PlayAnimation(data.swap_data.anim)

    inst:AddTag("hat")
    inst:AddTag("wathgrithr_improved_pro")
    inst:AddTag("gestaltprotection")

    inst:AddTag("waterproofer")
    inst:AddTag("battlehelm")
    inst:AddTag("heavyarmor")

    MakeInventoryFloatable(inst)
    inst.components.floater:SetBankSwapOnFloat(false, nil, data.swap_data) -- Hats default animation is not "idle", so even though we don't swap banks, we need to specify the swap_data for re-skinning to reset properly when floating

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inventoryitem")
    if data.imagename ~= nil then
        inst.components.inventoryitem.imagename = data.imagename
    end

    if data.atlasname ~= nil then
        inst.components.inventoryitem.atlasname = data.atlasname
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    if not TheWorld.ismastersim then return inst end

    inst._is_improved_hat = true

    inst._onskillrefresh = function(owner)
        wathgrithr_refreshattunedskills(inst, owner)
    end

    inst:AddComponent("armor")
    -- 防御系数
    inst.components.armor:InitCondition(data.health, data.absorption)

    SetKeepOnFinished(inst)
    inst.components.armor:SetOnFinished(OnBroken_sivmask2)
    inst.components.armor.onrepair = OnRepaired_sivmask2

    inst:AddComponent("planardefense")
    inst.components.planardefense:SetBaseDefense(data.planardefense)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquipToModel(simple_onequiptomodel)
    inst.components.equippable:SetOnEquip(wathgrithr_onequip)
    inst.components.equippable:SetOnUnequip(wathgrithr_onunequip)

    if data.speed then inst.components.equippable.walkspeedmult = data.speed end
    -- 避雷
    inst.components.equippable.insulated = true

    inst:AddComponent("waterproofer")
    -- 防水系数
    inst.components.waterproofer:SetEffectiveness(data.waterproofness)

    -- inst:AddComponent("insulator")
    -- inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)

    if data.upgradeable then
        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = data.upgradeable
        inst.components.upgradeable:SetOnUpgradeFn(WathgrithrHat_OnUpgraded)
        inst.components.upgradeable:SetCanUpgradeFn(WathgrithrHat_CanBeUpgraded)
    end

    return inst
end

local function fn()
    return MakeHat({
        imagename = "lavaarena_rechargerhat",
        atlasname = nil,
        symname = "rechargerhat",
        fname = "hat_recharger",
        health = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_HEALTH,
        absorption = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_ABSORPTION,
        planardefense = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_PLANAR,
        upgradeable = UPGRADETYPES.Wathgrithr_NewConstantHat,
        speed = nil,
        light = true,
        swap_data = {bank = "rechargerhat", anim = "anim"},
        waterproofness = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_WATERPROOFNESS

    })
end

local function fn2()
    return MakeHat({
        imagename = "lavaarena_rechargerhat",
        atlasname = nil,
        symname = "rechargerhat",
        fname = "hat_recharger",
        health = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_HEALTH * 2,
        absorption = .9,
        planardefense = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_PLANAR * 2,
        upgradeable = nil,
        speed = 1.15,
        light = true,
        swap_data = {bank = "rechargerhat", anim = "anim"},
        waterproofness = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_WATERPROOFNESS
    })
end

local function fn3()
    return MakeHat({
        imagename = "hat_0",
        atlasname = "images/inventoryimages/wathgrithr_improved_pro.xml",
        symname = "wathgrithr_improved_pro",
        fname = "wathgrithr_improved_pro",
        health = TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_HEALTH * 2,
        absorption = TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_ABSORPTION,
        planardefense = TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_PLANAR,
        upgradeable = nil,
        speed = nil,
        light = false,
        swap_data = {bank = "wathgrithr_improved_pro", anim = "idle"},
        waterproofness = TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_WATERPROOFNESS
    })
end

return Prefab("wathgrithr_improved_pro", fn, assets),
       Prefab("wathgrithr_improved_pro2", fn2, assets),
       Prefab("wathgrithr_hat_pro", fn3, assets)

