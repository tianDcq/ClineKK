--金币房
local CreateGoldRoomLayer = class("CreateGoldRoomLayer", BaseWindow)
local VipRoomInfoModule = require("hall.layer.popView.newExtend.vip.VipRoomInfoModule"):getInstance()

function CreateGoldRoomLayer:create(gameName)
	return CreateGoldRoomLayer.new(gameName)
end

function CreateGoldRoomLayer:ctor(gameName)
	self.super.ctor(self, 0, false)

	self.gameName = gameName

	self:initData()

	self:initUI()

	self:bindEvent()
end

function CreateGoldRoomLayer:initData()
	self.m_selectedNameID = 0
	self.m_selectedRoomID = 0
	self.layoutBtn = {}
end

function CreateGoldRoomLayer:initUI()

	local vipLayer = display.getRunningScene():getChildByName("VipHallLayer")
	if  vipLayer then
		vipLayer.VIPGameListLayer:getChildByName("mask1"):setVisible(false)
		vipLayer:showShengqingBtn(false)
	end

	local winSize = cc.Director:getInstance():getWinSize()

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
	local difenNum = {"9","90","900"}
    luaDump(globalUnit.VipRoomList,"globalUnit.VipRoomList")
	local GameNameID = VipRoomInfoModule:getuNameIDBysGameName(self.gameName)
	local roomList_Roomid = VipRoomInfoModule:getRoomListBysGameName(self.gameName)
	local zongNum = 0
	for k,room in pairs(globalUnit.VipRoomList) do
		if room == 1 then
			zongNum = zongNum + 1;
		end
	end
	local teamCount = 0
	for k,room in pairs(globalUnit.VipRoomList) do
            
        if  room == 1 then
        	teamCount = teamCount +1
        	local x = 105+winSize.width*0.5-300+(teamCount-1)*280;
        	local y = winSize.height*0.68-20;
        	
        	
        	
        	if self.gameName == "dz_ddz" then
                if k>2 then
                    return;
                end
            end

            local typeset_dz = ccui.Button:create("newExtend/vip/typeset/"..k..".png","newExtend/vip/typeset/"..k.."-on.png")
            -- typeset_dz:setPosition(105+winSize.width*0.5-((zongNum+1)/2-teamCount)*240,winSize.height*0.5-30)
            typeset_dz:setPosition(x,y)
            typeset_dz:setTag(k)
            typeset_dz:onClick(handler(self, self.enterGame))
            self:addChild(typeset_dz)
            -- typeset_dz:setScale(0.6)

   --          if checkIphoneX() then
			-- 	typeset_dz:setPositionX(typeset_dz:getPositionX() + 150)
			-- end

            local size = typeset_dz:getContentSize();

      --       local dikuang = ccui.ImageView:create("newExtend/vip/typeset/dikuang.png")
		    -- dikuang:setPosition(size.width*0.5,size.height*0.51)
		    -- typeset_dz:addChild(dikuang)

            local gold = ccui.ImageView:create("newExtend/vip/typeset/gold.png")
		    gold:setPosition(size.width*0.35,size.height*0.18)
		    typeset_dz:addChild(gold)

		    local ruchang = ccui.ImageView:create("newExtend/vip/typeset/difen.png")
		    ruchang:setPosition(size.width*0.75,size.height*0.38)
		    typeset_dz:addChild(ruchang)

            local minRoomKey = RoomInfoModule:getRoomNeedGold(GameNameID,roomList_Roomid[k])--ruchangNum[k] --最小金币限制
            -- local xianzhi = FontConfig.createWithCharMap(minRoomKey/100, "newExtend/vip/typeset/zitiao.png", 15, 22, "+");
            -- xianzhi:setPosition(size.width*0.6,size.height*0.35)
            -- typeset_dz:addChild(xianzhi)
            local xianzhi = FontConfig.createWithSystemFont(tostring(minRoomKey/100),30)
            xianzhi:setPosition(size.width*0.56,size.height*0.18)
            xianzhi:setAnchorPoint(0.5,0.5)
            typeset_dz:addChild(xianzhi)

            local difennum = difenNum[k]
            local difen = FontConfig.createWithCharMap(difennum, "newExtend/vip/typeset/difenzitiao.png", 20, 28, "+");
            difen:setPosition(size.width*0.4,size.height*0.38)
            typeset_dz:addChild(difen)

            
            local name = {"pingmin","xiaozi","laoban","fuhao"}
            if self.gameName == "dz_ddz" then
            	name = {"jindian","buxipai"}
            end
            local biaoti = ccui.ImageView:create("newExtend/vip/typeset/"..name[k]..".png")
		    biaoti:setPosition(size.width/2,size.height*0.65)
		    typeset_dz:addChild(biaoti)

		    if self.gameName == "dz_dzpk" then
            	-- ruchang:loadTexture("newExtend/vip/typeset/xianzhi.png")
            	-- ruchang:setPosition(size.width*0.35,size.height*0.51)
            	-- xianzhi:setPosition(size.width*0.6,size.height*0.52)
            	ruchang:loadTexture("newExtend/vip/typeset/xiaomangzhu.png")
                ruchang:setPosition(size.width*0.4,size.height*0.25)
                ruchang:setScale(0.8)
                difen:setPosition(size.width*0.7,size.height*0.25)
                difen:setScale(1)

                local damangzhu = ccui.ImageView:create("newExtend/vip/typeset/damangzhu.png")
                damangzhu:setPosition(size.width*0.4,size.height*0.18)
                typeset_dz:addChild(damangzhu)
                damangzhu:setScale(0.8)

                local difen1 = FontConfig.createWithCharMap(difennum*2, "newExtend/vip/typeset/zitiao.png", 15, 22, "+");
                difen1:setPosition(size.width*0.7,size.height*0.18)
                typeset_dz:addChild(difen1)
            elseif self.gameName == "dz_shuiguoji" then
                difen:setVisible(false)
                ruchang:setVisible(false)
                local Maxxianzhi = FontConfig.createWithSystemFont("最大下注: "..difennum,26)
                Maxxianzhi:setPosition(size.width*0.5,size.height*0.38)
                typeset_dz:addChild(Maxxianzhi)
            end
        end
    end

    if zongNum > 1 then
		-- local btn = ccui.Button:create("newExtend/vip/viphall/kuaisukaishi.png","newExtend/vip/viphall/kuaisukaishi-on.png")
		-- btn:setPosition(105+winSize.width/2, 7)
		-- btn:setAnchorPoint(0.5,0)
		-- btn:setTag(3)
		-- self:addChild(btn)
		-- btn:onClick(handler(self, self.onClick))
		-- self.bottomNode = btn

		-- if checkIphoneX() then
		-- 	btn:setPositionX(btn:getPositionX() + 150)
		-- end
	end

	local guatiao = ccui.ImageView:create("newExtend/vip/common/di1.png")
    guatiao:setPosition(winSize.width*0.5+585,winSize.height*0.6)
    guatiao:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(guatiao)

    local Label_name = FontConfig.createWithSystemFont("超\n级\n水\n果\n机",26 ,cc.c3b(90, 44, 14));
    Label_name:setPosition(guatiao:getContentSize().width/2+10,guatiao:getContentSize().height/2-10)
    Label_name:setContentSize(cc.size(50,140))
    guatiao:addChild(Label_name)
end


function CreateGoldRoomLayer:initGameData()
	local gameList = GamesInfoModule:findGameList("dz")

	self.gameList = gameList or {}
	-- luaDump(self.gameList)

	table.sort(self.gameList, function(a,b) return a.uNameID < b.uNameID end)
end

function CreateGoldRoomLayer:onEnter()
	self.super.onEnter(self)
end

function CreateGoldRoomLayer:onEnterTransitionFinish()
	self:showFangjian()
	self.super.onEnterTransitionFinish(self)

	-- self:receiveExitCreateRoom()
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
            luaDump(roomList,"===roomList");
			self.roomList = roomList or {}
			-- luaDump(self.roomList,"self.roomList")
			table.sort(self.roomList, function(a,b) return a.uRoomID < b.uRoomID end)

			if #self.roomList == 0 then
				dispatchEvent("requestRoomList")
			else
				if self.touchLayer then
					self.touchLayer:removeSelf()
					self.touchLayer = nil
				end
			end
		end
	end
end

function CreateGoldRoomLayer:refreshGameList()
	LoadingLayer:removeLoading()
	self:showFangjian()
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
	self.super.onExit(self)

	self:unBindEvent()
end

function CreateGoldRoomLayer:getRootIndex()
	local targetNodeID = 0
	local VipRoomList = globalUnit.VipRoomList
	for k,v in pairs(self.roomList) do
        --服务端配置第一个为体验场，需把体验场排除
		if k ~= 1 and VipRoomList[k-1] == 1 then
			local gold = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,v.uRoomID)
			if gold then
				if gold <= PlatformLogic.loginResult.i64Money then
					targetNodeID = k
				else
					break
				end
			end
		end
	end
	
	if targetNodeID == 0 then
		for k,v in pairs(VipRoomList) do
			if v == 1 then
				targetNodeID = k+1;--服务端配置第一个为体验场，需把体验场排除
			end
		end
	end

	return  targetNodeID
end

function CreateGoldRoomLayer:setMatchRoomCallBack(func)
	self.m_pMatchRoomCallBack = func
end

function CreateGoldRoomLayer:setCloseCreateRoomCallBack(func)
	self.m_pCloseCallBack = func
end

function CreateGoldRoomLayer:enterGame(sender)
	if type(sender) == "number" then
		globalUnit.iRoomIndex = sender
	else
		globalUnit.iRoomIndex = sender:getTag()
	end	
	
	if GamesInfoModule:findGameName(self.m_selectedNameID) == nil then
		-- addScrollMessage("暂未开放!")
		dispatchEvent("requestGameList")
		return
	end

	local mRoomId = {118,119,120};
	self.m_selectedRoomID = mRoomId[globalUnit.iRoomIndex]--self.roomList[globalUnit.iRoomIndex].uRoomID
	
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
	-- if self.roomList[globalUnit.iRoomIndex] == nil then
	-- 	dispatchEvent("requestGameList")
	-- 	return
	-- end

	GameCreator:setCurrentGame(self.m_selectedNameID)

	

	luaPrint("m_selectedRoomID == "..self.m_selectedRoomID)

	local gold = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID)
	if gold then
		self:getMatchRoomMinRoomKey(gold,"最低需要"..goldConvert(gold).."金币以上！")
	else
		local msg = {}
		msg.iNameID = self.m_selectedNameID
		msg.iRoomID = self.m_selectedRoomID
		PlatformLogic:send(PlatformMsg.MDM_GP_DESK_LOCK_PASS, PlatformMsg.ASS_GET_MIN_ROOM_KEY_NUM, msg, PlatformMsg.MSG_GP_MATCH_ROOM_MIN_ROOM_KEY)
	end

	local vipLayer = display.getRunningScene():getChildByName("VipHallLayer")
	if  vipLayer then
		globalUnit.nowTingId = vipLayer.nowTingId;
	end
end

function CreateGoldRoomLayer:getMatchRoomMinRoomKey(data,msg)
	self.m_nMatchMinRoomKey = data
	globalUnit.nMinRoomKey = data

	self:showCreateRoomLayer(msg)
end

function CreateGoldRoomLayer:showCreateRoomLayer(msg)
	if PlatformLogic.loginResult.i64Money < self.m_nMatchMinRoomKey then
		-- GamePromptLayer:create():showPrompt(GBKToUtf8(msg))
		addScrollMessage("抱歉，您的金币低于入场最低限制"..string.format("%.2f",goldConvert(globalUnit.nMinRoomKey)).."，不能进入该游戏房间！")
		showBuyTip();
		return
	end

	self:setBtnEnabled(true)

	if self.m_pMatchRoomCallBack then
		Hall.showTextState("正在加载房间信息",10,function() self:setBtnEnabled() end)
		self.m_pMatchRoomCallBack()
	else
		dispatchEvent("matchRoom",self.m_selectedRoomID)--其他游戏调用此行代码
		globalUnit.selectedRoomID = self.m_selectedRoomID;
		-- Hall:selectedGame(Hall:getCurGameName())--斗地主特殊
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

function CreateGoldRoomLayer:onClick(sender)
	local tag = sender:getTag()

	if tag == 1 then
		-- addScrollMessage("正在开发")
		local layer = require("dezhoupuke.HelpLayer"):create();
    	self:addChild(layer,gameZorder);
	elseif tag == 2 then
		Hall:exitGame()
	elseif tag == 3 then--快速开始
		self:quickStart()
	end
end

function CreateGoldRoomLayer:quickStart()
	local tag = self:getRootIndex()

	self:enterGame(tag)
end

function CreateGoldRoomLayer:receiveExitCreateRoom(data)
	if data == nil then
		self:resetViewPos()

		self:playEffect()
	end
end

function CreateGoldRoomLayer:resetViewPos()
	local y = 130;
	local x = {76+446,816+87,867-267,906-624}

	self.topImage:setPositionY(self.topImage:getPositionY()+y)
	self.bottomNode:setPositionY(self.bottomNode:getPositionY()-y)

	for k,v in pairs(self.layoutBtn) do
		if v[1] then
			v[1]:setPositionX(v[1]:getPositionX()+x[k]+winSize.width/2)
		end
		
		if v[2] then
			v[2]:setPositionX(v[2]:getPositionX()+x[k]+winSize.width/2)
		end
	end

	self.isPlayEffect = false
end

function CreateGoldRoomLayer:playEffect()
	if self.isPlayEffect == true then
		return;
	end

	self.isPlayEffect = true

	local y = 130
	local unit = 30
	local delay = {0,5,8,14}
	local pos1 = {-76-479,-816-152,241-867,612-906}
	local pos2 = {479-446,152-66,292-241,648-612}
	local pos3 = {0,66-87,267-292,624-648}

	local dt1 = {6,6,8,10}
	local dt2 = {4,6,8,10}
	local dt3 = {0,9,11,16}

	local dt = -winSize.width/2*dt1[1]/pos1[1]

	for k,v in pairs(self.layoutBtn) do
		local seq = cc.Sequence:create(
			cc.DelayTime:create(delay[k]/unit),
			cc.MoveBy:create((dt1[k]+dt)/unit,cc.p(pos1[k]-winSize.width/2,0)),
			cc.MoveBy:create(dt2[k]/unit,cc.p(pos2[k],0)),
			cc.MoveBy:create(dt3[k]/unit,cc.p(pos3[k],0))
		)

		if v[1] then
			v[1]:runAction(seq)
		end

		if v[2] then
			v[2]:runAction(seq:clone())
		end
	end

	local seq = cc.Sequence:create(
		cc.DelayTime:create(7/unit),
		cc.MoveBy:create(15/unit,cc.p(0,-y-20)),
		cc.MoveBy:create(3/unit,cc.p(0,20))
	)
	self.topImage:runAction(seq)

	local seq = cc.Sequence:create(
		cc.DelayTime:create(7/unit),
		cc.MoveBy:create(15/unit,cc.p(0,y+20)),
		cc.MoveBy:create(3/unit,cc.p(0,-20))
	)
	self.bottomNode:runAction(seq)
end

return CreateGoldRoomLayer
