
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
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
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x17da,4,REASON_COST) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x17da,4,REASON_COST)
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
	return rp==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,8)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local dice_count=0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetLabel(tp)
	e2:SetOperation(s.diceop)
	Duel.RegisterEffect(e2,tp)

	for i=1,2 do
		local d1_1,d1_2,d1_3,d1_4=Duel.TossDice(tp,4)
		local d2_1,d2_2,d2_3,d2_4=Duel.TossDice(1-tp,4)
		local sum1=d1_1+d1_2+d1_3+d1_4
		local sum2=d2_1+d2_2+d2_3+d2_4
		if sum1<sum2 then
			Duel.Damage(tp,1000,REASON_EFFECT)
		elseif sum2<sum1 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local tc=g:GetFirst()
			while tc do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(-200)
				tc:RegisterEffect(e3)
				tc=g:GetNext()
			end
			if i==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g2:GetCount()>0 then
					Duel.Destroy(g2,REASON_EFFECT)
				end
			end
		end
	end
	e2:Reset()

	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.NegateActivation(ev)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.diceop(e,tp,eg,ep,ev,re,rp)
	local c=e:GetHandler()
	local obj_tp=e:GetLabel()
	if ep==obj_tp then
		if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_CARD,0,id)
			local dc={Duel.GetDiceResult()}
			for i=1,2 do
				local min_dice=999
				local min_idx=1
				for j=1,4 do
					if dc[j] and dc[j]<min_dice then
						min_dice=dc[j]
						min_idx=j
					end
				end
				if min_dice<6 then
					dc[min_idx]=6
				else
					break
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


这个卡名的卡在1回合只能发动1张。这张卡发动的回合，自己不是「收尾人」怪兽不能特殊召唤。
①：对方把卡的效果发动时，把自己场上4个「光芒」指示物取除才能发动。双方各自投掷4个骰子并重复2次（可以把自己投掷出的2个最低数目作为6适用）。以是哪方投掷出来的合计数目较低来对应以下效果适用。那之后，可以把那次发动无效并破坏。
●自己较低的场合：自己受到1000伤害。
●对方较低的场合：选对方场上1张卡破坏。


轮盘重工的产品，巨剑。分量很重，即便是罗兰、安吉丽卡这样的高阶收尾人也需要双手持握，多用来砸击与格挡。



DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）


]]
