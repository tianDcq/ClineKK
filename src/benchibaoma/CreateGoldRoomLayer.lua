--金币房
local CreateGoldRoomLayer = class("CreateGoldRoomLayer", BaseWindow)
local CreateRoomHistory = require("benchibaoma.CreateRoomHistory");

function CreateGoldRoomLayer:create(gameName)
	return CreateGoldRoomLayer.new(gameName)
end

function CreateGoldRoomLayer:ctor(gameName)
	self.super.ctor(self, 0, true)

	self.gameName = gameName

	self:initData()

	self:initUI()

	self:bindEvent()

	addSound();

	self:hide()
end

function CreateGoldRoomLayer:refreshUI(data)
	local data = data._usedata

	self:removeAllChildren()

	self:initData(1)

	self:initUI()

	--初始化界面信息
	for k,v in pairs(self.btns) do
		local DeskID = v:getTag();
		local InitMsg = {
			BasicRoomInfo = {
				NameID = self.m_selectedNameID,
				RoomID = self.m_selectedRoomID,
				OnlineUser = 0,
				RoomMinScore = -1,
				GameStation = 23,
				LeftTime = 0,
	 			ChangeTime = 0,
				NowTime = 0,
				DeskID = DeskID,
			},
			RecordCount = 0,
		};

		self:roomLayerCreate(InitMsg,k);
	end

	self:show()
end

function CreateGoldRoomLayer:initData(flag)
	if flag == nil then--构造函数里调用才做
		self.m_selectedNameID = 0
		self.m_selectedRoomID = 0
	end

	self.btns = {}
	self.layouts = {}

	self.lzMsg = {};
	self.lzLayer = {};
end

function CreateGoldRoomLayer:initGameData()
	local gameList = GamesInfoModule:findGameList("game")

	self.gameList = gameList or {}
	-- luaDump(self.gameList)

	table.sort(self.gameList, function(a,b) return a.uNameID < b.uNameID end)
end

function CreateGoldRoomLayer:initUI()
	local winSize = cc.Director:getInstance():getWinSize()

	local bg = ccui.ImageView:create("game/roombg.png")
	bg:setPosition(winSize.width/2,winSize.height/2)
	self:addChild(bg)
	self.bg = bg

	local size = bg:getContentSize()

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

	local top = ccui.ImageView:create("hall/titleBg1.png")
	top:setAnchorPoint(0.5,1)
	top:setPosition(size.width/2,size.height)
	bg:addChild(top)
	self.topImage = top

	local title = ccui.ImageView:create("createRoom/title.png")
	title:setPosition(top:getContentSize().width/2,top:getContentSize().height/2+5)
	top:addChild(title)

	--退出
	local btn = ccui.Button:create("game/fanhui.png","game/fanhui-on.png")
	btn:setAnchorPoint(1,1)
	btn:setPosition(1419.5+(winSize.width-1280)/2, top:getContentSize().height)
	btn:setTag(2)
	top:addChild(btn)
	btn:onClick(handler(self, self.onClick))

	--规则
	local btn1 = ccui.Button:create("hall/guize.png","hall/guize-on.png")
	btn1:setPosition(199.5-(winSize.width-1280)/2, top:getContentSize().height/2+5)
	btn1:setTag(1)
	top:addChild(btn1)
	btn1:onClick(handler(self, self.onClick))
	-- local node = require("layer.popView.UserInfoNode"):create()
	-- node:setPosition(top:getContentSize().width*0.4,top:getContentSize().height*0.65)
	-- top:addChild(node)

	if globalUnit.bIsSelectDesk == false then
		local listView = ccui.ListView:create()
		listView:setAnchorPoint(cc.p(0,0))
		listView:setDirection(ccui.ScrollViewDir.horizontal)
		listView:setBounceEnabled(true)
		listView:setContentSize(cc.size(winSize.width,480))
		listView:setPosition((1559-winSize.width)/2,100)
		listView:setScrollBarEnabled(false)
		listView:setClippingEnabled(false)
		self.bg:addChild(listView)
		self.listView = listView

		local layoutWidth = (winSize.width - 380*2)/2;
		if layoutWidth<0 then
			layoutWidth = 0;
		end

		local layout = ccui.Layout:create()
		layout:setContentSize(cc.size(layoutWidth, self.listView:getContentSize().height))
		self.listView:pushBackCustomItem(layout)

		for i=1,2 do -- 3
			local layout = self:createRoomGroup(i,5)
			self.listView:pushBackCustomItem(layout)
		end
	else
		self.layoutSize = cc.size(614,244)
		local btns = {}
		for i = 1,2 do
		 	for j = 1,2 do
				local luziBg = ccui.ImageView:create("game/luziBg2.png")
				luziBg:setAnchorPoint((2-j),0);
				luziBg:setPosition(size.width/2,(luziBg:getContentSize().height-20)*(2-i)+0+10*(2-i));
				self.bg:addChild(luziBg)

				local layout = ccui.Layout:create()
				layout:setContentSize(self.layoutSize)
				layout:setAnchorPoint(0.5,0);
				layout:setPosition(luziBg:getContentSize().width/2,19)
				luziBg:addChild(layout)

				table.insert(self.layouts,layout)

				local btn = ccui.Button:create("game/jinruyouxi.png","game/jinruyouxi-on.png")
				btn:setPosition(588,138);
				luziBg:addChild(btn)
				btn:onClick(handler(self,self.sitDwon))
				table.insert(btns,btn)
			end
		 end

		for k,v in pairs(btns) do
			v:setTag(k-1)
		end
		self.btns = btns;

		-- -- local btn = ccui.Button:create("game/tiyanchang.png","game/tiyanchang-on.png")
		-- -- btn:setPosition(x-btn:getContentSize().width/2-100,btn:getContentSize().height/2)
		-- -- btn:setTag(2)
		-- -- self.bg:addChild(btn)
		-- -- btn:onClick(handler(self,self.enterGame))
		-- -- btn:setVisible(false);

		btn1 = btn
		local btn = ccui.Button:create("game/shuaxinchangci.png","game/shuaxinchangci-on.png")
		btn:setPosition(btn1:getPositionX()-btn1:getContentSize().width/2-120,top:getContentSize().height/2)
		btn:setTag(2)
		top:addChild(btn)
		btn:onClick(handler(self,self.refreshLuzi))
		btn:hide()
		self.refreshBtn = btn
	end
end

function CreateGoldRoomLayer:createRoomGroup(groupId,num)
	if groupId > num then
		return;
	end
	local layout = ccui.Layout:create()
	layout:setContentSize(cc.size(380,self.listView:getContentSize().height))

	local temp = {}

	local node = self:createItem(groupId);
	layout:addChild(node);
	node:setPosition(layout:getContentSize().width/2,layout:getContentSize().height/2);
	table.insert(temp,node);

	return layout
end

function CreateGoldRoomLayer:createItem(tag)
	local ruchang = {"50.00","50.00"}

	local btn = ccui.Button:create("createRoom/"..tag..".png","createRoom/"..tag.."-on.png")
	btn:setTag(tag-1)
	btn:onClick(handler(self, self.enterGame))

	local size = btn:getContentSize()

	local image = ccui.ImageView:create("createRoom/type"..tag..".png")
	image:setPosition(size.width/2,190)
	btn:addChild(image)

	local difen = FontConfig.createWithSystemFont(ruchang[tag].."入场",25)
	difen:setPosition(size.width/2,size.height/2-135)
	btn:addChild(difen)
	difen:setColor(cc.c3b(255,225,146));


	return btn
end

function CreateGoldRoomLayer:onEnter()
	self.super.onEnter(self)
end

function CreateGoldRoomLayer:onEnterTransitionFinish()
	self:showFangjian()
	self.super.onEnterTransitionFinish(self)
	iphoneXFit(self.mask,4)
end

function CreateGoldRoomLayer:showFangjian()
	local VisibleCount = 0

	self:initGameData()

	VisibleCount = #self.gameList

	if VisibleCount == 0 then
		LoadingLayer:createLoading(FontConfig.gFontConfig_22, GBKToUtf8("正在请求游戏列表,请稍后"), LOADING):removeTimer()
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
				if self.touchLayer then
					self.touchLayer:removeSelf()
					self.touchLayer = nil
				end

				--if globalUnit.bIsSelectDesk == true then
					self:enterGame(1,true)

					--初始化界面信息
					for k,v in pairs(self.btns) do
						local DeskID = v:getTag();
						local InitMsg = {
							BasicRoomInfo = {
								NameID = self.m_selectedNameID,
								RoomID = self.m_selectedRoomID,
								OnlineUser = 0,
								RoomMinScore = -1,
								GameStation = 23,
								LeftTime = 0,
					 			ChangeTime = 0,
								NowTime = 0,
								DeskID = DeskID,
							},
							RecordCount = 0,
						};

						self:roomLayerCreate(InitMsg,k);
					end
				--end
			end
		else
			luaPrint(self.gameName.." 在游戏列表中 名字异常！")
			addScrollMessage("进入游戏失败！")
			self:delayCloseLayer(0)
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

	self:pushGlobalEventInfo("ASS_ZTW_GAMERECORED",handler(self, self.onGameRecoredCallback))
	self:pushGlobalEventInfo("ASS_ZTW_CHANGEGAMESTATION",handler(self, self.onChangeMestationCallback))
	self:pushGlobalEventInfo("exitGameBackPlatform",handler(self, self.exitGameBackPlatform))
	self:pushGlobalEventInfo("I_P_M_Login",handler(self, self.onReceiveLogin))--断线重连刷新

	self:pushGlobalEventInfo("roomLoginFail",handler(self, self.onRoomLoginFail))--断线重连刷新
	self:pushGlobalEventInfo("showRoomLuzi",handler(self,self.refreshUI))
end

function CreateGoldRoomLayer:unBindEvent()
	if self.bindIds == nil or (type(self.bindIds) == "table" and next(self.bindIds) == nil) then
		return
	end

	for _, bindid in pairs(self.bindIds) do
		Event:unRegisterListener(bindid)
	end
end

function CreateGoldRoomLayer:onExit()
	self.super.onExit(self)

	self:unBindEvent()
end

function CreateGoldRoomLayer:refreshLuzi(sender)
	addScrollMessage("刷新场次成功");
	self:CreateLzLayer();
end

function CreateGoldRoomLayer:enterGame(sender,isAutoEnter)
	RoomLogic:close()
	local tag = sender

	if type(sender) ~= "number" then
		tag = sender:getTag()
	end

	if not self.roomList[1] then
		dispatchEvent("requestGameList")
		return
	end

	globalUnit.mSelectDesk = tag;

	self.m_selectedRoomID = self.roomList[1].uRoomID
	luaPrint("m_selectedNameID == "..self.m_selectedNameID,self.m_selectedRoomID)

	if GamesInfoModule:findGameName(self.m_selectedNameID) == nil then
		dispatchEvent("requestGameList")
		return
	end

	GameCreator:setCurrentGame(self.m_selectedNameID)

	local gold = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID);

	if gold then
		globalUnit:setEnterGameID(self.m_selectedNameID.."_"..self.m_selectedRoomID)
		self:getMatchRoomMinRoomKey(gold,"最低需要"..goldConvert(gold).."金币以上！",isAutoEnter)
	else
		local msg = {};
		msg.iNameID = self.m_selectedNameID
		msg.iRoomID = self.m_selectedRoomID
		PlatformLogic:send(PlatformMsg.MDM_GP_DESK_LOCK_PASS, PlatformMsg.ASS_GET_MIN_ROOM_KEY_NUM, msg, PlatformMsg.MSG_GP_MATCH_ROOM_MIN_ROOM_KEY);
		self:delayCloseLayer(0)
	end
end

function CreateGoldRoomLayer:sitDwon(sender)
	local tag = sender:getTag()
	--判断金币是否携带够
	-- for k,v in pairs(self.lzMsg) do
	-- 	if v.BasicRoomInfo.NameID == self.m_selectedNameID and 
	-- 		v.BasicRoomInfo.RoomID == self.m_selectedRoomID and 
	-- 		v.BasicRoomInfo.DeskID == tag then--找到桌子
	-- 			globalUnit.nMinRoomKey = v.BasicRoomInfo.RoomMinScore;

	-- 			if PlatformLogic.loginResult.i64Money < globalUnit.nMinRoomKey then
	-- 				addScrollMessage("抱歉，您的金币低于入场最低限制"..string.format("%.2f",goldConvert(globalUnit.nMinRoomKey)).."，不能进入该游戏！")
	-- 				showBuyTip()
	-- 				return
	-- 			else
	-- 				dispatchEvent("selectDesk",tag)
	-- 				break;
	-- 			end		
	-- 	end 

	-- end

	globalUnit.nMinRoomKey = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID);
	if PlatformLogic.loginResult.i64Money < globalUnit.nMinRoomKey then
		addScrollMessage("抱歉，您的金币低于入场最低限制"..string.format("%.2f",goldConvert(globalUnit.nMinRoomKey)).."，不能进入该游戏！")
		showBuyTip(globalUnit.bIsSelectDesk == false);
		return;
	else
		dispatchEvent("selectDesk",tag)
	end
end

function CreateGoldRoomLayer:getMatchRoomMinRoomKey(data,msg,isAutoEnter)
	self.m_nMatchMinRoomKey = data
	globalUnit.nMinRoomKey = data

	self:showCreateRoomLayer(msg,isAutoEnter)
end

function CreateGoldRoomLayer:showCreateRoomLayer(msg,isAutoEnter)
	if isAutoEnter == nil then
		if PlatformLogic.loginResult.i64Money < self.m_nMatchMinRoomKey then
			addScrollMessage("抱歉，您的金币低于入场最低限制"..string.format("%.2f",goldConvert(globalUnit.nMinRoomKey)).."，不能进入该游戏房间！")
			showBuyTip(not self:isVisible())
			return
		end
	end

	self:setBtnEnabled(true)

	if self.m_pMatchRoomCallBack then
		Hall.showTextState("正在加载房间信息",10,function() self:setBtnEnabled() end)
		self.m_pMatchRoomCallBack()
	else
		globalUnit.selectedRoomID = self.m_selectedRoomID
		LoadingLayer:createLoading(FontConfig.gFontConfig_22, GBKToUtf8("正在加载房间信息,请稍后"), LOADING):removeTimer()

		performWithDelay(self,function() dispatchEvent("matchRoom",{self.m_selectedRoomID,true}) end,0.5);
	end
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
		display.getRunningScene():addChild(require("benchibaoma.PopUpLayer"):create());
	elseif tag == 2 then
		Hall:exitGame()
	end
end

function CreateGoldRoomLayer:loginRoom(event)
	local runningScene = display.getRunningScene()

	if runningScene:getChildByTag(1111111) then
		runningScene:removeChildByTag(1111111)
	end

	self:setBtnEnabled()
end


function CreateGoldRoomLayer:onGameRecoredCallback(data)
	local data = data._usedata;

	local handeCode = data:getHead(4);

	local cf = {
	    {"BasicRoomInfo",RoomMsg.MSG_GP_S_BASIC_ROOMINFO},
	    {"RecordCount","INT"},
	    {"pData","BYTE[30]"},
	}

	local msg = convertToLua(data,cf);

	if msg.BasicRoomInfo.RoomID ~= self.m_selectedRoomID then
		return;
	end

	luaDump(msg,"onGameRecoredCallback");

	msg.BasicRoomInfo.RoomMinScore = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID);

	local flag = false;
	for k,v in pairs(self.lzMsg) do
		if v.BasicRoomInfo.NameID == msg.BasicRoomInfo.NameID and 
			v.BasicRoomInfo.RoomID == msg.BasicRoomInfo.RoomID and 
			v.BasicRoomInfo.DeskID == msg.BasicRoomInfo.DeskID then
				self.lzMsg[k] = msg;
				flag = true;
				self:UpdateLzLayer(msg);
				break;
		end
	end

	if flag == false then
		table.insert(self.lzMsg,msg);
	end

	if handeCode == 1 then
		self.refreshBtn:setVisible(#self.lzMsg > 4)
		self:CreateLzLayer();
	end
end

function CreateGoldRoomLayer:onChangeMestationCallback(data)
	local data = data._usedata;

	local msg = convertToLua(data,RoomMsg.MSG_GP_S_BASIC_ROOMINFO);

	if msg.RoomID ~= self.m_selectedRoomID then
		return;
	end

	luaDump(msg,"onChangeMestationCallback");
	msg.RoomMinScore = RoomInfoModule:getRoomNeedGold(self.m_selectedNameID,self.m_selectedRoomID);
	--更新状态
	for k,v in pairs(self.lzMsg) do
		if v.BasicRoomInfo.DeskID == msg.DeskID then
			local state = v.BasicRoomInfo.DeskState
			v.BasicRoomInfo = msg;
			v.BasicRoomInfo.DeskState = state

			self:UpdateLzLayer(v);
		end
	end
end

--更新界面上的数据
function CreateGoldRoomLayer:UpdateLzLayer(msg)
	if self.lzLayer[msg.BasicRoomInfo.DeskID] then
		self.lzLayer[msg.BasicRoomInfo.DeskID]:UpdateLayer(msg);
	end
end

--创建单个界面
function CreateGoldRoomLayer:roomLayerCreate(data,count)
	local oldLayer = self.layouts[count]:getChildByName("CreateRoomHistory");
	if oldLayer then
		self.layouts[count]:removeChild(oldLayer);
	end

	local layer = CreateRoomHistory:create(self.layoutSize);
	layer:setTag(data.BasicRoomInfo.DeskID);
	layer:setName("CreateRoomHistory");

	layer:setPosition(0,0);

	self.layouts[count]:addChild(layer);

	layer:UpdateLayer(data);

	self.lzLayer[data.BasicRoomInfo.DeskID] = layer;
end

--创建界面
function CreateGoldRoomLayer:CreateLzLayer()
	self:ClearLzLayer();


	--重新创建
	if #self.lzMsg > 4 then
		local lzMsgClone = clone(self.lzMsg);
		local temp = {};
		for i = 1,4 do
			local randomNum = math.floor(math.random(0,#lzMsgClone))+1;

			if randomNum>#lzMsgClone then
				randomNum = #lzMsgClone;
			end

			
			table.insert(temp,lzMsgClone[randomNum]);
			table.remove(lzMsgClone,randomNum);
		end

		table.sort(temp, function(a,b) return a.BasicRoomInfo.DeskID < b.BasicRoomInfo.DeskID end)

		for k,v in pairs(temp) do
			self:roomLayerCreate(v,k);
			self.btns[k]:setTag(v.BasicRoomInfo.DeskID);

		end
	else
		for k,v in pairs(self.lzMsg) do
			self:roomLayerCreate(v,k);
			self.btns[k]:setTag(v.BasicRoomInfo.DeskID);
		end
	end
end

--清除界面
function CreateGoldRoomLayer:ClearLzLayer()
	for k,v in pairs(self.lzLayer) do
		if v then
			v:removeFromParent();
		end
	end
	self.lzLayer = {};
end

function CreateGoldRoomLayer:exitGameBackPlatform()
	if globalUnit.isTryPlay then
		self:ClearLzLayer();
		self.lzMsg={};
		self:enterGame(1)
	else
		--出来重新刷新路子界面
		for k,v in pairs(self.lzMsg) do
			if self.lzLayer[v.BasicRoomInfo.DeskID] then
				self.lzLayer[v.BasicRoomInfo.DeskID]:UpdateLayer(v);
			end
		end
	end
end

function CreateGoldRoomLayer:onReceiveLogin()
	self:ClearLzLayer();
	self.lzMsg={};
	self:stopActionByTag(666)
	self:setBtnEnabled(true)

	local func = function()
		local node = display.getRunningScene():getChildByTag(1421);

		if not node and not Hall:isHaveGameLayer() then
			globalUnit.isNoTipBack = true
			dispatchEvent("matchRoom",self.m_selectedRoomID);
		end
	end
	performWithDelay(self,func,2):setTag(666)
end

function CreateGoldRoomLayer:onRoomLoginFail()
	--判断是否有游戏界面 没有游戏界面则此界面退出
	local gameLayer = display.getRunningScene():getChildByName("gameLayer");
	if gameLayer == nil then
		Hall:exitGame()
	end
end

return CreateGoldRoomLayer
