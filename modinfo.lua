-- This information tells other players more about the mod
name = "最好的女武神"
description =
"版本：8.1.5\n修复数个崩溃bug\n更新：\n8.1.4\n使女武神使用起来更加丝滑\n详情看设置\n8.1.3\n1.新增了一个过度装备，绝境头盔。使用绝望石升级统帅头获得。2.绝境头可以通过启迪碎片升级为武神头\n8.1.2\n修复了切换武器模式时的一些bug\n8.1.1\n1.通过武器颤音，可以切换武神矛的攻击方式。\n2.为投掷长矛增加了一个开关\n3.修复了关闭吃素选项后，依然可以吃素的bug \n8.1.0\n更换了武神矛的贴图，修复了心碎歌谣无限睡眠的bug\n8.0.0\n武神矛攻击动作变为刺\n武神矛攻击力调整为17，位面伤害10。但是每次攻击会攻击3次\n并放大了武神矛的模型大小\n7.7.1\n武神矛美术\n7.6.2\n武神头拥有位面防御\n武神头损坏时不会爆掉，但是属性会变为0\n《永恒新界》的暗黑之魂和钢铁之魂可以升级武神头和武神矛\n7.5.4\n联动永恒新界：真·武神长矛，真·武神头盔\n7.5.1\n降低了武神头盔的额外伤害比例。但是武神头会继承启迪王冠的特性。\n7.4.6\n给战斗号子提供了不同的UI\n7.4.5\n部分改动的数值可以在配置中调整\n如遇无法启动服务器的情况，请打开配置也点一下重置\n7.3.8\n兼容了insight\n冲天刺不会吓走目标\n7.3.6\n盾牌攻击可以嘲讽敌人\n盾牌和粗鲁插曲的嘲讽可以维持3s\n战斗长矛可以投掷\n专属长矛系列都修改为智能施法，且可以骑乘时使用\n7.2.3\n修复战士重奏可能崩溃的bug\n7.2.1\n修复了打断唱歌时，可能崩溃的问题\n7.2.0\n心碎歌谣额外附带霸体\n7.1.7\n修复了队友不能使用战斗头盔\n7.1.5\n修复了上下洞穴可能掉线的bug\n冲天刺修改为快捷施法\n7.1.4\n修复无法种植的bug'\n完全充能矛 更名为 武神长矛\n技能：冲天刺，cd 3秒\n冲天刺落地后的2秒内，获得95%防御\n冲天刺可以快速上下牛"
author = "大泽"
version = "8.1.5"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
    "wathgrithr",
}

configuration_options = {

    { name = "Title", label = "饮食篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "EatVegetables",
        label = "可以吃素食",
        hover = "可以吃素食，但收益衰减",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "25%", data = .25, hover = "" },
            { description = "50%", data = .5, hover = "" },
            { description = "75%", data = .75, hover = "" },
            { description = "100%", data = 1, hover = "" },
        },
        default = .5,
    },
    {
        name = "MeatAddInspiration",
        label = "吃肉加灵感",
        hover = "吃肉可以恢复灵感",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "25%", data = .25, hover = "" },
            { description = "50%", data = .5, hover = "" },
            { description = "75%", data = .75, hover = "" },
            { description = "100%", data = 1, hover = "" },
        },
        default = 1,
    },
       {
        name = "SaltBoxPushMeatDried",
        label = "盐盒可以放肉干",
        hover = "盐盒可以放肉干和怪物肉干",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "开启", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "QuickSpell",
        label = "快捷施法",
        hover = "按住右键瞄准，松开时释放",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "开启", data = true, hover = "" },
        },
        default = true,
    },
    { name = "Title", label = "长矛篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "WathgrithrSpearThrow",
        label = "战斗长矛可投掷",
        hover = "",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "WathgrithrSpearUpdate",
        label = "战斗长矛可升级",
        hover = "1个羊角将战斗长矛升级为奔雷矛",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "LightningSpearFx",
        label = "奔雷矛调整",
        hover = "新增：移速 15%, 冲刺可以回耐久",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "LightningSpearUpdate",
        label = "奔雷矛升级材料",
        hover = "新增：暗影心房",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
       {
        name = "LightningSpearChargePro",
        label = "解锁武神长矛",
        hover = "材料：附身暗影心房/充电火花柜\n属性：攻击 68，位面 30，CD 0.5，移速 25%",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "默认强度", data = 1, hover = "" },
            { description = "1.5倍", data = 1.5, hover = "" },
            { description = "2倍", data = 2, hover = "" },
            { description = "3倍", data = 3, hover = "" },
        },
        default = 1,
    },
    -- 添加新的配置选项来控制AoE技能
    {
        name = "IsAoeSkill",
        label = "启用武神矛AoE技能",
        hover = "为了兼容熔炉武器包，只能禁用右键了。。",
        options = {
            { description = "关闭", data = false, hover = "禁用武神矛的范围攻击技能" },
            { description = "开启", data = true, hover = "启用武神矛的范围攻击技能" },
        },
        default = false,
    },
    { name = "Title", label = "头盔篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "WathgrithrHatUpdate",
        label = "战斗头盔可升级",
        hover = "1个大理石升级为统帅头盔",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "WathgrithrImproveFx",
        label = "不满血也能回耐久",
        hover = "不满血也能回耐久",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "WathgrithrImproveUpdate",
        label = "统帅头盔可升级",
        hover = "材料：启迪碎片\n属性：85%，防水 90%，攻击造成目标已损生命1%的伤害",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "默认强度", data = 1, hover = "" },
            { description = "1.5倍", data = 1.5, hover = "" },
            { description = "2倍", data = 2, hover = "" },
            { description = "3倍", data = 3, hover = "" },
        },
        default = 1,
    },
    { name = "Title", label = "盾女篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "NoEquipCD",
        label = "取消切换时的CD",
        hover = "取消切换时的CD",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "ResetCD",
        label = "格挡成功重置CD",
        hover = "格挡成功重置CD",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "RepairShield",
        label = "恢复耐久度",
        hover = "格挡成功后的攻击可以恢复盾牌耐久度",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "ShieldTaunt",
        label = "盾击嘲讽",
        hover = "盾击可以强制嘲讽目标",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    { name = "Title", label = "训牛篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "RideTime",
        label = "骑乘时间",
        hover = "训牛技能2的时间",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "50%", data = 1.5, hover = "" },
            { description = "100%", data = 2, hover = "" },
            { description = "150%", data = 2.5, hover = "" },
            { description = "200%", data = 3, hover = "" },
        },
        default = 2,
    },
    {
        name = "InspirationMax",
        label = "灵感恢复",
        hover = "训牛技能3的灵感值自动恢复可恢复到100%",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "AttackCureBeefalo",
        label = "治疗牛牛",
        hover = "骑乘攻击可以治疗牛牛",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "RiderWeapon",
        label = "骑乘武器",
        hover = "骑乘攻击可以使用武器",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    { name = "Title", label = "音乐篇", options = { { description = "", data = "0" }, }, default = "0", },
    {
        name = "BigBattleContainer",
        label = "乐谱桶优化",
        hover = "筒子不会自动关闭",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleContainerUI",
        label = "乐谱桶容量",
        hover = "调整筒子的容量和UI",
        options = {
            { description = "不改变", data = 0, hover = "" },
            { description = "UI 1", data = 1, hover = "" },
            { description = "UI 2", data = 2, hover = "" },
        },
        default = 1,
    },
    {
        name = "BattleSongHealth",
        label = "心碎歌谣加强",
        hover = "额外效果：霸体",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongWeapon",
        label = "武器颤音加强",
        hover = "额外效果:大幅降低武器耐久度的消耗",
        options = {
            { description = "关闭", data = 0, hover = "" },
            { description = "50%", data = .5, hover = "" },
            { description = "25%", data = .25, hover = "" },
            { description = "10%", data = .1, hover = "" },
        },
        default = .25,
    },
    {
        name = "BattleSongSanity",
        label = "醍醐灌顶加强",
        hover = "额外效果：召唤一道光",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongHero",
        label = "英勇赞歌加强",
        hover = "额外效果：无视风暴",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongFire",
        label = "防火假声加强",
        hover = "额外效果：使目标潮湿",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongMoon",
        label = "启迪夜曲加强",
        hover = "额外效果：不会被虚影攻击",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongShadow",
        label = "黑暗悲歌加强",
        hover = "额外效果：不会被影怪攻击",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongTaunt",
        label = "粗鲁插曲加强",
        hover = "额外效果：破防易伤，并且可以对BOSS生效",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongPanic",
        label = "惊心独白加强",
        hover = "额外效果：减速",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongRelive",
        label = "战士重奏加强",
        hover = "额外效果：没死的队友回血",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = true,
    },
    {
        name = "BattleSongRepair",
        label = "新乐谱修复",
        hover = "修复手上的武器",
        options = {
            { description = "关闭", data = false, hover = "" },
            { description = "打开", data = true, hover = "" },
        },
        default = false,
    },
}
