
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x17da)
	c:SetCounterLimit(0x17da,5)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.addcounterop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,73101486)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x16da))
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetValue(1)
	--c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	--c:RegisterEffect(e6)

end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.thfilter1(c)
	return (c:IsCode(73101400) or c:IsCode(73101402)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.addcounterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x17da)<5 then
		c:AddCounter(0x17da,2)
	end
end
function s.thfilter2(c)
	return c:IsSetCard(0x16da) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,0,0,4)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c:GetCounter(0x17da)
	if ct<5 then
		local add=math.min(4,5-ct)
		c:AddCounter(0x17da,add)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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



这张卡规则上也当作「收尾人」卡使用。
这个卡名的③的效果1回合只能使用1次，「“安吉丽卡”，漆黑噤默」以及「“罗兰”,漆黑噤默」的②的效果1回合只能有其中1张卡来使用1次。
①：这张卡特殊召唤的场合适用。给这张卡放置2个「光芒」指示物（最多5个）
②：自己·对方准备阶段才能发动。给这张卡放置4个「光芒」指示物，从卡组·墓地把1张「工坊」卡加入手卡。
③：这张卡在手卡存在的场合才能发动。从卡组把1张「认知阻碍面具」或者「「手套」」加入手卡。那之后，这张卡送去墓地。
④：只要这张卡在怪兽区域存在，自己·对方回合自己可以把「工坊」魔法·陷阱卡从手卡发动。



“这是我喜欢的诗句。它帮助我接纳痛苦，而不是试图摆脱。”


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）



]]