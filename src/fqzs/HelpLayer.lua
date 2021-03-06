
local HelpLayer = class("HelpLayer",PopLayer)
local nameId = 40014000;

function HelpLayer:create()
    return HelpLayer.new();
end

function HelpLayer:ctor()
    self.super.ctor(self, PopType.middle);

    self:pushGlobalEventInfo("ASS_GP_GET_RAT",handler(self, self.refreshGameRat))
    self:initUI()
end

function HelpLayer:initUI()
   self.sureBtn:removeSelf()
   SettlementInfo:sendGameRat(nameId);
   
    local title = ccui.ImageView:create("common/guizeTitle.png")
    title:setPosition(self.size.width/2,self.size.height-50)
    self.bg:addChild(title)


    self.ScrollView_list = ccui.ListView:create();
    self.ScrollView_list:setAnchorPoint(cc.p(0.5,0.5));
    self.ScrollView_list:setDirection(ccui.ScrollViewDir.vertical);
    self.ScrollView_list:setBounceEnabled(true);
    self.ScrollView_list:setContentSize(cc.size(943, 410));
    self.ScrollView_list:setPosition(cc.p(self.size.width*0.5,self.size.height*0.50+5));
    self.bg:addChild(self.ScrollView_list);

    local guize = ccui.ImageView:create("fqzs/guize/guize_fqzs.png");
    
    local layout = ccui.Layout:create();
    -- layout:setContentSize(cc.size(943, 600));
    layout:setContentSize(cc.size(self.ScrollView_list:getContentSize().width, guize:getContentSize().height))

    local size = layout:getContentSize()
    guize:setPosition(size.width/2,size.height/2)
    -- guize:setPosition(470,300);
         
    layout:addChild(guize);
            
    self.ScrollView_list:pushBackCustomItem(layout);
end

function HelpLayer:refreshGameRat(data)
    local data = data._usedata;
    if data.NameID ~= nameId or data.Rat == 0 then
        return;
    end

    local text_tips = self.bg:getChildByName("text_tips");
    if text_tips then
        text_tips:removeFromParent();
    end

    local text_tips = ccui.Text:create("每局游戏结算将收取盈利部分的"..(data.Rat/10).."%作为服务费。",FONT_PTY_TEXT,20);
    text_tips:setName("text_tips");
    text_tips:setPosition(cc.p(90,80))
    text_tips:setAnchorPoint(0,0.5);
    self.bg:addChild(text_tips);
    if globalUnit.nowTingId > 0 then
        text_tips:setVisible(false)
    end

end

return HelpLayer
