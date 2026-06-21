
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,73101486)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.counterfilter(c)
	return c:IsSetCard(0xa797)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x17da,2,REASON_COST) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x17da,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0xa797)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.thfilter1(c)
	return c:IsSetCard(0x16da) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return (c:IsSetCard(0x16da) or aux.IsCodeOrListed(c,73101486)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,6)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,200)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetLabel(tp)
	e2:SetOperation(s.diceop)
	Duel.RegisterEffect(e2,tp)

	local d1_1,d1_2,d1_3=Duel.TossDice(tp,3)
	local d2_1,d2_2,d2_3=Duel.TossDice(1-tp,3)
	local sum1=d1_1+d1_2+d1_3
	local sum2=d2_1+d2_2+d2_3

	e2:Reset()

	if sum1<sum2 then
		Duel.Damage(tp,200,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif sum2<sum1 then
		Duel.NegateEffect(ev)
	end
	if Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.diceop(e,tp,eg,ep,ev,re,rp)
	local c=e:GetHandler()
	local obj_tp=e:GetLabel()
	if ep==obj_tp then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_CARD,0,id)
			local dc={Duel.GetDiceResult()}
			local min_dice=999
			local min_idx=1
			for i=1,3 do
				if dc[i] and dc[i]<min_dice then
					min_dice=dc[i]
					min_idx=i
				end
			end
			if min_dice<6 then
				dc[min_idx]=6
				Duel.SetDiceResult(table.unpack(dc))
			end
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




这个卡名的卡在1回合只能发动1张。这张卡发动的回合，自己不是「收尾人」怪兽不能特殊召唤。
①：对方把怪兽的效果发动时，把自己场上2个「光芒」指示物取除才能发动。双方各自投掷3个骰子（可以把自己投掷出的最低数目作为6适用）。以是哪方投掷出来的合计数目较低来对应以下效果适用。那之后，从卡组把1张「工坊」卡或者有「“罗兰”,漆黑噤默」记述的卡加入手卡。
●自己较低的场合：自己受到200伤害，从墓地把1张「工坊」卡加入手卡。
●对方较低的场合：那个效果无效。


墨工坊的产品，太刀，带有刀鞘。能释放多重剑气，曾被罗兰用坏过。


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）


]]