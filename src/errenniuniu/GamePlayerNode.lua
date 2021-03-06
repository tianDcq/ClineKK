local GamePlayerNode = class("GamePlayerNode", function() return display.newNode(); end)

--isShow表示的玩家信息是否影藏
function GamePlayerNode:ctor(userId, seatNo,tableLayer)
    self:initData();

    local uiTable = {
            Text_name = "Text_name",
            AtlasLabel_money = "AtlasLabel_money",
            Image_zhuang = "Image_zhuang",
            AtlasLabel_resultMoney_win = "AtlasLabel_resultMoney_win",
            AtlasLabel_resultMoney_fail = "AtlasLabel_resultMoney_fail",
            Image_tuoguan = "Image_tuoguan",
            Image_head = "Image_head",
            Image_kuang = "Image_kuang",
        -- Panel_player = false,
        -- Image_head = false,
        -- AtlasLabel_zhuang = false,
        -- Image_zhuang = false,
        -- Image_fangzhu = false,
        -- Text_PlayerName = false,
        -- Image_PlayerSocre = false,
        -- Image_ShengyuCards = false,
        -- AtlasLabel_shengyuCards = false,
        -- Text_PlayScore = false,
        -- AtlasLabel_GongXianSocre1=false,
        -- AtlasLabel_GongXianSocre2=false,
        -- Image_tuoguan = false,
        -- Button_change = false,
        -- Image_you = false,
        -- Button_HeadFramekuang = false,
        -- Text_PlayerId = false,
    }

    self.userInfo.userId = userId or INVALID_USER_ID;
    self.seatNo = seatNo;
    self.tableLayer = nil
    if tableLayer then
        self.tableLayer = tableLayer;
    end

    --loadCsb(self,"errenniuniu/PlayerHead",uiTable)
    loadNewCsb(self,"errenniuniu/PlayerHead",uiTable)
    self:initUI()
    -- pNode:addChild(self.view)
end

--展示动画
function GamePlayerNode:showScoreAni(score)
    --self:showScore();
    local pos  = cc.p(self.AtlasLabel_resultMoney_win:getPositionX(),self.AtlasLabel_resultMoney_win:getPositionY());
    local node;
    local str = ""
    if score >=0 then
        node = self.AtlasLabel_resultMoney_win;
        str = "+"..numberToString2(score)
    else
        node = self.AtlasLabel_resultMoney_fail;
        str = numberToString2(score)
    end
    node:setString(str);
    node:setVisible(true);

    local moveTo = cc.MoveTo:create(1.0,cc.p(pos.x,pos.y+50));
    local fadeOut = cc.FadeOut:create(1.0)
    local fadein = cc.FadeIn:create(0.1)
    node:runAction(cc.Sequence:create(cc.Spawn:create(moveTo,fadeOut),cc.CallFunc:create(function ()
            -- body
            node:setPosition(pos);
            node:setVisible(false);
        end),fadein));
end


-- function GamePlayerNode:setPlayInfoButton()
--     if self.seatNo == 0 then
--         self.Image_PlayerSocre:setPosition(cc.p(160,35)); 
--     elseif self.seatNo == 2 then
--         self.Button_change:setPosition(cc.p(-85,0));
--         self.Image_PlayerSocre:setPosition(cc.p(160,70));
--         self.Image_ShengyuCards:setPosition(cc.p(160,38));
--         self.Image_you:setPosition(cc.p(74.14,-63.62));
--     elseif self.seatNo == 3 then
--         self.Image_you:setPosition(cc.p(-74.14,63.62));
--     end

-- end

-- function GamePlayerNode:setRePlayInfoButton()
--     if self.seatNo == 0 then
--         self.Image_ShengyuCards:setPosition(cc.p(160,35));
--     elseif self.seatNo == 1 then
--         self.Image_ShengyuCards:setPosition(cc.p(50,-5));
--     elseif self.seatNo == 2 then
--         self.Image_ShengyuCards:setPosition(cc.p(160,50));
--         self.Image_you:setPosition(cc.p(74.14,-63.62));
--     else
--         self.Image_ShengyuCards:setPosition(cc.p(50,-5));
--         self.Image_you:setPosition(cc.p(-74.14,63.62));
--     end

-- end

function GamePlayerNode:initUI()
    self:setUserName("");
    self:setUserMoney(0);
    self:setBank(false);
    self:hideScore();
    self:hideTuoguan(false);
    --self:setTime(15);
end

function GamePlayerNode:hideScore()
    self.AtlasLabel_resultMoney_win:setVisible(false);
    self.AtlasLabel_resultMoney_fail:setVisible(false);
end

function GamePlayerNode:showScore()
    self.AtlasLabel_resultMoney_win:setVisible(true);
    self.AtlasLabel_resultMoney_fail:setVisible(true);
end


function GamePlayerNode:hideTuoguan(istrue)
    self.Image_tuoguan:setVisible(istrue);
    self.tuoguan = istrue
end

-- function GamePlayerNode:setHeadCallBack()
--     --头像上的按钮
--     if self.Button_HeadFramekuang then
--         self.Button_HeadFramekuang:setListener(function() self:onHeadCallBack(); end)
--     end
-- end

function GamePlayerNode:initData()
    self.Image_head = nil;
    self.AtlasLabel_zhuang = nil;
    self.Image_fangzhu = nil;
    self.Text_PlayerName = nil;
    self.AtlasLabel_PlayerScore = nil;
    self.Text_GongXianSocre=nil;
    self.Image_zhuang = nil;
    self.Image_PlayerSocre = nil;

    self.tabelLayer = nil;
    self.userInfo = {};

    self.Player_Empty           = "PlayerHead/room_default_none.png";                --//无人
    self.Player_Cut             = "PlayerHead/duanx.png";                            --//掉线
    self.Name_Local_Head_Pic    = "PlayerHead/local_head_01";                        --//默认头像

    self._bDestion = INVALID_DESKSTATION;
    self._bMan = true;
    self._dwIp = 0;
    self._cardNum = 0;--牌的张数
    self.bUserCutState = false;
    self.tuoguan = false;
end

-- function GamePlayerNode:onClickSetCallBack()
--     if self.tableLayer then
--         self.tableLayer:changeSeatNo(self.seatNo);
--         self.tableLayer:hideAllChangeButton();
--     end
-- end

-- function GamePlayerNode:onHeadCallBack()
--      if self.tableLayer then
--          self.tableLayer:headCallBack(self.seatNo);
--          --self.tableLayer:hideAllChangeButton();
--      end
--     luaPrint("点击我头像干嘛？")
-- end

function GamePlayerNode:setSeatNo(seatNo)
    self.seatNo = seatNo;
end

function GamePlayerNode:setPlayerId()
    self.Text_PlayerId:setVisible(true);
    self.Text_PlayerId:setText("ID:"..self.userInfo.userId);
end

-- function GamePlayerNode:setHidePlayerId()
--     self.Text_PlayerId:setVisible(false);
-- end

-- function GamePlayerNode:setImageScore(istrue)
--     self.Image_PlayerSocre:setVisible(istrue)
-- end

-- function GamePlayerNode:setButton_change(istrue)
--     if self.Button_change == nil then
--         return 
--     end

--     self.Button_change:setVisible(istrue)
-- end

function GamePlayerNode:setScale(s)
    self.Panel_player:setScale(s)
end

function GamePlayerNode:setUserId(userId)
    self.userInfo.userId = userId;
end

function GamePlayerNode:getUserId()
    return self.userInfo.userId;
end

--设置空头像
function GamePlayerNode:setEmptyHead()
    if self.Image_head == nil then
        luaPrint("头像对象为空");
        return;
    end
    luaPrint("setEmptyHead");
    self.Image_head:loadTexture("errenniuniu/bg/sprite.png");
    --如果是匹配场的话就设置默认头像
    -- if self.isShow == false then
    --     self.Image_head:loadTexture(self.Name_Local_Head_Pic)
    -- end

    -- if self.Image_zhuang then
    --     self.Image_zhuang:setVisible(false);
    -- end

    -- if self.AtlasLabel_zhuang then
    --     self.AtlasLabel_zhuang:setVisible(false);
    -- end
end

--设置掉线头像
function GamePlayerNode:setCutHead()
    luaPrint("setCutHead");
    if self.Image_head == nil then
        luaPrint("头像对象为空");
        return;
    end
    self.Image_head:loadTexture("head/duanx.png");
    self.bUserCutState = true;
end

function GamePlayerNode:setTime(ft)
    local left = cc.ProgressTimer:create(cc.Sprite:create("bg/jishikuang.png")) 
    left:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    -- 设置显示位置
    left:setPosition(cc.p(99/2, 101/2))
    local to1 = cc.ProgressFromTo:create(ft, 100,0)
    -- 运行动作
    left:runAction(cc.Repeat:create(to1,1))
    left:setReverseDirection(true)
    -- 添加到层当中
    self.Image_kuang:addChild(left)

end

function GamePlayerNode:removeTime()
    if self.Image_kuang then
        self.Image_kuang:removeAllChildren();
    end
end

function GamePlayerNode:setHead(logoId, UserID,bBoy)
    if self.Image_head == nil then
        luaPrint("头像对象为空");
        return;
    end

    self.Image_head:loadTexture(getHeadPath(logoId,bBoy));

    -- if INVALID_USER_ID == logoId or INVALID_USER_ID == UserID then 
    --     return;
    -- end
    -- self.bUserCutState = false;
    -- local name = self.Name_Local_Head_Pic..".png";

    --  --如果是匹配场的话就设置默认头像
    -- if isShow == false then
    --     --self.isShow = isShow;
    --     self.Image_head:loadTexture(self.Name_Local_Head_Pic..".png")
    --     return
    -- end

    -- if logoId >= 45 then
    --     if PlatformLogic.loginResult.dwUserID == UserID then
    --         local savePath = cc.FileUtils:getInstance():getWritablePath();
    --         name = savePath.."head"..UserID..".png";

    --         if not cc.FileUtils:getInstance():isFileExist(name) then
    --             name = self.Name_Local_Head_Pic..".png";
    --             HeadManager:requestHttp(UserID, self.Image_head, 10);
    --         end
    --     else
    --         name = self.Name_Local_Head_Pic..".png";
    --         HeadManager:requestHttp(UserID, self.Image_head, 10);
    --     end
    -- end

    -- if not isEmptyString(name) then-- name ~= nil and name ~= "" then
    --     luaPrint("头像设置了 -- name : "..name)
    --     self.Image_head:loadTexture(name);
    -- else
    --     luaPrint("头像设置了 empty -- name : "..name)
    --     self:setEmptyHead();
    -- end

end



--设置用户分数
function GamePlayerNode:setUserMoney(money)
    if self.AtlasLabel_money == nil or money == nil then
        luaPrint("分数对象为空");
        return;
    end

    self.AtlasLabel_money:setString(numberToString2(money));

end

--设置用户贡献分数
-- function GamePlayerNode:setUserGongXianMoney(money)
--     if self.AtlasLabel_GongXianSocre1 == nil or self.AtlasLabel_GongXianSocre2==nil then
--         luaPrint("贡献分数对象为空");
--         return;
--     end
    
--     self.AtlasLabel_GongXianSocre1:setVisible(true)
--     self.AtlasLabel_GongXianSocre2:setVisible(true)
--     --通过判断玩家的输赢分数来显示相应的颜色
--     if  money  > 0 then
--         self.AtlasLabel_GongXianSocre1:setText(money);
--         self.AtlasLabel_GongXianSocre2:setVisible(false);
--     else
--         self.AtlasLabel_GongXianSocre2:setText(money);
--         self.AtlasLabel_GongXianSocre1:setVisible(false);
--     end
--     --如果是东边的玩家需要对其调整位置
--     if self.seatNo == PokerCommonDefine.Poker_Seat_Mark.Poker_East then
--         self.AtlasLabel_GongXianSocre1:setPosition(cc.p(-82,0));
--         self.AtlasLabel_GongXianSocre2:setPosition(cc.p(-82,0));
--     end
--     -- self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function() self.AtlasLabel_GongXianSocre1:setVisible(false); end),cc.CallFunc:create(function() self.AtlasLabel_GongXianSocre2:setVisible(false); end)));
--     --通过其不同的对象，消失相应的显示ui
--     if  self.AtlasLabel_GongXianSocre2 then  
--         self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function() self.AtlasLabel_GongXianSocre2:setVisible(false); end)));
--     end
--     if self.AtlasLabel_GongXianSocre1  then
--         self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function() self.AtlasLabel_GongXianSocre1:setVisible(false); end)));
--     end
-- end


function GamePlayerNode:getUserMoney()
    if self.Text_PlayScore == nil then
        luaPrint("分数对象为空");
        return "";
    end

    return self.Text_PlayScore:getText();
end

-- --剩余牌张数
-- function GamePlayerNode:setUserCardCount(count)
--     self._cardNum = count;

--     if self.AtlasLabel_shengyuCards == nil then
--         luaPrint("牌数量对象为空");
--         return;
--     end

--     self.AtlasLabel_shengyuCards:setText(count);
-- end

-- function GamePlayerNode:getUserCardCount()
--     -- return self._cardNum;
--     local text = self.AtlasLabel_shengyuCards:getText();
--     if text == nil or text == "" then
--         return 0;
--     end

--     return tonumber(text);
-- end

-- --设置用户分数显示隐藏
-- function GamePlayerNode:showUserMoney(visible)
--     if self.Text_PlayScore == nil then
--         luaPrint("分数对象为空");
--         return;
--     end
--     -- luaPrint("玩家分数 : "..self.Text_PlayerScore:getText().." , visible "..tostring(visible))
--     self.Text_PlayScore:setVisible(visible);

--     -- self.AtlasLabel_PlayScore.view:setColor(cc.c3b(255, 0, 0))
--     -- self.AtlasLabel_PlayerScore.view:setPosition(100,100)
--     self.Image_PlayerSocre:setVisible(visible);
-- end


function GamePlayerNode:getHeadPosition()
    --return self.Image_head:getCenterPosition();
end

function GamePlayerNode:setTableUI(parent)
    self.tabelLayer = parent;
end

function GamePlayerNode:setUserName(name)
    if self.Text_name == nil then
        luaPrint("昵称对象为空");
        return;
    end

    self.userInfo.nickName = name;

    if name ~= nil and name ~= "" then
        if device.platform == "android" or device.platform == "ios" then
            name = FormotGameNickName(name,6)
        end
        self.Text_name:setString(name);
        self.Text_name:setVisible(true);
    else
        self.Text_name:setString("");
    end
end

function GamePlayerNode:getUserName()

    return self.userInfo.nickName;
end

-- --房主
-- function GamePlayerNode:setMaster(bMaster)
--     if self.Image_fangzhu then
--         self.Image_fangzhu:setVisible(bMaster);
--     end
-- end

--//设置庄家
function GamePlayerNode:setBank(bBanker, iBankerNum)
    luaPrint("设置庄家",bBanker);
    if self.Image_zhuang then
        self.Image_zhuang:setVisible(bBanker);
    end
end

function GamePlayerNode:setDestion(bDestion)
    self._bDestion = bDestion;
end

function GamePlayerNode:setMan(bMan)
    self._bMan = bMan;
end

function GamePlayerNode:setIP(dwIP)
    self._dwIp = dwIP;
end

function GamePlayerNode:setPlayerCard(num)
    self:AtlasLabel_shengyuCards(num);
end

--托管标致
function GamePlayerNode:setTruteeMask(station)
    --luaPrint("设置托管头像函数进来了")

    self.Image_tuoguan:setVisible(station);
   --  local node = self:getChildByTag(100)
   --  if tableLayer.m_bAutomaticCard == false then
   --      if node then
   --          node:removeFromParent()
   --      end
   --  end
   -- -- 托管头像
   --  if node then 
   --      node:setVisible(true)
   --  else
   --      --luaPrint("设置托管头像")
   --      local label = ccui.ImageView:create("PlayerHead/tuoguan-zi.png");
   --      label:setTag(100)
   --      self:addChild(label);
   --  end

end

return GamePlayerNode
