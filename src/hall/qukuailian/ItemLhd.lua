--龙虎斗
local ItemLhd = class("ItemLhd", ccui.Layout)


function ItemLhd:ctor(gameData)
	-- self.super.ctor(self,PopType.small)
	-- self.super.ctor();
	self:initData(gameData);
	self:initUI();
	

end

function ItemLhd:create(gameData)
	local layer = ItemLhd.new(gameData);

	return layer;
end

function ItemLhd:initUI()

	display.loadSpriteFrames("longhudou/card.plist", "longhudou/card.png");

	local panelSize = cc.size(910,206);
	
	local panel = ccui.Layout:create();
	panel:setContentSize(panelSize);
	panel:setPosition(cc.p(0,0));
	self:setContentSize(panelSize);


	--龙家
	local imageDragon = ccui.ImageView:create("qukuailian/image2/qklian_lankuang.png",ccui.TextureResType.localType);
	panel:addChild(imageDragon);
	local size = imageDragon:getContentSize();
	imageDragon:setPosition(cc.p(panelSize.width*0.5-20 - size.width*0.5,panelSize.height*0.5));
	--龙img	
	local imageDragonWord = ccui.ImageView:create("qukuailian/image2/qklian_long.png",ccui.TextureResType.localType);
	imageDragon:addChild(imageDragonWord);
	imageDragonWord:setPosition(cc.p(92,96));

	local midPos = cc.p(278,105.5);
	local cardDragon = ccui.ImageView:create(string.format("dzpk_0x%02X.png", self.m_gameData.m_iRBCard[1][1]),ccui.TextureResType.plistType);
	imageDragon:addChild(cardDragon);
	cardDragon:setScale(0.78);
	cardDragon:setPosition(midPos);
		

	--虎家
	local imageTiger = ccui.ImageView:create("qukuailian/image2/qklian_lankuang.png",ccui.TextureResType.localType);
	panel:addChild(imageTiger);
	local size = imageTiger:getContentSize();
	imageTiger:setPosition(cc.p(panelSize.width*0.5+20 + size.width*0.5,panelSize.height*0.5));
	--虎img	
	local imageTigerWord = ccui.ImageView:create("qukuailian/image2/qklian_hu.png",ccui.TextureResType.localType);
	imageTiger:addChild(imageTigerWord);
	imageTigerWord:setPosition(cc.p(92,96));

	local cardTiger = ccui.ImageView:create(string.format("dzpk_0x%02X.png", self.m_gameData.m_iRBCard[2][1]),ccui.TextureResType.plistType);
	imageTiger:addChild(cardTiger);
	cardTiger:setScale(0.78);
	cardTiger:setPosition(midPos);


	self:addChild(panel);

end

function ItemLhd:initData(gameData)
	self.m_gameData = gameData;

	self.m_cardDragon = nil; --龙牌
	self.m_cardTiger = nil; --虎牌
end



return ItemLhd
