GLOBAL.setmetatable(env, {
    __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end
})

modimport("scripts/skin/skinsapi.lua") -- 调用皮肤api  来自穹

local item_list = -- 有皮肤的物品代码
{
    {"spear_lightning_pro", "spear_lightning_pro"},
    {"spear_lightning_pro2", "spear_lightning_pro"}
}

local pifu_list = -- 对应的皮肤
{
    {
        name = "spear_lightning_pro",
        base = "spear_lightning_pro",
        skin = "spear_lightning_pink"
    }, 
    {
        name = "spear_lightning_pro",
        base = "spear_lightning_pro",
        skin = "spear_lightning_white"
    }, 
    {
        name = "spear_lightning_pro2",
        base = "spear_lightning_pro",
        skin = "spear_lightning_pink"
    }, 
    {
        name = "spear_lightning_pro2",
        base = "spear_lightning_pro",
        skin = "spear_lightning_white"
    }
}

-- 开始注册:
for k, v in pairs(item_list) do -- 注册默认皮肤
    MakeItemSkinDefaultImage(v[1], "images/inventoryimages/" .. v[2] .. ".xml",
                             v[2])
end

RegisterInventoryItemAtlas("images/inventoryimages/spear_lightning_pro.xml",
                           "spear_lightning_pro.tex") -- 注册皮肤
RegisterInventoryItemAtlas("images/inventoryimages/spear_lightning_pink.xml",
                           "spear_lightning_pink.tex") -- 注册皮肤
RegisterInventoryItemAtlas("images/inventoryimages/spear_lightning_white.xml",
                           "spear_lightning_white.tex") -- 注册皮肤

for k, v in pairs(pifu_list) do
    MakeItemSkin(v.name, v.skin, -- 原名和皮肤名
    {
        bank = v.skin,
        build = v.skin,
        basebank = v.base,
        basebuild = v.base, -- 原物品scml文件名字
        rarity = "NANA", -- 珍惜度:没有什么意义,是啥都行,可以随便编一个
        type = "item", -- 类别
        name = v.skin, -- 填皮肤的名称:经典,小熊,小猫,小狗什么的
        atlas = "images/inventoryimages/" .. v.skin .. ".xml", -- 制作栏的图片
        image = v.skin
    })
end
