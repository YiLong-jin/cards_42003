
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
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
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,4)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc then return end

	local dice_count=0
	local bonus=0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetOperation(s.diceop)
	e2:SetLabel(tp)
	Duel.RegisterEffect(e2,tp)

	local obj_tp=e2:GetLabel()
	for i=1,2 do
		local d1_1,d1_2=Duel.TossDice(tp,2)
		local d2_1,d2_2=Duel.TossDice(1-tp,2)
		local sum1=d1_1+d1_2+bonus
		local sum2=d2_1+d2_2-3
		if sum1<sum2 then
			Duel.Damage(tp,300,REASON_EFFECT)
			if i==1 then
				bonus=1
			end
		elseif sum2<sum1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			local atk_card=g:GetFirst()
			if atk_card then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(-300)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				atk_card:RegisterEffect(e3)
			end
		end
	end
	e2:Reset()

	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
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
			for i=1,2 do
				if dc[i] and dc[i]<min_dice then
					min_dice=dc[i]
					min_idx=i
				end
			end
			if min_dice<3 then
				dc[min_idx]=3
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
①：把自己场上的2个「光芒」指示物取除，以对方场上1张卡为对象才能发动。双方各自投掷2个骰子并重复2次（可以把自己投掷出的最低数目作为3适用）。以是哪方投掷出来的合计数目较低（按照对方投掷出的合计数目-3来计算）来对应以下效果适用。那之后，作为对象的卡破坏
●自己较低的场合：自己受到300伤害，是第1次投掷骰子的场合，自己下次投掷骰子投掷出的合计数目按照+1来计算。
●对方较低的场合：可以选对方场上1只表侧表示的怪兽攻击力下降300。


阿拉斯工坊的产品，骑枪。


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）



]]
