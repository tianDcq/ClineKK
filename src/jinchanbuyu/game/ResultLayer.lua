local ResultLayer = class("ResultLayer", PopLayer)

local shareTag = 10;
local continueTag = 11;
local chongxinpipeiTag = 12;
local leaveTag = 13;
local hideTag = 14;

function ResultLayer:create(tableLayer)
	return ResultLayer.new(tableLayer);
end

function ResultLayer:ctor(tableLayer)
	self.super.ctor(self, PopType.middle);
	self.tableLayer = tableLayer;

    self:initUI()
end

function ResultLayer:initUI()
    self.sureBtn:removeSelf()
	local size = self.size

	local biaoti = ccui.ImageView:create("fishing/game/jiesuan/youxijiesuan.png");
	-- biaoti:setAnchorPoint(0.5,1)
	biaoti:setPosition(size.width/2, size.height-50);
	self.bg:addChild(biaoti);

	local Button_back = ccui.Button:create("fishing/game/jiesuan/likai.png","fishing/game/jiesuan/likai-on.png");
	Button_back:setPosition(size.width/2+200, size.height/6-40);
	Button_back:setTag(leaveTag);
	self.bg:addChild(Button_back);
	-- Button_back:setScale(0.8)
	Button_back:onClick(function(sender) self:onClick(sender); end);

	local btnContinue = ccui.Button:create("fishing/game/jiesuan/jixu.png","fishing/game/jiesuan/jixu-on.png");
	btnContinue:setPosition(size.width/2-200, size.height/6-40);
	btnContinue:setTag(continueTag);
	self.bg:addChild(btnContinue);
	-- btnContinue:setScale(0.8)
	btnContinue:onClick(function(sender) self:onClick(sender); end);

	self.fishListView = ccui.ListView:create();
    self.fishListView:setAnchorPoint(cc.p(0.5,0.5));
    self.fishListView:setDirection(ccui.ScrollViewDir.vertical);
    self.fishListView:setBounceEnabled(true);
    self.fishListView:setContentSize(cc.size(self.bg:getContentSize().width*0.9, self.bg:getContentSize().height*0.55));
    self.fishListView:setPosition(size.width/2,size.height/2);
    self.bg:addChild(self.fishListView);
end

function ResultLayer:showResult(data)
	local fishID = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,55,56,21,22,23,24,64,65,66,31,32,33,34,35,36,37,38,39,40,68,69,70,71};
	local scale = {1,1,1,1,1,
				   0.8,0.8,0.8,0.8,1,
				   0.6,0.6,0.5,0.4,0.5,
				   0.5,0.4,0.4,0.4,0.3,
				   0.45,0.5,
				   0.5,0.5,0.7,0.5,0.3,

				   0.3,0.25,

				   1,1,1,1,1,
				   1,1,0.9,1,1,

				   1,1,1,0.8,0.5,
				   0.7,0.5,

				   0.4,0.23,0.2,0.2};

	local layout = nil;

	for k,v in pairs(fishID) do	
		-- if v<=40 or (v==55 or v==56)then	
		if k % 5 == 1 then
			layout = ccui.Layout:create();
    		layout:setContentSize(cc.size(600, 130));
    		self.fishListView:pushBackCustomItem(layout);
		end
		display.loadSpriteFrames("jinchanbuyu/fishing/fish/jcby_fish_test1.plist", "jinchanbuyu/fishing/fish/jcby_fish_test1.png");
		display.loadSpriteFrames("jinchanbuyu/fishing/fish/jcby_fish_test2.plist", "jinchanbuyu/fishing/fish/jcby_fish_test2.png");
		-- display.loadSpriteFrames("jinchanbuyu/fishing/fish/jcby_fish_test3.plist", "jinchanbuyu/fishing/fish/jcby_fish_test3.png");
		-- display.loadSpriteFrames("jinchanbuyu/fishing/fish/jcby_fish_test4.plist", "jinchanbuyu/fishing/fish/jcby_fish_test4.png");
		-- display.loadSpriteFrames("jinchanbuyu/fishing/fish/boss.plist", "jinchanbuyu/fishing/fish/boss.png");
	 --    display.loadSpriteFrames("jinchanbuyu/fishing/fish/boss1.plist", "jinchanbuyu/fishing/fish/boss1.png");
	 --    display.loadSpriteFrames("jinchanbuyu/fishing/fish/boss2.plist", "jinchanbuyu/fishing/fish/boss2.png");
		local str = "";
		local image = nil;
		local xSize = self.fishListView:getContentSize()
		local posx = xSize.width/2+200*((k-1)%5-2)-20
		if v >= FishType.FISH_FENGHUANG and v <= FishType.FISH_KIND_40 then--鱼王
			str = "jcby_fish_"..(v-30).."_1.png";
			image = ccui.ImageView:create("fishing/effect/39/dish.png");
			image:setPosition(posx, 100);
			layout:addChild(image);
			image:setScale(scale[k]);
		elseif v >= 68 and v <= 71 then--出奇制胜
			local xtemp = v- 64
			if v == 71 then
				xtemp = v- 63
			end
			str = "jcby_fish_"..(xtemp).."_1.png";
			image = ccui.ImageView:create("fishing/cqzs.png");
			image:setPosition(posx, 100);
			layout:addChild(image);
			image:setScale(scale[k]);
		elseif v >= 64 and v <= 66 then--三元
			str = "fish";
			image = ccui.ImageView:create("fishing/game/jiesuan/sanyuan/s"..(v-63)..".png");
			image:setPosition(posx, 100);
			layout:addChild(image);
			image:setScale(scale[k]);
		-- elseif v >= 28 and v <= 30 then--四喜
		-- 	str = "fish";
		-- 	image = ccui.ImageView:create("game/jiesuan/sanyuan/s"..(v-24)..".png");
		-- 	image:setPosition(80+180*((k-1)%5), 100);
		-- 	layout:addChild(image);
		-- 	image:setScale(scale[k]);
		else
			str = "jcby_fish_"..v.."_1.png";
		end

		if str ~= "" then
			local x = 0;
			local fish = nil;
			if str ~= "fish" then
				fish = cc.Sprite:createWithSpriteFrameName(str);
			else
				fish =cc.Sprite:create("hall/common/touming.png")
			end
			if image == nil then
				fish:setPosition(posx, 100);			
				fish:setScale(scale[k]);
				layout:addChild(fish);
				x = fish:getPositionX()+80;
			else
				fish:setPosition(image:getContentSize().width/2,image:getContentSize().height/2);
				image:addChild(fish);
				x = image:getPositionX()+80
			end			

			local label = FontConfig.createWithSystemFont(data.m_lFishCount[v],28,FontConfig.colorRed);
			label:setAnchorPoint(0.5,0.5);
			label:setPosition(x, 100);
			label:setLocalZOrder(1);
			layout:addChild(label);
		end
	-- end
	end
end

function ResultLayer:onClick(sender)
    local tag = sender:getTag();

    if self.tableLayer == nil then
    	return;
    end

	if tag == continueTag then
		self.tableLayer:resultCallback();
	elseif tag == leaveTag then
		self.tableLayer:backPlatform();
    end	
end

function ResultLayer:onClickClose(sender)
	self.tableLayer:resultCallback();
end

return ResultLayer
