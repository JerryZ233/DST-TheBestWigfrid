-- 模组里使用变量时可以直接使用GLOBAL的属性变量了，非常方便
GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

IsSaltBoxPushMeatDried = GetModConfigData("SaltBoxPushMeatDried")
IsEatVegetables = GetModConfigData("EatVegetables")
IsMeatAddInspiration = GetModConfigData("MeatAddInspiration")
IsQuickSpell = GetModConfigData("QuickSpell")

IsWathgrithrSpearThrow = GetModConfigData("WathgrithrSpearThrow")
IsWathgrithrSpearUpdate = GetModConfigData("WathgrithrSpearUpdate")
IsLightningSpearFx = GetModConfigData("LightningSpearFx")
IsLightningSpearUpdate = GetModConfigData("LightningSpearUpdate")
IsLightningSpearChargePro = GetModConfigData("LightningSpearChargePro")
_G.IsAoeSkill = GetModConfigData("IsAoeSkill")

IsWathgrithrHatUpdate = GetModConfigData("WathgrithrHatUpdate")
IsWathgrithrImproveFx = GetModConfigData("WathgrithrImproveFx")
IsWathgrithrImproveUpdate = GetModConfigData("WathgrithrImproveUpdate")

IsNoEquipCD = GetModConfigData("NoEquipCD")
IsResetCD = GetModConfigData("ResetCD")
IsRepairShield = GetModConfigData("RepairShield")
IsShieldTaunt = GetModConfigData("ShieldTaunt")

IsRideTime = GetModConfigData("RideTime")
IsInspirationMax = GetModConfigData("InspirationMax")
IsAttackCureBeefalo = GetModConfigData("AttackCureBeefalo")
IsRiderWeapon = GetModConfigData("RiderWeapon")
IsBigBattleContainer = GetModConfigData("BigBattleContainer")
BattleContainerUI = GetModConfigData("BattleContainerUI")

IsBattleSongHealth = GetModConfigData("BattleSongHealth")
IsBattleSongWeapon = GetModConfigData("BattleSongWeapon")
IsBattleSongSanity = GetModConfigData("BattleSongSanity")
IsBattleSongHero = GetModConfigData("BattleSongHero")
IsBattleSongFire = GetModConfigData("BattleSongFire")
IsBattleSongMoon = GetModConfigData("BattleSongMoon")
IsBattleSongShadow = GetModConfigData("BattleSongShadow")
IsBattleSongTaunt = GetModConfigData("BattleSongTaunt")
IsBattleSongPanic = GetModConfigData("BattleSongPanic")
IsBattleSongRelive = GetModConfigData("BattleSongRelive")

IsBattleSongRepair = GetModConfigData("BattleSongRepair")

---------------------------------------------------------------------------------------------------------
modimport("scripts/skin/spear_lightning_pro.lua")

PrefabFiles = {
    "wathgrithr_improved_pro", "spear_lightning_pro", "new_battlesongs",
    "spear_lightning_pro_fx"
}

Assets = {}

------------------------------------------------------------------------------

-- 道具名
if GetModConfigData("Language") == "english" then
    modimport("scripts/lang/en_cn")
else
    modimport("scripts/lang/zh_cn")
end

-------------------------------一些常量--------------------------------

-- 盾牌切换cd
if IsNoEquipCD then TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONEQUIP = 0 end
-- 成功格挡时的重置盾牌cd
if IsResetCD then TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION = 1 end

-- 骑牛恢复灵感的最大值
if IsInspirationMax then TUNING.INSPIRATION_RIDING_GAIN_MAX = 100 end
-- 骑牛时长加成
if IsRideTime then
    TUNING.SKILLS.WATHGRITHR.WATHGRITHR_BEEFALO_BUCK_TIME_MOD = IsRideTime
end

-- 战斗长矛可升级
UPGRADETYPES.SPEAR_WATHGRITHR = "spear_wathgrithr"
-- 奔雷矛移速修正
TUNING.SPEAR_WATHGRITHR_LIGHTNING_NORMAL_SPEED_MULT = 1.15
-- 充能奔雷矛可升级
UPGRADETYPES.SPEAR_LIGHTNING_CHARGE = "spear_lightning_charge"

-- 武神矛属性
TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE1 = 17 * IsLightningSpearChargePro -- 基础攻击
TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE1 = 10 * IsLightningSpearChargePro -- 位面攻击
TUNING.SPEAR_LIGHTNING_PRO_SKILL_DAMAGE_TYPE1 = 68 * IsLightningSpearChargePro -- 位面攻击

TUNING.SPEAR_LIGHTNING_PRO_DAMAGE_TYPE0 = 68 * IsLightningSpearChargePro -- 基础攻击
TUNING.SPEAR_LIGHTNING_PRO_PLANAR_DAMAGE_TYPE0 = 20 * IsLightningSpearChargePro -- 位面攻击
TUNING.SPEAR_LIGHTNING_PRO_SKILL_DAMAGE_TYPE0 = 78 * IsLightningSpearChargePro -- 位面攻击

TUNING.SPEAR_LIGHTNING_PRO_SPEED_MULT = 1.25 -- 移速
TUNING.SPEAR_LIGHTNING_PRO_USES = 250 * IsLightningSpearChargePro -- 耐久度
TUNING.SPEAR_LIGHTNING_PRO_LUNGE_COOLDOWN = 1 -- 冲天刺cd
TUNING.SPEAR_LIGHTNING_PRO_MAX_REPAIRS_PER_LUNGE = 4 -- 技能最高修复倍数
TUNING.SPEAR_LIGHTNING_PRO_LUNGE_REPAIR_AMOUNT = 4 * IsLightningSpearChargePro -- 技能单次修复数值
-- 战斗头盔可升级
UPGRADETYPES.WATHGRITHR_HAT = "wathgrithr_hat"

-- 统帅头盔可升级
UPGRADETYPES.WATHGRITHR_IMPROVED = "wathgrithr_improved"

-- 绝境头盔可升级
UPGRADETYPES.WATHGRITHR_HAT_PRO = "wathgrithr_hat_pro"

-- 武神头盔属性
TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_ABSORPTION = .8 -- 绝境头盔防御系数
TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_WATERPROOFNESS = .6 -- 防水系数
TUNING.ARMOR_WATHGRITHRHAT_HAT_PRO_HEALTH = 1000 * IsWathgrithrImproveUpdate -- 耐久度

TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_ABSORPTION = .85 -- 武神头盔防御系数
TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_WATERPROOFNESS = .9 -- 防水系数
TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_HEALTH = 1000 * IsWathgrithrImproveUpdate -- 耐久度
TUNING.ARMOR_WATHGRITHRHAT_IMPROVE_PRO_PLANAR = 5 * IsWathgrithrImproveUpdate -- 位面防御

-- 乐谱的一些数值
TUNING.BATTLESONG_C_CURE_VALUE = 75 -- 群体治疗量
TUNING.BATTLESONG_C_REPAIR_VALUE = 20 -- 武器修复量
if IsBattleSongWeapon then
    TUNING.BATTLESONG_DURABILITY_MOD = IsBattleSongWeapon -- 武器颤音的数值
end

TUNING.BATTLESONG_C_WETTIME = 3 -- 防火假声潮湿度持续时间
TUNING.BATTLESONG_C_MOISTURE = 5 -- 防火假声潮湿度增长系数（针对龙蝇）
TUNING.BATTLESONG_TAUNT_TIME = 10 -- 嘲讽破防时长
TUNING.BATTLESONG_TAUNT_VALUE = 0.25 -- 嘲讽破防系数

-- 永恒新界联动
UPGRADETYPES.Wathgrithr_NewConstantSpear = "SHADOW_SOUL"
UPGRADETYPES.Wathgrithr_NewConstantHat = "IRON_SOUL"

-------------------------------战斗长矛--------------------------------
--
-- 电羊角可以升级战斗长矛
AddPrefabPostInit("lightninggoathorn", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.SPEAR_WATHGRITHR
end)

local function SpearWathgrithr_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function SpearWathgrithr_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    -- if skin_build == nil or skin_build == "" or skin_id == 0 then
    --     skin_build, skin_id = nil, nil

    -- end
    -- 制作出来的没皮肤，只能自己重新刷一下

    if skin_build then
        skin_build = "spear_wathgrithr_lightning" ..
                         string.sub(skin_build, #inst.prefab + 1)
    end
    local spear = SpawnPrefab("spear_wathgrithr_lightning", skin_build, skin_id)

    spear.components.finiteuses:SetPercent(
        inst.components.finiteuses:GetPercent())

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

-- 长矛可投掷
if IsWathgrithrSpearUpdate then
    Asset("ANIM", "anim/spear_wathgrithr_lightning.zip")
    Asset("ANIM", "anim/swap_spear_lance.zip")

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
            rot = Lerp((drot > 180 and rot0 + 360) or
                           (drot < -180 and rot0 - 360) or rot0, rot,
                       dt * smoothing)
        end
        reticule.Transform:SetRotation(rot)
    end

    local function MakeProjectile(inst)
        inst:AddTag("NOCLICK")

        inst.Physics:SetCollisionGroup(COLLISION.ITEMS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.GROUND)

        if not inst.components.complexprojectile then
            inst:AddComponent("complexprojectile")
        end

        inst.components.complexprojectile.onupdatefn = function(inst, dt)
            dt = dt or FRAMES
            local attacker = inst.components.complexprojectile.attacker
            if attacker == nil then
                print("Warning: attacker = nil")
                return
            end

            local x, y, z = inst.Transform:GetWorldPosition()
            local startpos = inst.components.complexprojectile.startpos
            local targetpos = inst.components.complexprojectile.targetpos
            -- if (inst:GetPosition() - startpos):Length() > (targetpos - startpos):Length() then
            --     inst.components.complexprojectile:Hit()
            --     return
            -- end

            if (inst:GetPosition() - startpos):Length() > 12 then
                inst.components.complexprojectile:Hit()
                return
            end

            local ents = TheSim:FindEntities(x, y, z, 2, {"_combat", "_health"},
                                             {"INLIMBO"})
            for _, v in pairs(ents) do
                if attacker.components.combat:CanTarget(v) and
                    not attacker.components.combat:IsAlly(v) then
                    inst.components.complexprojectile:Hit(v)
                    break
                end
            end
            return true
        end

        inst.components.complexprojectile:SetOnLaunch(
            function(inst, attacker, targetpos)
                inst.components.inventoryitem.canbepickedup = false
                inst.components.complexprojectile.startpos =
                    attacker:GetPosition()
                inst.components.complexprojectile.targetpos = targetpos

                inst.components.floater:SwitchToFloatAnim()
                inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

                inst.Physics:SetMotorVel(35, -1, 0)
            end)

        inst.components.complexprojectile:SetOnHit(
            function(inst, attacker, target)
                if target ~= nil then
                    local pos = target:GetPosition()
                    local tentacle = SpawnPrefab("round_puff_fx_sm")
                    tentacle.Transform:SetPosition(pos.x, pos.y, pos.z)

                    attacker.SoundEmitter:PlaySound(
                        "dontstarve/wilson/hit_animal")
                    local damageMulti =
                        (pos - attacker:GetPosition()):Length() / 6
                    inst.components.finiteuses:Use(2)
                    attacker.components.combat:DoAttack(target, inst, inst,
                                                        "strong", damageMulti,
                                                        999, inst:GetPosition())

                    if inst then
                        attacker.components.inventory:Equip(inst)
                    end
                end
                inst.Physics:SetMotorVel(0, 0, 0)

                inst.components.floater:SwitchToDefaultAnim()
                inst.AnimState:SetOrientation(ANIM_ORIENTATION.BillBoard)

                inst:MakeNonProjectile()
            end)
    end

    local function MakeNonProjectile(inst)
        inst:RemoveTag("NOCLICK")

        inst.Physics:SetCollisionGroup(COLLISION.ITEMS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.OBSTACLES)
        inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)

        -- inst.Transform:SetNoFaced()

        inst.components.inventoryitem.canbepickedup = true
        if inst.components.complexprojectile then
            inst.components.complexprojectile:Cancel()
            inst:RemoveComponent("complexprojectile")
        end
    end

    AddPrefabPostInit("spear_wathgrithr", function(inst)
        if IsWathgrithrSpearThrow and _G.IsAoeSkill ~= false then
            inst:AddTag("throw_line")
            inst:AddTag("spear_wathgrithr")

            inst:AddComponent("aoetargeting")
            inst.components.aoetargeting.reticule.reticuleprefab =
                "reticulelong"
            inst.components.aoetargeting.reticule.pingprefab =
                "reticulelongping"
            inst.components.aoetargeting.reticule.targetfn =
                Lightning_ReticuleTargetFn
            inst.components.aoetargeting.reticule.mousetargetfn =
                Lightning_ReticuleMouseTargetFn
            inst.components.aoetargeting.reticule.updatepositionfn =
                Lightning_ReticuleUpdatePositionFn
            inst.components.aoetargeting.reticule.validcolour = {1, .75, 0, 1}
            inst.components.aoetargeting.reticule.invalidcolour = {.5, 0, 0, 1}
            inst.components.aoetargeting.reticule.ease = true
            inst.components.aoetargeting.reticule.mouseenabled = true
            inst.components.aoetargeting:SetEnabled(false)

            inst:AddTag("rechargeable")
            inst:AddComponent("rechargeable")
            inst._cooldown = 2
            inst.is_lightning_spear = true

            if not TheWorld.ismastersim then return inst end

            inst.MakeProjectile = MakeProjectile
            inst.MakeNonProjectile = MakeNonProjectile

            inst:AddComponent("aoespell")
            inst.components.aoespell:SetSpellFn(
                function(inst, caster, pos)
                    inst:MakeProjectile()
                    caster.components.inventory:DropItem(inst)
                    inst.components.complexprojectile:Launch(pos, caster)
                    inst.components.rechargeable:Discharge(inst._cooldown)
                end)

            inst.components.rechargeable:SetOnDischargedFn(function(inst)
                inst.components.aoetargeting:SetEnabled(false)
            end)
            inst.components.rechargeable:SetOnChargedFn(function(inst)
                local owner = inst.components.inventoryitem:GetGrandOwner()

                if owner ~= nil and owner.components.skilltreeupdater ~= nil and
                    owner.components.skilltreeupdater:IsActivated(
                        "wathgrithr_arsenal_spear_4") then
                    inst.components.aoetargeting:SetEnabled(true)
                end
            end)
        end

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.SPEAR_WATHGRITHR
        inst.components.upgradeable:SetOnUpgradeFn(SpearWathgrithr_OnUpgraded)
        inst.components.upgradeable:SetCanUpgradeFn(
            SpearWathgrithr_CanBeUpgraded)
    end)
end

-------------------------------奔雷矛--------------------------------
-- 黑心能升级奔雷矛

if IsLightningSpearUpdate then
    AddPrefabPostInit("shadowheart", function(inst)
        if not TheWorld.ismastersim then return inst end
        inst:AddComponent("upgrader")
        inst.components.upgrader.upgradetype = UPGRADETYPES.SPEAR_LIGHTNING
    end)
end

-- 普攻修复奔雷矛
local function Lightning_OnLungedHit(inst, doer, target)
    inst._lunge_hit_count = inst._lunge_hit_count or 0

    if inst._lunge_hit_count <
        TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_MAX_REPAIRS_PER_LUNGE and -- 普通奔雷矛的冲刺也能恢复耐久度
        -- inst.components.upgradeable == nil and
        doer.IsValidVictim ~= nil and doer.IsValidVictim(target) then
        inst.components.finiteuses:Repair(
            TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_LUNGE_REPAIR_AMOUNT)
        inst._lunge_hit_count = inst._lunge_hit_count + 1
    end
end

if IsLightningSpearFx then
    AddPrefabPostInit("spear_wathgrithr_lightning", function(inst)
        if not TheWorld.ismastersim then return inst end
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetAllowRiding(true)
        end
        -- 普攻修复奔雷矛
        if inst.components.aoeweapon_lunge then
            inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)
        end
        inst.components.equippable.walkspeedmult =
            TUNING.SPEAR_WATHGRITHR_LIGHTNING_NORMAL_SPEED_MULT
    end)
end

-------------------------------充能奔雷矛--------------------------------
-- 充能火花柜可升级充能奔雷矛
AddPrefabPostInit("security_pulse_cage_full", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.SPEAR_LIGHTNING_CHARGE
end)
-- 附身黑心可升级充能奔雷矛
AddPrefabPostInit("shadowheart_infused", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.SPEAR_LIGHTNING_CHARGE
end)

local function Lightning_Charge_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function Lightning_Charge_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end

    local spear = SpawnPrefab("spear_lightning_pro")

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

if IsLightningSpearChargePro then
    AddPrefabPostInit("spear_wathgrithr_lightning_charged", function(inst)
        if not TheWorld.ismastersim then return inst end
        if inst.components.aoetargeting then
            inst.components.aoetargeting:SetAllowRiding(true)
        end

        if inst.components.aoeweapon_lunge then
            inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)
        end
        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype =
            UPGRADETYPES.SPEAR_LIGHTNING_CHARGE
        inst.components.upgradeable:SetOnUpgradeFn(Lightning_Charge_OnUpgraded)
        inst.components.upgradeable:SetCanUpgradeFn(
            Lightning_Charge_CanBeUpgraded)
        inst.components.equippable.restrictedtag =
            UPGRADETYPES.SPEAR_LIGHTNING_CHARGE .. "_upgradeuser"
    end)

    -- 骑牛使用冲天刺
    -- 快捷施法
    AddComponentPostInit("playercontroller", function(self)
        local oldonleftclick = self.OnLeftClick
        function self:OnLeftClick(down)
            if IsQuickSpell then
                local weapon = self.inst.replica.inventory:GetEquippedItem(
                                   EQUIPSLOTS.HANDS)
                if weapon and (string.find(weapon.prefab, 'spear_wathgrithr') or
                    string.find(weapon.prefab, 'spear_lightning') or
                    weapon.prefab == "wathgrithr_shield") then
                    if not self:UsingMouse() then
                        return
                    elseif not down then
                        self:OnLeftUp()
                        return
                    end

                    if self:IsAOETargeting() then
                        self:CancelAOETargeting()
                    else
                        oldonleftclick(self, down)
                    end
                else
                    oldonleftclick(self, down)
                end
            else
                oldonleftclick(self, down)
            end
        end

        local oldonrightclick = self.OnRightClick
        function self:OnRightClick(down)
            if IsQuickSpell then
                if self.inst.prefab == "wathgrithr" then
                    if not self:UsingMouse() then
                        return
                    elseif not down then
                        if self:IsEnabled() and self:IsAOETargeting() then
                            self:RemoteStopControl(CONTROL_SECONDARY)
                            oldonleftclick(self, true)
                        end
                        return
                    end

                    self:ClearActionHold()

                    self.startdragtime = nil
                    if self.placer_recipe ~= nil then
                        self:CancelPlacement()
                        return
                    elseif self:IsAOETargeting() then
                        self:CancelAOETargeting()
                        return
                    elseif not self:IsEnabled() or
                        TheInput:GetHUDEntityUnderMouse() ~= nil then
                        return
                    end

                    self.actionholdtime = GetTime()
                    local act = self:GetRightMouseAction()
                    if act == nil then
                        local weapon =
                            self.inst.replica.inventory:GetEquippedItem(
                                EQUIPSLOTS.HANDS)
                        if weapon and
                            (string.find(weapon.prefab, 'spear_wathgrithr') or
                                string.find(weapon.prefab, 'spear_lightning') or
                                weapon.prefab == "wathgrithr_shield") then
                            local closed = false
                            if self.inst.HUD ~= nil then
                                if self.inst.HUD:IsCraftingOpen() then
                                    self.inst.HUD:CloseCrafting()
                                    closed = true
                                end
                                if self.inst.HUD:IsSpellWheelOpen() then
                                    self.inst.HUD:CloseSpellWheel()
                                    closed = true
                                end
                            end
                            if not closed then
                                self.inst.replica.inventory:ReturnActiveItem()
                                self:TryAOETargeting()
                            end
                        else
                            oldonrightclick(self, down)
                        end
                    else
                        oldonrightclick(self, down)
                    end
                else
                    oldonrightclick(self, down)
                end
            else
                oldonrightclick(self, down)
            end
        end
    end)
end

-----------------------------------武神长矛，每次普攻打2下-------------------------------------------
ACTIONS.ATTACK.fn = function(act)
    if act.doer.sg ~= nil then
        if act.doer.sg:HasStateTag("propattack") then
            -- don't do a real attack with prop weapons
            return true
        elseif act.doer.sg:HasStateTag("thrusting") then
            local weapon = act.doer.components.combat:GetWeapon()
            return weapon ~= nil and weapon.components.multithruster ~= nil and
                       weapon.components.multithruster:StartThrusting(act.doer)
        elseif act.doer.sg:HasStateTag("helmsplitting") then
            local weapon = act.doer.components.combat:GetWeapon()
            return weapon ~= nil and weapon.components.helmsplitter ~= nil and
                       weapon.components.helmsplitter:StartHelmSplitting(
                           act.doer)
        end
    end

    local weapon = act.doer.components.combat:GetWeapon()
    if act.doer.prefab == "wathgrithr" and weapon and
        string.find(weapon.prefab, 'spear_lightning_pro') then

        if weapon:HasTag("jab") then

        else
            for i = 1, 2, 1 do
                act.doer:DoTaskInTime(i * 0.25, function()
                    act.doer.components.combat:DoAttack(act.target, weapon,
                                                        weapon, "strong", 1,
                                                        999,
                                                        weapon:GetPosition())
                    if weapon:IsValid() then
                        weapon.components.finiteuses:Repair(1)
                    end
                end)
            end
        end

        act.doer.components.combat:DoAttack(act.target, weapon, weapon,
                                            "strong", 1, 999,
                                            weapon:GetPosition())
        return true
    else
        act.doer.components.combat:DoAttack(act.target)
        return true
    end
end

-------------------------------战斗头盔--------------------------------
-- 大理石可升级战斗头盔
AddPrefabPostInit("marble", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.WATHGRITHR_HAT
end)
local function WathgrithrHat_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function WathgrithrHat_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end

    if skin_build then
        skin_build = "wathgrithr_improvedhat" ..
                         string.sub(skin_build, #inst.prefab + 1)
    end

    local hat = SpawnPrefab("wathgrithr_improvedhat", skin_build, skin_id)
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

if IsWathgrithrHatUpdate then
    AddPrefabPostInit("wathgrithrhat", function(inst)
        if not TheWorld.ismastersim then return inst end
        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.WATHGRITHR_HAT
        inst.components.upgradeable:SetOnUpgradeFn(WathgrithrHat_OnUpgraded)
        inst.components.upgradeable:SetCanUpgradeFn(WathgrithrHat_CanBeUpgraded)
        -- inst.components.equippable.restrictedtag = UPGRADETYPES.WATHGRITHR_HAT .. "_upgradeuser"
    end)
end

-------------------------------统帅头盔--------------------------------
-- 启迪碎片可升级统帅头盔
AddPrefabPostInit("dreadstone", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.WATHGRITHR_IMPROVED
end)

local function Improved_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function Improved_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end

    local hat = SpawnPrefab("wathgrithr_hat_pro")
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

if IsWathgrithrImproveUpdate then
    AddPrefabPostInit("wathgrithr_improvedhat", function(inst)
        if not TheWorld.ismastersim then return inst end
        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype =
            UPGRADETYPES.WATHGRITHR_IMPROVED
        inst.components.upgradeable:SetOnUpgradeFn(Improved_OnUpgraded)
        inst.components.upgradeable:SetCanUpgradeFn(Improved_CanBeUpgraded)
    end)
end

-------------------------------绝境头盔--------------------------------
-- 启迪碎片可升级绝境头盔
AddPrefabPostInit("alterguardianhatshard", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype = UPGRADETYPES.WATHGRITHR_HAT_PRO
end)

local function Hat_Pro_CanBeUpgraded(inst, item)
    return not inst.components.equippable:IsEquipped()
end

local function Hat_Pro_OnUpgraded(inst, upgrader, item)
    local skin_build, skin_id = inst:GetSkinBuild(), inst.skin_id
    if skin_build == nil or skin_build == "" or skin_id == 0 then
        skin_build, skin_id = nil, nil
    end

    local hat = SpawnPrefab("wathgrithr_improved_pro")
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

AddPrefabPostInit("wathgrithr_hat_pro", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.WATHGRITHR_HAT_PRO
    inst.components.upgradeable:SetOnUpgradeFn(Hat_Pro_OnUpgraded)
    inst.components.upgradeable:SetCanUpgradeFn(Hat_Pro_CanBeUpgraded)
end)

if IsWathgrithrImproveFx then
    AddComponentPostInit("battleborn", function(self)
        local function HurtBorn(item, target)
            -- 武神头成额外伤害
            if item.prefab == "wathgrithr_improved_pro" and
                item.components.armor ~= nil then
                local HurtHp = target.components.health.maxhealth -
                                   target.components.health.currenthealth
                local delta = HurtHp * 0.005 * IsWathgrithrImproveUpdate
                target.components.health:DoDelta(-delta, nil, nil, nil, nil,
                                                 true)
            elseif item.prefab == "wathgrithr_improved_pro2" and
                item.components.armor ~= nil then
                local HurtHp = target.components.health.maxhealth -
                                   target.components.health.currenthealth
                local delta = HurtHp * 0.01 * IsWathgrithrImproveUpdate
                target.components.health:DoDelta(-delta, nil, nil, nil, nil,
                                                 true)
            end
        end

        self.inst:ListenForEvent("onattackother", function(inst, data)
            local victim = data.target

            if not self.inst.components.health:IsDead() and
                (self.validvictimfn == nil or self.validvictimfn(victim)) then
                local total_health =
                    victim.components.health:GetMaxWithPenalty()
                local damage = (data.weapon ~= nil and
                                   data.weapon.components.weapon:GetDamage(
                                       self.inst, victim)) or
                                   self.inst.components.combat.defaultdamage
                if damage > 0 or self.allow_zero then
                    local percent = (damage <= 0 and 0) or
                                        (total_health <= 0 and math.huge) or
                                        damage / total_health

                    -- math and clamp does account for 0 and infinite cases
                    local delta = math.clamp(
                                      victim.components.combat.defaultdamage *
                                          self.battleborn_bonus * percent,
                                      self.clamp_min, self.clamp_max)

                    -- decay stored battleborn
                    if self.battleborn > 0 then
                        local dt = GetTime() - self.battleborn_time -
                                       self.battleborn_store_time
                        if dt >= self.battleborn_decay_time then
                            self.battleborn = 0
                        elseif dt > 0 then
                            local k = dt / self.battleborn_decay_time
                            self.battleborn = Lerp(self.battleborn, 0, k * k)
                        end
                    end

                    -- store new battleborn
                    self.battleborn = self.battleborn + delta
                    self.battleborn_time = GetTime()

                    -- consume battleborn if enough has been stored
                    -- 不满血也能恢复统帅头盔耐久度
                    if self.battleborn > self.battleborn_trigger_threshold then
                        if self.health_enabled then
                            self.inst.components.health:DoDelta(self.battleborn,
                                                                false,
                                                                "battleborn")
                        end

                        if self.sanity_enabled then
                            self.inst.components.sanity:DoDelta(self.battleborn)
                        end

                        if self.ontriggerfn ~= nil then
                            self.ontriggerfn(self.inst, self.battleborn)
                        end
                        self.inst.components.inventory:ForEachEquipment(
                            self.RepairEquipment, self.battleborn)
                        self.battleborn = 0
                    end

                    -- 额外伤害
                    if not inst._broken then
                        self.inst.components.inventory:ForEachEquipment(
                            HurtBorn, victim)
                    end
                end
            end
        end)
    end)
end

-------------------------------盾牌--------------------------------
-- 格挡反击可以修复盾牌
local function DamageFn(inst)
    if inst._lastparrytime ~= nil and (inst._lastparrytime +
        TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_DURATION) >=
        GetTime() then
        if inst._bonusdamage ~= nil and inst._bonusdamage > 0 then
            inst.components.armor:Repair(TUNING.WATHGRITHR_SHIELD_USEDAMAGE * 2)
        end
        return TUNING.WATHGRITHR_SHIELD_DAMAGE + (inst._bonusdamage or 0)
    end

    return TUNING.WATHGRITHR_SHIELD_DAMAGE
end

if IsRepairShield then
    AddPrefabPostInit("wathgrithr_shield", function(inst)
        if not TheWorld.ismastersim then return inst end
        if inst.components.weapon then
            inst.components.weapon:SetDamage(DamageFn)
        end
    end)
end

-------------------------------薇格弗德--------------------------------
local function keeptaunt(target, inst)
    target.components.combat:SetTarget(inst)
    if target.taunttime > 0 then
        target.taunttime = target.taunttime - 1
    else
        target.tauntfn:Cancel()
        target.tauntfn = nil
    end
end

AddPrefabPostInit("wathgrithr", function(inst)
    local function OnCustomStatsModFn(inst, health, hunger, sanity, food, feeder)
        if inst.components.hunger then
            inst.components.hunger.lasthunger = inst.components.hunger.current
        end
        -- 可以吃素食，但是收益减半
        if food.components.edible.foodtype ~= FOODTYPE.MEAT and
            food.components.edible.foodtype ~= FOODTYPE.GOODIES and
            IsEatVegetables and IsEatVegetables ~= 0 then
            return health * IsEatVegetables, hunger * IsEatVegetables,
                   sanity * IsEatVegetables
        end
        return health, hunger, sanity
    end

    local function OnEat(inst, food)
        if food ~= nil and food.components.edible ~= nil and
            food.components.edible.foodtype == FOODTYPE.MEAT and
            IsMeatAddInspiration then
            -- 肉食溢出部分变为灵感
            local subtract = inst.components.hunger.max -
                                 inst.components.hunger.lasthunger
            local delta = food.components.edible.hungervalue - subtract

            if delta > 0 then
                inst.components.singinginspiration:DoDelta(delta *
                                                               IsMeatAddInspiration)
                inst.components.singinginspiration.last_attack_time = GetTime()
            end
        end
    end

    if not TheWorld.ismastersim then return inst end
    -- 可以吃素食，但是收益衰减
    if inst.components.eater ~= nil then
        inst.components.eater.custom_stats_mod_fn = OnCustomStatsModFn
        if IsEatVegetables ~= 0 then
            inst.components.eater:SetDiet({FOODGROUP.OMNI})
        end

        -- 吃肉回灵感
        if IsMeatAddInspiration then
            local oldoneatfn = inst.components.eater.oneatfn
            inst.components.eater:SetOnEatFn(
                function(inst, food)
                    if oldoneatfn then oldoneatfn(inst, food) end
                    OnEat(inst, food)
                end)
        end
    end

    inst:AddTag(UPGRADETYPES.SPEAR_LIGHTNING .. "_upgradeuser") -- 升级战斗长矛
    inst:AddTag(UPGRADETYPES.SPEAR_WATHGRITHR .. "_upgradeuser") -- 升级战斗长矛
    inst:AddTag(UPGRADETYPES.SPEAR_LIGHTNING_CHARGE .. "_upgradeuser") -- 升级充能奔雷矛
    inst:AddTag(UPGRADETYPES.WATHGRITHR_HAT .. "_upgradeuser") -- 升级战斗头盔
    inst:AddTag(UPGRADETYPES.WATHGRITHR_IMPROVED .. "_upgradeuser") -- 升级统帅头盔
    inst:AddTag(UPGRADETYPES.WATHGRITHR_HAT_PRO .. "_upgradeuser") -- 升级绝境头盔

    inst:AddTag(UPGRADETYPES.Wathgrithr_NewConstantHat .. "_upgradeuser") -- 真武神头
    inst:AddTag(UPGRADETYPES.Wathgrithr_NewConstantSpear .. "_upgradeuser") -- 真武神矛

    if IsAttackCureBeefalo then
        -------------------------攻击为牛回血------------------------
        inst:ListenForEvent("onattackother", function(inst, data)
            if inst and inst.sg then
                if data.target and inst.prefab == "wathgrithr" and
                    inst.components.rider and inst.components.rider:IsRiding() and
                    inst.components.rider.mount and
                    inst.components.rider.mount.components.health and
                    not inst.components.rider.mount.components.health:IsDead() then
                    if data.target.components.health and
                        data.target.components.combat and data.target.prefab ~=
                        "chester" and data.target.prefab ~= "hutch" and
                        data.target.prefab ~= "lureplant" and
                        not data.target:HasTag("wall") then
                        inst.components.rider.mount.components.health:DoDelta(4)
                    end
                end
            end
        end)
    end
    if IsShieldTaunt then
        -- 盾牌攻击时嘲讽3s
        inst:ListenForEvent("onattackother", function(inst, data)
            local weapon = inst.components.combat:GetWeapon()
            if weapon and weapon:HasTag("battleshield") then
                if data.target.components.combat then
                    data.target.taunttime = 3 * 24
                    if not data.target.tauntfn then
                        data.target.tauntfn =
                            data.target:DoPeriodicTask(FRAMES, function(target)
                                keeptaunt(target, inst)
                            end)
                    end
                end
            end
        end)
    end

    inst:ListenForEvent("inspirationsongchanged", function(inst, data)
        local weapon = inst.components.combat:GetWeapon()
        if weapon then weapon:PushEvent("inspirationsongchanged", data) end
    end)

    -- -- 自动接盾牌
    -- if inst.components.catcher then
    --     inst.components.catcher.OnUpdate = function ()
    --         inst.components.catcher.canact = true
    --     end
    -- end

end)

-- local function OnSetOwner(inst)
--     inst:DoTaskInTime(0, function()
--         inst.components.talker:Say("setowner")
--         if inst.components.playeractionpicker ~= nil then
--             local _pointspecialactionsfn = inst.components.playeractionpicker.pointspecialactionsfn
--             inst.components.playeractionpicker.pointspecialactionsfn =
--                 function(inst, pos, useitem, right)
--                     return { ACTIONS.CASTAOE }
--                     -- return _pointspecialactionsfn ~= nil and _pointspecialactionsfn(inst, pos, useitem, right) or {}
--                 end
--         end
--     end)
-- end

-- AddPlayerPostInit(function(inst)
--     inst:ListenForEvent("setowner", OnSetOwner)
-- end)

-------------------------------训牛--------------------------------
-- 骑牛使用武器
if IsRiderWeapon then
    AddStategraphPostInit('wilson', function(self)
        local fun_swap = self.states['attack'].onenter
        self.states['attack'].onenter = function(inst)
            local equip = inst.components.inventory:GetEquippedItem(
                              _G.EQUIPSLOTS.HANDS)
            if inst.prefab == "wathgrithr" and equip and equip:HasTag("weapon") and
                inst.components.rider and inst.components.rider:IsRiding() then
                equip:AddTag('rangedweapon')
                fun_swap(inst)
            else
                fun_swap(inst)
            end
        end
    end)
end

-------------------------------唱歌--------------------------------
-- 战歌筒子调整
-- 新的ui
-- 容量12
-- 移动时不关闭
local containers = require("containers")
if BattleContainerUI and BattleContainerUI == 2 then
    containers.params.battlesong_container = {
        widget = {
            slotpos = {},
            slotbg = {},
            animbank = "",
            animbuild = "",
            pos = Vector3(0, 0, 0)
        },
        type = "BattleSongContainer"
    }

    local battlesong_container_bg = {
        image = "cookbook_known_selected.tex",
        atlas = "images/quagmire_recipebook.xml"
    }

    local space = {x = -200, y = 200}
    local orgin = {x = -300, y = 300}
    local offset = {x = 0, y = 50}
    local line = 3

    for row = 0, line do
        for col = 0, line do
            if row == 0 or row == line or col == 0 or col == line then
                table.insert(containers.params.battlesong_container.widget
                                 .slotpos,
                             Vector3(orgin.x - space.x * col + offset.x,
                                     orgin.y - space.y * row + offset.y, 0))

                table.insert(containers.params.battlesong_container.widget
                                 .slotbg, battlesong_container_bg)
            end
        end
    end
elseif BattleContainerUI and BattleContainerUI == 1 then
    containers.params.battlesong_container = {
        widget = {
            slotpos = {},
            animbank = "ui_piggyback_2x6",
            animbuild = "ui_piggyback_2x6",
            --        pos = Vector3(-5, -50, 0),
            pos = Vector3(-55, 0, 0)
        },
        type = "BattleSongContainer"
    }

    for y = 0, 5 do
        table.insert(containers.params.battlesong_container.widget.slotpos,
                     Vector3(-162, -75 * y + 170, 0))
        table.insert(containers.params.battlesong_container.widget.slotpos,
                     Vector3(-162 + 75, -75 * y + 170, 0))
    end
end
function containers.params.battlesong_container.itemtestfn(container, item, slot)
    -- Battlesongs.
    return item:HasTag("battlesong")
end

if IsBigBattleContainer then
    AddPrefabPostInit('battlesong_container', function(inst)
        if not TheWorld.ismastersim then return inst end
        inst:RemoveTag("portablestorage")
        inst.components.container.droponopen = false
    end)
end

if IsSaltBoxPushMeatDried then
    -- 盐盒可以放肉干
    function containers.params.saltbox.itemtestfn(container, item, slot)
        return ((item:HasTag("fresh") or item:HasTag("stale") or
                   item:HasTag("spoiled")) and item:HasTag("cookable") and
                   not item:HasTag("deployable") and
                   not item:HasTag("smallcreature") and item.replica.health ==
                   nil) or item:HasTag("saltbox_valid") or
                   item:HasTag("lureplant_bait")
    end
end

-- 用的其他mod里的图片资源，所以名字不要改（暂时没有新乐谱）
-- 新乐谱
local new_songs = {

    battlesong_c_repair = {
        ["NAME"] = "狂想曲",
        ["RECIPE_DESC"] = "修复手中的武器",
        ["DESCRIBE"] = "",
        ["INGREDIENT"] = "glommerwings",
        ["INGREDIENT_NUM"] = 1,
        ["ANNOUNCE"] = "待到秋来九月八，我花开后百花杀",
        ["ISOPEN"] = IsBattleSongRepair

    }
}

local base_ingredient = {
    Ingredient("papyrus", 1), Ingredient("featherpencil", 1)
}
local var
local ing
for k, v in pairs(new_songs) do
    var = string.upper(k)
    GLOBAL.STRINGS.NAMES[var] = v["NAME"]
    GLOBAL.STRINGS.RECIPE_DESC[var] = v["RECIPE_DESC"]
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE[var] = v["DESCRIBE"]
    GLOBAL.STRINGS.CHARACTERS.WATHGRITHR["ANNOUNCE_" .. var .. "_BUFF"] =
        v["ANNOUNCE"]
    var = GetModConfigData("RECIPE_" .. var)
    ing = {}
    for _, v2 in pairs(base_ingredient) do table.insert(ing, v2) end
    table.insert(ing, Ingredient(v['INGREDIENT'], v['INGREDIENT_NUM']))

    if v["ISOPEN"] then
        AddRecipe(k, ing, CUSTOM_RECIPETABS.BATTLESONGS, TECH.NONE, nil, nil,
                  nil, nil, "battlesinger",
                  "images/inventoryimages/new_battlesongs.xml", k .. ".tex")
    end
end

-- 暗影曲不被影怪打
if IsBattleSongShadow then
    AddPrefabPostInit("battlesong_shadowaligned", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end
            target:AddTag("shadowdominance")
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            if target:HasTag("shadowdominance") then
                target:RemoveTag("shadowdominance")
            end
        end
    end)
end
-- 摇篮曲不被虚影打
-- 虚影
if IsBattleSongMoon then
    AddPrefabPostInit("gestalt", function(inst)
        if not TheWorld.ismastersim then return inst end

        local oldRetargetgn = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(1, function(inst)
            if inst.tracking_target and
                inst.tracking_target:HasTag("gestaltprotection") then
                return nil
            else
                return oldRetargetgn(inst)
            end
        end)
    end)
    AddPrefabPostInit("battlesong_lunaraligned", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end
            target:AddTag("gestaltprotection")
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            target:RemoveTag("gestaltprotection")
        end
    end)
end

-- 武器化颤音，修改数值，并改变武神矛和盾牌的攻击方式
if IsBattleSongWeapon then
    AddPrefabPostInit("battlesong_durability", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end

            -- 激活武器颤音
            target:AddTag("battlesong_durability_buff")
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            -- 激活武器颤音
            target:RemoveTag("battlesong_durability_buff")

        end
    end)
end

-- 心碎歌谣霸体
if IsBattleSongHealth then
    AddPrefabPostInit("battlesong_healthgain", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end
            target:AddTag("battlesong_nointerrupt")
            -- if target.components.grogginess then
            --     target.knockouttestfn =  target.components.grogginess.knockouttestfn
            --     target.components.grogginess:SetKnockOutTest(function()
            --         return false
            --     end)
            -- end
        end
        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            target:RemoveTag("battlesong_nointerrupt")
            -- if not target:HasTag("insomniac") and target.components.grogginess then
            --     if target.knockouttestfn then
            --         target.components.grogginess:SetKnockOutTest(target.knockouttestfn)
            --     end
            -- end
        end
    end)
end

-- 醍醐灌顶召唤天光
if IsBattleSongSanity then
    AddPrefabPostInit("battlesong_sanitygain", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end
            if target._light then target._light:Remove() end
            if not target:HasTag("player") then return end
            target._light = SpawnPrefab("booklight", nil, 0)
            target._light.owner = target

            -- 让灯光跟着自己
            target._light:DoPeriodicTask(FRAMES, function(_light)
                if not target._light then
                    _light:Remove()
                    return
                end
                if target then
                    local x, y, z = target.Transform:GetWorldPosition()
                    if x and y and z then
                        target._light.Transform:SetPosition(x, y, z)
                    end
                end
            end)
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            target._light = nil
        end
    end)
end

-- 英勇赞歌免疫风暴
if IsBattleSongHero then
    AddComponentPostInit("stormwatcher", function(self)
        local oldUpdateStormLevel = self.UpdateStormLevel

        function self:UpdateStormLevel()
            if self.inst:HasTag("storm_ignore") then
                self:CheckStorms()
                self.stormlevel = 0.2
                if self.currentstorm == STORM_TYPES.SANDSTORM then
                    self.inst.components.sandstormwatcher:UpdateSandstormLevel()
                elseif self.currentstorm == STORM_TYPES.MOONSTORM then
                    self.inst.components.moonstormwatcher:UpdateMoonstormLevel()
                end
                self.laststorm = self.currentstorm
            else
                oldUpdateStormLevel(self)
            end
        end
    end)

    AddPrefabPostInit("battlesong_sanityaura", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end
            target:AddTag("storm_ignore")
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            target:RemoveTag("storm_ignore")
        end
    end)
end

-- 防火假声添加潮湿度
if IsBattleSongFire then
    AddPrefabPostInit("battlesong_fireresistance", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_onapply = inst.songdata.ONAPPLY
        inst.songdata.ONAPPLY = function(singer, target)
            if old_onapply then old_onapply(singer, target) end

            singer:AddTag("wathgrithr_wet")
            inst:ListenForEvent("onattackother", function(attacker, data)
                local victim = data.target
                if victim and singer:HasTag("wathgrithr_wet") then
                    if victim.components.moisture then
                        victim.components.moisture:DoDelta(
                            TUNING.BATTLESONG_C_MOISTURE)
                    else
                        victim._wettime = TUNING.BATTLESONG_C_WETTIME

                        if not victim:HasTag("wet") then
                            victim:AddTag("wet")
                            victim._wettimefn =
                                victim:DoPeriodicTask(1, function(inst)
                                    victim._wettime = victim._wettime - 1
                                    if victim._wettime < 1 then
                                        victim._wettimefn:Cancel()
                                        victim._wettimefn = nil
                                        victim:RemoveTag("wet")
                                    end
                                end)
                        end
                    end
                end
            end, target)
        end

        local old_ondetach = inst.songdata.ONDETACH
        inst.songdata.ONDETACH = function(singer, target)
            if old_ondetach then old_ondetach(singer, target) end
            singer:RemoveTag("wathgrithr_wet")
        end
    end)
end

-- 粗鲁插曲 可对boss生效，并破防
if IsBattleSongTaunt then
    AddPrefabPostInit("battlesong_instant_taunt", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_instant = inst.songdata.ONINSTANT
        inst.songdata.ONINSTANT = function(singer, target)
            if old_instant then old_instant(singer, target) end

            -- 嘲讽时长变为3s
            target.taunttime = 3 * 24
            if not target.tauntfn then
                target.tauntfn = target:DoPeriodicTask(FRAMES, function(target)
                    keeptaunt(target, inst)
                end)
            end

            target._c_taunttime = TUNING.BATTLESONG_TAUNT_TIME

            if target.components.locomotor and
                not target:HasTag("wathgrithr_taunt") then
                target:AddTag("wathgrithr_taunt")

                target.components.health.externalabsorbmodifiers:SetModifier(
                    target, -TUNING.BATTLESONG_TAUNT_VALUE, "wathgrithr_taunt")
                target._c_tauntfn = target:DoPeriodicTask(1, function(target)
                    target._c_taunttime = target._c_taunttime - 1

                    if target._c_taunttime < 1 then
                        target.components.health.externalabsorbmodifiers:RemoveModifier(
                            target, "wathgrithr_taunt")
                        target:RemoveTag("wathgrithr_taunt")
                        target._c_tauntfn:Cancel()
                        target._c_tauntfn = nil
                    end
                end)
            end
        end

        inst.songdata.CUSTOMTARGETFN = function(singer)
            local INSTANT_TARGET_MUST_HAVE_TAGS = {"_combat", "_health"}
            local INSTANT_TARGET_CANTHAVE_TAGS = {
                "INLIMBO", "structure", "butterfly", "wall", "balloon",
                "groundspike", "smashable", "companion"
            }
            local function HasFriendlyLeader(target, singer, PVP_enabled)
                local target_leader = (target.components.follower ~= nil) and
                                          target.components.follower.leader or
                                          nil

                if target_leader and target_leader.components.inventoryitem then
                    target_leader =
                        target_leader.components.inventoryitem:GetGrandOwner()
                    -- Don't attack followers if their follow object has no owner, unless its pvp, then there are no rules!
                    if target_leader == nil then
                        return not PVP_enabled
                    end
                end

                return (target_leader ~= nil and
                           (target_leader == singer or
                               (not PVP_enabled and
                                   target_leader:HasTag("player")))) or
                           (not PVP_enabled and target.components.domesticatable and
                               target.components.domesticatable:IsDomesticated()) or
                           (not PVP_enabled and target.components.saltlicker and
                               target.components.saltlicker.salted)
            end

            local PVP_enabled = TheNet:GetPVPEnabled()
            local x, y, z = singer.Transform:GetWorldPosition()
            local entities_near_me = TheSim:FindEntities(x, y, z,
                                                         TUNING.BATTLESONG_ATTACH_RADIUS,
                                                         INSTANT_TARGET_MUST_HAVE_TAGS,
                                                         INSTANT_TARGET_CANTHAVE_TAGS)

            local targets = {}

            for _, ent in ipairs(entities_near_me) do
                if singer.components.combat:CanTarget(ent) and
                    not HasFriendlyLeader(ent, singer, PVP_enabled) and
                    (not ent:HasTag("prey") or
                        (ent:HasTag("prey") and ent:HasTag("hostile"))) then
                    table.insert(targets, ent)
                end
            end
            return targets
        end
    end)
end

-- 惊心独白 减速
if IsBattleSongPanic then
    AddPrefabPostInit("battlesong_instant_panic", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_instant = inst.songdata.ONINSTANT
        inst.songdata.ONINSTANT = function(singer, target)
            if old_instant then old_instant(singer, target) end
            target._c_panictime = TUNING.BATTLESONG_PANIC_TIME

            if target.components.locomotor and
                not target:HasTag("wathgrithr_panic") then
                target:AddTag("wathgrithr_panic")
                target.components.locomotor:SetExternalSpeedMultiplier(inst,
                                                                       "wathgrithr_panic",
                                                                       0.3)

                target._c_panicfn = target:DoPeriodicTask(1, function(target)
                    target._c_panictime = target._c_panictime - 1
                    if target._c_panictime < 1 then
                        target.components.locomotor:RemoveExternalSpeedMultiplier(
                            inst, "wathgrithr_panic")
                        target:RemoveTag("wathgrithr_panic")
                        target._c_panicfn:Cancel()
                        target._c_panicfn = nil
                    end
                end)
            end
        end
    end)
end

-- 战士重奏 复活或治疗
if IsBattleSongRelive then
    -- 寻找附近的队友
    AddPrefabPostInit("battlesong_instant_revive", function(inst)
        if not TheWorld.ismastersim then return inst end
        local old_instant = inst.songdata.ONINSTANT
        inst.songdata.ONINSTANT = function(singer, target)
            if old_instant then old_instant(singer, target) end
            if target.components.health and not target:HasTag("playerghost") then
                target.components.health:DoDelta(TUNING.BATTLESONG_C_CURE_VALUE)

                target:DoTaskInTime(math.random() * 0.25, function()
                    local x, y, z = target.Transform:GetWorldPosition()
                    local fx = SpawnPrefab("battlesong_instant_taunt_fx")
                    if fx then
                        fx.Transform:SetPosition(x, y, z)
                    end

                    return fx
                end)
            end
        end
        -- local old_customtargetfn = inst.songdata.CUSTOMTARGETFN
        inst.songdata.CUSTOMTARGETFN = function(singer, target)
            -- if old_instant then
            --     old_instant(singer, target)
            -- end

            if TheNet:GetPVPEnabled() then return {} end
            local players = {}

            local x, y, z = singer.Transform:GetWorldPosition()
            local radius = singer.components.singinginspiration.attach_radius

            for _, v in pairs(TheSim:FindEntities(x, y, z, radius)) do
                -- 驯化的牛牛
                -- 所有玩家
                -- 自己的随从
                if v.components.domesticatable and
                    not v.components.domesticatable.near_death and
                    v.components.domesticatable.domestication >= 0.01 or
                    v:HasTag("player") or
                    (v.components.follower and v.components.follower.leader and
                        v.components.follower.leader == singer) then
                    table.insert(players, v)
                end
            end
            return players or {}
        end
    end)
end

AddStategraphPostInit('wilson', function(self)
    -- 战歌可边骑边唱（未完成）
    -- 目前只是可以中断唱歌，并减少了歌曲生效时间
    self.states['sing'].tags = {"busy", "nointerrupt", "keep_pocket_rummage"}
    self.states['sing'].timeline = {
        TimeEvent(3 * FRAMES, function(inst)
            local buffaction = inst:GetBufferedAction()
            local songdata = nil
            if buffaction and buffaction.invobject then
                songdata = buffaction.invobject.songdata
            end
            if songdata then
                inst.SoundEmitter:PlaySound(songdata.SOUND or
                                                ("dontstarve_DLC001/characters/wathgrithr/" ..
                                                    (songdata.INSTANT and
                                                        "quote" or "sing")))
            end
            -- if inst.sg.statemem.riding then
            --     inst.sg:RemoveStateTag("busy")
            -- end
            inst:PerformBufferedAction()
        end), TimeEvent(34 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:RemoveStateTag("nointerrupt")
        end), TimeEvent(42 * FRAMES, function(inst)
            local item = inst.sg.mem.pocket_rummage_item
            if item then
                if item.components.container and
                    item.components.container:IsOpenedBy(inst) and
                    item.components.inventoryitem and
                    item.components.inventoryitem:GetGrandOwner() == inst then
                    inst.sg.statemem.keep_pocket_rummage_mem_onexit = true
                    inst.sg:GoToState("start_pocket_rummage", item)
                    return true
                end
                inst.sg.mem.pocket_rummage_item = nil
            end
            return false
        end)
    }

    -- 一些霸体
    local oldattackedfn = self.events["attacked"].fn
    self.events["attacked"].fn = function(inst, data)
        if inst:HasTag("light_pro_nointerrupt") or
            inst:HasTag("battlesong_nointerrupt") or inst:HasTag("playerghost") then
            return
        elseif oldattackedfn then
            return oldattackedfn(inst, data)
        end
    end

    -- 骑牛使用可以使用长矛技能
    local function OnRemoveCleanupTargetFX(inst)
        if inst.sg.statemem.targetfx.KillFX ~= nil then
            inst.sg.statemem.targetfx:RemoveEventCallback("onremove",
                                                          OnRemoveCleanupTargetFX,
                                                          inst)
            inst.sg.statemem.targetfx:KillFX()
        else
            inst.sg.statemem.targetfx:Remove()
        end
    end

    self.states['combat_superjump_start'].onenter = function(inst)
        inst.components.locomotor:Stop()

        if inst.components.rider and inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("sing_pre")
        else
            inst.AnimState:PlayAnimation("superjump_pre")
        end

        local weapon = inst.components.inventory:GetEquippedItem(
                           EQUIPSLOTS.HANDS)
        if weapon ~= nil and weapon.components.aoetargeting ~= nil then
            local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst.sg.statemem.targetfx =
                    weapon.components.aoetargeting:SpawnTargetFXAt(
                        buffaction:GetDynamicActionPoint())
                if inst.sg.statemem.targetfx ~= nil then
                    inst.sg.statemem.targetfx:ListenForEvent("onremove",
                                                             OnRemoveCleanupTargetFX,
                                                             inst)
                end
            end
        end
    end

    self.states["combat_superjump_start"].events["animover"].fn = function(inst)
        if inst.AnimState:AnimDone() then
            if inst.AnimState:IsCurrentAnimation("superjump_pre") or
                inst.AnimState:IsCurrentAnimation("sing_pre") then
                inst.components.rider:ActualDismount()
                inst.AnimState:PlayAnimation("superjump_lag")
                inst:PerformBufferedAction()
            else
                inst.sg:GoToState("idle")
            end
        end
    end

    self.states['combat_lunge_start'].onenter = function(inst)
        inst.components.locomotor:Stop()
        if inst.components.rider and inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("sing_pre")
        else
            local weapon = inst.components.combat:GetWeapon()
            if weapon and string.find(weapon.prefab, 'spear_lightning_pro') then
                inst.AnimState:PlayAnimation("atk_leap_pre")
            else
                inst.AnimState:PlayAnimation("lunge_pre")
            end
        end
    end

    self.states['combat_lunge_start'].timeline = {
        TimeEvent(4 * FRAMES, function(inst)
            local weapon = inst.components.combat:GetWeapon()

            if weapon and string.find(weapon.prefab, 'spear_lightning_pro') then

            else
                inst.SoundEmitter:PlaySound("dontstarve/common/twirl", nil, nil,
                                            true)
            end
        end)
    }

    self.states["combat_lunge_start"].events["animover"].fn = function(inst)
        if inst.AnimState:AnimDone() then
            if inst.AnimState:IsCurrentAnimation("atk_leap_pre") or
                inst.AnimState:IsCurrentAnimation("lunge_pre") then
                inst.components.rider:ActualDismount()

                inst.AnimState:PlayAnimation("lunge_lag")
                inst:PerformBufferedAction()
            else
                inst.sg:GoToState("idle")
            end
        end
    end

end)

-- 永恒新界联动
AddPrefabPostInit("shadow_soul", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("upgrader")
    inst.components.upgrader.upgradetype =
        UPGRADETYPES.Wathgrithr_NewConstantSpear
end)
