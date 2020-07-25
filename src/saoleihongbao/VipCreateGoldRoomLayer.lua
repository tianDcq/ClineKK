--金币房
local CreateGoldRoomLayer = class("CreateGoldRoomLayer", BaseWindow)
local VipRoomInfoModule = require("hall.layer.popView.newExtend.vip.VipRoomInfoModule"):getInstance()

function CreateGoldRoomLayer:create(gameName)
	return CreateGoldRoomLayer.new(gameName);
end

function CreateGoldRoomLayer:ctor(gameName)
	self.super.ctor(self,0,false);

	self.gameName = gameName;

	self:initData();

	self:initUI();

	self:bindEvent();
end

function CreateGoldRoomLayer:initData()
	self.m_selectedNameID = 0;
	self.m_selectedRoomID = 0
end

function CreateGoldRoomLayer:initUI()

	local vipLayer = display.getRunningScene():getChildByName("VipHallLayer")
	if  vipLayer then
		vipLayer.VIPGameListLayer:getChildByName("mask1"):setVisible(false)
		vipLayer:showShengqingBtn(false)
	end

	local winSize = cc.Director:getInstance():getWinSize();

	self.touchLayer = display.newLayer()
	self.touchLayer:setTouchEnabled(true)
	self.touchLayer:setLocalZOrder(100)
	self:addChild(self.touchLayer)
	self.touchLayer:onTouch(function(event) 
							local eventType = event.name
							if eventType == "began" then
								return true
							end
				end,false, true)
	
	-- local size = cc.size(1015,483)
	local zongNum = 0
	for k,room in pairs(globalUnit.VipRoomList) do
		if room == 1 then
			zongNum = zongNum + 1;
		end
	end

	local teamCount = 0
	-- local difenNum = {} --非体验场
	-- local ruchangNum = {3000} --非体验场

	local GameNameID = VipRoomInfoModule:getuNameIDBysGameName(self.gameName)
	local roomList_Roomid = VipRoomInfoModule:getRoomListBysGameName(self.gameName)
	--local  ntag = {3,4,1,2}
	for k,room in pairs(globalUnit.VipRoomList) do
    	if room == 1 then
            teamCount = teamCount +1
            local x = 0--105+winSize.width*0.5-300+(teamCount-1)*220;
        	local y = 0--winSize.height*0.5;
         	if teamCount > 3 then
    			y = winSize.height*0.40-30;
    			x = 105+winSize.width*0.5-300+(teamCount-1-3)*280
    		else
    			x = 105+winSize.width*0.5-300+(teamCount-1)*280
    			y = winSize.height*0.68-20;
    		end
            local typeset_brnn = ccui.Button:create("newExtend/vip/typeset/"..k..".png","newExtend/vip/typeset/"..k.."-on.png")
            typeset_brnn:setPosition(x,y)
            typeset_brnn:setTag(k)
            
            typeset_brnn:onClick(handler(self, self.enterGame))
            self:addChild(typeset_brnn)
            -- typeset_brnn:setScale(0.6)

   --          if checkIphoneX() then
			-- 	typeset_brnn:setPositionX(typeset_brnn:getPositionX() + 150)
			-- end

            local size = typeset_brnn:getContentSize();
            local name = {"xianjinchang"}
            local nameStr = {}
            if self.gameName == "game_brps" then
                name = {"xianjin4bei","xianjin10bei"}
            elseif self.gameName == "game_slhb" then
                name = {"10bao","7bao","add10","add7"}
                nameStr = {"红包额度:10-50元","红包额度:10-50元","红包额度:10-500元","红包额度:10-500元"}
            end
            local biaoti = ccui.ImageView:create("newExtend/vip/typeset/"..name[k]..".png")
		    biaoti:setPosition(size.width/2,size.height*0.65)
		    typeset_brnn:addChild(biaoti)
		    -- biaoti:setScale(0.8)

		    local xianzhitip = FontConfig.createWithSystemFont(nameStr[k],22)
            xianzhitip:setPosition(size.width*0.5,size.height*0.38)
            typeset_brnn:addChild(xianzhitip)

		    local gold = ccui.ImageView:create("newExtend/vip/typeset/gold.png")
		    gold:setPosition(size.width*0.35,size.height*0.18)
		    typeset_brnn:addChild(gold)

		    -- local ruchang = ccui.ImageView:create("newExtend/vip/typeset/ruchang.png")
		    -- ruchang:setPosition(size.width*0.68,size.height*0.51)
		    -- typeset_brnn:addChild(ruchang)

		    
		    -- local minRoomKey = RoomInfoModule:getRoomNeedGold(GameNameID,roomList_Roomid[k])--ruchangNum[k] --最小金币限制
      --       local xianzhi = FontConfig.createWithCharMap(tostring(minRoomKey/100), "newExtend/vip/typeset/zitiao.png", 15, 22, "+");
      --       xianzhi:setPosition(size.width*0.4,size.height*0.52)
      --       typeset_brnn:addChild(xianzhi)

            local minRoomKey = RoomInfoModule:getRoomNeedGold(GameNameID,roomList_Roomid[k])--ruchangNum[k] --最小金币限制
            -- local xianzhi = FontConfig.createWithCharMap(tostring(minRoomKey/100), "newExtend/vip/typeset/zitiao.png", 15, 22, "+");
            -- xianzhi:setPosition(size.width*0.6,size.height*0.35)
            -- typeset_brnn:addChild(xianzhi)
            local xianzhi = FontConfig.createWithSystemFont(tostring(minRoomKey/100),24)
            xianzhi:setPosition(size.width*0.56,size.height*0.18)
            xianzhi:setAnchorPoint(0.5,0.5)
            typeset_brnn:addChild(xianzhi)
		    
        end
    end

    local guatiao = ccui.ImageView:create("newExtend/vip/common/di1.png")
    guatiao:setPosition(winSize.width*0.5+585,winSize.height*0.6)
    guatiao:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(guatiao)

    local Label_name = FontConfig.createWithSystemFont("扫\n雷\n红\n包",26 ,cc.c3b(90, 44, 14));
    Label_name:setPosition(guatiao:getContentSize().width/2+10,guatiao:getContentSize().height/2-10)
    Label_name:setContentSize(cc.size(50,140))
    guatiao:addChild(Label_name)
end

function CreateGoldRoomLayer:initGameData()
	local gameList = GamesInfoModule:findGameList("game")

	self.gameList = gameList or {};
	-- luaDump(self.gameList)

	table.sort(self.gameList, function(a,b) return a.uNameID < b.uNameID; end);
end

function CreateGoldRoomLayer:onEnter()
	self.super.onEnter(self)
end

function CreateGoldRoomLayer:onEnterTransitionFinish()
	self:showFangjian();

	self.super.onEnterTransitionFinish(self)
end

function CreateGoldRoomLayer:showFangjian()
	local VisibleCount = 0

	self:initGameData()

	VisibleCount = #self.gameList

	if VisibleCount == 0 then
		dispatchEvent("requestGameList")
	else
		local ret = false
		local index = 0
		for k,v in pairs(self.gameList) do
			if string.find(v.szGameName,self.gameName) then
				ret = true
				self.m_selectedNameID = v.uNameID
				index = k
				break
			end
		end

		if ret then
			-- //设置当前游戏
			GameCreator:setCurrentGame(self.m_selectedNameID);

			local roomList = RoomInfoModule:getRoomInfoByNameID(self.gameList[index].uNameID)

			self.roomList = roomList or {}
			luaDump(self.roomList,"self.roomList")
			table.sort(self.roomList, function(a,b) return a.uRoomID < b.uRoomID; end);

			if #self.roomList == 0 then
				dispatchEvent("requestRoomList")
				return
			else
				-- self.difen4:setText(goldConvert(RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.roomList[1].uRoomID),1));
				-- self.difen10:setText(goldConvert(RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.roomList[2].uRoomID),1));
				
				-- --调整位置
				-- local gap = 10;
				-- local imageRuchang4 = self.difen4:getChildByName("ruchang");
				-- local imageYuan4 = self.difen4:getChildByName("yuan");
				-- if imageYuan4 then
				-- 	imageYuan4:setPosition(-gap,self.difen4:getContentSize().height*0.5);
				-- end
				-- if imageRuchang4 then
				-- 	imageRuchang4:setPosition(self.difen4:getContentSize().width+gap,self.difen4:getContentSize().height*0.5);
				-- end

				-- local imageRuchang10 = self.difen10:getChildByName("ruchang");
				-- local imageYuan10= self.difen10:getChildByName("yuan");
				-- if imageYuan10 then
				-- 	imageYuan10:setPosition(-gap,self.difen10:getContentSize().height*0.5);
				-- end

				-- if imageRuchang10 then
				-- 	imageRuchang10:setPosition(self.difen10:getContentSize().width+gap,self.difen10:getContentSize().height*0.5);
				-- end


				if self.touchLayer then
					self.touchLayer:removeSelf()
					self.touchLayer = nil
				end
			end
		else
			self:delayCloseLayer(0)
		end
	end
end

function CreateGoldRoomLayer:refreshGameList()
	LoadingLayer:removeLoading();
	self:showFangjian();
end

function CreateGoldRoomLayer:bindEvent()
	self.bindIds = {}
	self.bindIds[#self.bindIds + 1] = Event:registerListener(self,"I_P_M_GameList",function () self:refreshGameList() end);

	self:pushGlobalEventInfo("requestGameListSuccess",handler(self, self.refreshGameList))
	self:pushGlobalEventInfo("I_P_M_RoomList",handler(self, self.refreshGameList))
	self:pushGlobalEventInfo("loginRoom",handler(self, self.loginRoom))
end

function CreateGoldRoomLayer:unBindEvent()
	if self.bindIds == nil or (type(self.bindIds) == "table" and next(self.bindIds) == nil) then
		return;
	end

	for _, bindid in pairs(self.bindIds) do
		Event:unRegisterListener(bindid)
	end
end

function CreateGoldRoomLayer:onExit()
	self.super.onExit(self);

	self:unBindEvent();
end

function CreateGoldRoomLayer:enterGame(sender)
	local tag = sender:getTag()

	local mRoomId = {144,145,114,115};
	self.m_selectedRoomID = mRoomId[tag]--self.roomList[globalUnit.iRoomIndex].uRoomID
	
	--查找房间是否开启
	local findFlag = false;
	for k,v in pairs(self.roomList) do
		if v.uRoomID == self.m_selectedRoomID then
			findFlag = true;
			break;
		end
	end

	if findFlag == false then
		--addScrollMessage(msg.."暂未开放!")
		dispatchEvent("requestGameList")
		return
	end
	-- if not self.roomList[tag] then
	-- 	-- addScrollMessage("该房间未开！")
	-- 	dispatchEvent("requestGameList")
	-- 	return
	-- end

	luaPrint("m_selectedRoomID == "..self.m_selectedRoomID)
	if GamesInfoModule:findGameName(self.m_selectedNameID) == nil then
		-- addScrollMessage("百人牛牛暂未开放!");
		dispatchEvent("requestGameList")
		return;
	end

	GameCreator:setCurrentGame(self.m_selectedNameID)

	local gold = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID)
	if gold then
		globalUnit:setEnterGameID(self.m_selectedNameID.."_"..self.m_selectedRoomID)
		self:getMatchRoomMinRoomKey(gold,"最低需要"..goldConvert(gold).."金币以上！")
	else
		local msg = {};
		msg.iNameID = self.m_selectedNameID
		msg.iRoomID = self.m_selectedRoomID
		PlatformLogic:send(PlatformMsg.MDM_GP_DESK_LOCK_PASS, PlatformMsg.ASS_GET_MIN_ROOM_KEY_NUM, msg, PlatformMsg.MSG_GP_MATCH_ROOM_MIN_ROOM_KEY);
		self:delayCloseLayer(0)
	end
end

function CreateGoldRoomLayer:getMatchRoomMinRoomKey(data,msg)
	self.m_nMatchMinRoomKey = data;
	globalUnit.nMinRoomKey = data;

	self:showCreateRoomLayer(msg);
end

function CreateGoldRoomLayer:showCreateRoomLayer(msg)
	if PlatformLogic.loginResult.i64Money < self.m_nMatchMinRoomKey then
		addScrollMessage("抱歉，您的金币低于入场最低限制"..string.format("%.2f",goldConvert(globalUnit.nMinRoomKey)).."，不能进入该游戏房间！")
		showBuyTip()
		return;
	end

	self:setBtnEnabled(true)

	if self.m_pMatchRoomCallBack then
		Hall.showTextState("正在加载房间信息",10,function() self:setBtnEnabled() end)
		self.m_pMatchRoomCallBack();
	else
		dispatchEvent("matchRoom",self.m_selectedRoomID)
	end
end

function CreateGoldRoomLayer:loginRoom(event)
	local runningScene = display.getRunningScene()

	if runningScene:getChildByTag(1111111) then
		runningScene:removeChildByTag(1111111)
	end

	self:setBtnEnabled()
end

function CreateGoldRoomLayer:setBtnEnabled(flag)
	if flag then
		if self.touchLayer == nil then
			self.touchLayer = display.newLayer()
			self.touchLayer:setTouchEnabled(true)
			self.touchLayer:setLocalZOrder(100)
			self:addChild(self.touchLayer)
			self.touchLayer:onTouch(function(event) 
						local eventType = event.name
						if eventType == "began" then
							return true
						end
			end,false, true)
		end
	else
		if self.touchLayer ~= nil then
			self.touchLayer:removeSelf()
			self.touchLayer = nil
		end
	end
end

return CreateGoldRoomLayer
