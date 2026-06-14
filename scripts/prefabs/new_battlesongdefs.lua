-- Possible params: TICK_RATE, ONAPPLY, ONEXTENDED, ONDETACH, TICK_FN, ATTACH_FX, DETTACH_FX, INSTANT, DELTA, USES, SOUND
-- INSTANT, DELTA AND TARGET_PLAYERS are quote only
-- I'm keeping USES around in case we change our minds and decide the make the battlesongs consumable
local song_defs =
{
    ------------- CUSTOM INSTANT SONGS -------------
    ------------------------------------------------
    -- 群体治疗
    -- battlesong_c_cure =
    -- {
    --     ONINSTANT = function(singer, target)
    --         if target.components.health then
    --             target.components.health:DoDelta(TUNING.BATTLESONG_C_CURE_VALUE)
    --         end
    --     end,

    --     CUSTOMTARGETFN = function(singer)
    --         if TheNet:GetPVPEnabled() then
    --             return nil
    --         end

    --         local players = {}

    --         local x, y, z = singer.Transform:GetWorldPosition()
    --         local radius = singer.components.singinginspiration.attach_radius

    --         for _, v in pairs(TheSim:FindEntities(x, y, z, radius)) do
    --             -- 驯化的牛牛
    --             -- 所有玩家
    --             -- 自己的随从
    --             if v.components.domesticatable and not v.components.domesticatable.near_death and v.components.domesticatable.domestication >= 0.01
    --                 or v:HasTag("player")
    --                 or (v.components.follower and v.components.follower.leader and v.components.follower.leader == singer)
    --             then
    --                 table.insert(players, v)
    --             end
    --         end
    --         -- table.insert(players, singer)

    --         return players or nil
    --     end,

    --     INSTANT = true,
    --     DELTA = 100 * 2 / 6,
    --     COOLDOWN = 30,
    --     ATTACH_FX = "battlesong_instant_panic_fx",
    --     SOUND = "dontstarve_DLC001/characters/wathgrithr/song/shadow",
    -- },
    -- 修复武器
    battlesong_c_repair =
    {
        ONINSTANT = function(singer, target)
            local equip = singer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if equip ~= nil and equip.components.weapon ~= nil and equip.components.finiteuses ~= nil then
                equip.components.finiteuses:Repair(TUNING.BATTLESONG_C_REPAIR_VALUE)
            end
        end,

        CUSTOMTARGETFN = function(singer)
            return { singer }
        end,

        INSTANT = true,
        DELTA = 100 * 2 / 6,
        COOLDOWN = 30,
        ATTACH_FX = "battlesong_attach",
        SOUND = "dontstarve_DLC001/characters/wathgrithr/song/lunar",
    },
    -- -- 召唤光
    -- battlesong_c_light =
    -- {
    --     ONINSTANT = function(singer, target)
    --         if singer._light then
    --             singer._light:Remove()
    --         end
    --         singer._light = SpawnPrefab("booklight", nil, 0)
    --         singer._light.owner = singer

    --         --让灯光跟着自己
    --         singer._light:DoPeriodicTask(FRAMES, function(inst)
    --             local x, y, z = singer._light.owner.Transform:GetWorldPosition()
    --             singer._light.Transform:SetPosition(x, y, z)
    --         end)

    --         --时间到自动删除
    --         singer._light:DoTaskInTime(TUNING.TOTAL_DAY_TIME / 4, function(inst)
    --             -- TheWorld:PushEvent("ms_startthemoonstorms")

    --             singer._light = nil
    --             inst:Remove()
    --         end)

    --         -- TheWorld:PushEvent("ms_stopthemoonstorms")
    --     end,

    --     CUSTOMTARGETFN = function(singer)
    --         return { singer }
    --     end,

    --     INSTANT = true,
    --     DELTA = TUNING.BATTLESONG_INSTANT_COST,
    --     COOLDOWN = TUNING.SKILLS.WATHGRITHR.BATTLESONG_INSTANT_COOLDOWN,
    --     ATTACH_FX = "battlesong_attach",
    --     SOUND = "dontstarve_DLC001/characters/wathgrithr/song/fireresistance",
    -- },
    -- -- 防风暴
    -- battlesong_c_storm =
    -- {
    --     ONINSTANT = function(singer, target)
    --         local maxlevel = 0.9
    --         local duaration = 30
    --         local interval = 0.5
    --         local fulllevel = TUNING.SANDSTORM_FULL_LEVEL
    --         local delta = (maxlevel - fulllevel) / (duaration / interval)

    --         singer._stormsong = maxlevel
    --         singer._stormsongfn = singer:DoPeriodicTask(interval, function(inst)
    --             if singer._stormsong and singer._stormsong > fulllevel then
    --                 singer._stormsong = singer._stormsong - delta
    --             else
    --                 singer._stormsongfn:Cancel()
    --                 singer._stormsongfn = nil
    --             end
    --         end)
    --     end,

    --     CUSTOMTARGETFN = function(singer)
    --         return { singer }
    --     end,

    --     INSTANT = true,
    --     DELTA = TUNING.BATTLESONG_INSTANT_COST,
    --     COOLDOWN = TUNING.SKILLS.WATHGRITHR.BATTLESONG_INSTANT_COOLDOWN,
    --     ATTACH_FX = "battlesong_attach",
    --     SOUND = "dontstarve_DLC001/characters/wathgrithr/song/revive",
    -- },
}

local battlesong_netid = 1
local battlesong_netid_lookup = {}

local function AddNewBattleSongNetID(prefab, song_def)
    song_def.battlesong_netid = battlesong_netid
    table.insert(battlesong_netid_lookup, prefab)
    assert(battlesong_netid < 8,
        "the max number of battle songs has been passed, you will need to change the netvar for player_classified.inspirationsong1/2/3 to support more")

    battlesong_netid = battlesong_netid + 1
end

for k, v in pairs(song_defs) do
    v.ITEM_NAME = k
    v.NAME      = k .. "_buff" -- this name is actually the buff's name, not the inventory item
    if not v.INSTANT then
        AddNewBattleSongNetID(k, v)
    end
end

local function GetBattleSongDefFromNetID(netid)
    local def = netid ~= nil and battlesong_netid_lookup[netid] or nil
    return def ~= nil and song_defs[def] or nil
end

return {
    song_defs = song_defs,
    GetBattleSongDefFromNetID = GetBattleSongDefFromNetID,
    AddNewBattleSongNetID =
        AddNewBattleSongNetID
}
