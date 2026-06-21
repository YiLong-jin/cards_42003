
local s,id,o=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.costfilter(c)
	return c:IsSetCard(0x16da) and c:IsAbleToDeck()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0x17da,3,REASON_COST)
			and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,9,nil)
	end
	Duel.RemoveCounter(tp,1,0,0x17da,3,REASON_COST)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,4)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<9 then return end
	local tg=Group.CreateGroup()
	for i=1,9 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		g:RemoveCard(tc)
		tg:AddCard(tc)
		local same=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,tc:GetCode())
		g:Sub(same)
	end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)

	local dice_count=0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetLabel(tp)
	e2:SetOperation(s.diceop)
	Duel.RegisterEffect(e2,tp)

	local d1_1,d1_2,d1_3,d1_4=Duel.TossDice(tp,4)
	local d2_1,d2_2,d2_3,d2_4=Duel.TossDice(1-tp,4)
	local sum1=d1_1+d1_2+d1_3+d1_4
	local sum2=d2_1+d2_2+d2_3+d2_4

	e2:Reset()

	if sum2<sum1 then
		Duel.Destroy(Duel.GetFieldGroup(1-tp,LOCATION_ONFIELD,0),REASON_EFFECT)
	end

	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
end
function s.diceop(e,tp,eg,ep,ev,re,rp)
	local c=e:GetHandler()
	local obj_tp=e:GetLabel()
	if ep==obj_tp then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_CARD,0,id)
			local dc={Duel.GetDiceResult()}
			for i=1,4 do
				if dc[i] then
					dc[i]=6
				end
			end
			Duel.SetDiceResult(table.unpack(dc))
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



这个卡名的卡在1回合只能发动1张。
①：对方卡的效果发动时，把自己场上3个「光芒」指示物取除才能发动。把自己墓地9张卡名不同的「工坊」卡回到持有者卡组，双方各自投掷4个骰子（可以把自己投掷出的所有数目作为6适用）。那之后，那次发动无效并破坏。
●自己较低的场合：
●对方较低的场合：对方场上的卡全部破坏。


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）



]]