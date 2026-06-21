
local s,id,o=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+651464)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+9556)
	e3:SetTarget(s.sttg)
	e3:SetOperation(s.stop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x16da) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re and rp==1-tp) then return false end
	if ev<2 then return false end
	local te,pr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT),Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	if not te or not pr then return false end
	local tc=pr:GetHandler()
	return tc:IsSetCard(0x16da) and tc:IsControler(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x16da) and c:IsCanOverlay(tp,LOCATION_DECK) end,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101486) and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(function(c) return c:IsCode(73101488) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
			and not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and (c:IsCode(73101486) or c:IsCode(73101488)) end,tp,LOCATION_MZONE,0,1,nil)
		return b1 or b2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=0
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101486) and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(function(c) return c:IsCode(73101488) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and (c:IsCode(73101486) or c:IsCode(73101488)) end,tp,LOCATION_MZONE,0,1,nil) then
		op=aux.SelectFromOptions(tp,
			{Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x16da) and c:IsCanOverlay(tp,LOCATION_DECK) end,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101486) and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,nil),aux.Stringid(id,3),1},
			{not Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and (c:IsCode(73101486) or c:IsCode(73101488)) end,tp,LOCATION_MZONE,0,1,nil),aux.Stringid(id,4),2})
	elseif Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x16da) and c:IsCanOverlay(tp,LOCATION_DECK) end,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101486) and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,nil) then
		op=1
	else
		op=2
	end
	e:SetLabel(op)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0x16da) and c:IsAbleToDeck() end,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local xyz=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsCode(73101486) and c:IsType(TYPE_XYZ) end,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			if xyz then
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				Duel.Overlay(xyz,g)
			end
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(73101488) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end







--[[
...................赛博佛祖驱散电子BUG...................
					   _oo0oo_					  
					  o8888888o					 
					  88" . "88					 
					  (| -_- |)					 
					  0\  =  /0					 
					___/‘---’\___				   
				  .' \|	   |/ '.				 
				 / \\|||  :  |||// \				
				/ _||||| -卍-|||||_ \			   
			   |   | \\\  -  /// |   |			  
			   | \_|  ''\---/''  |_/ |			  
			   \  .-\__  '-'  ___/-. /			  
			 ___'. .'  /--.--\  '. .'___			
		  ."" ‘<  ‘.___\_<|>_/___.’ >’ "".		  
		 | | :  ‘- \‘.;‘\ _ /’;.’/ - ’ : | |		
		 \  \ ‘_.   \_ __\ /__ _/   .-’ /  /		
	 =====‘-.____‘.___ \_____/___.-’___.-’=====	 
					   ‘=---=’					  
..................本来无BUG，何必常修改................


这个卡名的卡在1回合只能发动1张，这个卡名的①②③的效果1回合各能使用1次。
①：作为这张卡的发动时的效果处理，可以从卡组把1张「工坊」卡加入手卡。
②：对方连锁自己的「工坊」卡的效果的发动把魔法·陷阱·怪兽的效果发动时才能发动。从卡组把1张「工坊」卡加入手卡。
③：自己·对方准备阶段才能发动。从以下效果选1个适用。
●从墓地把1张「工坊」卡在自己场上的「“罗兰”,漆黑噤默」超量怪兽下面重叠作为超量素材。
●自己场上没有「“罗兰”,漆黑噤默」或者「“安吉丽卡”,漆黑噤默」存在的场合，从手卡·墓地把1只「“安吉丽卡”，漆黑噤默」在自己场上特殊召唤。

安吉丽卡过去使用的手套。可以从异空间中取出预先储存的武器，以应对不同战况。手套还可以消去附近的声音，战斗时只会留下武器的挥动声，“漆黑噤默”也由此得名。


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）




]]