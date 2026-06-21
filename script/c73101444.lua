
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	--activate(spsummon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_DRAW+CATEGORY_DISABLE_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(s.condition1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(aux.NegateSummonCondition)
	c:RegisterEffect(e3)
	--activate(attack)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DICE+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_DRAW+CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(s.condition2)
	e4:SetCost(s.cost)
	e4:SetTarget(s.target2)
	e4:SetOperation(s.activate2)
	c:RegisterEffect(e4)
end
function s.counterfilter(c)
	return c:IsSetCard(0xa797)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x17da,3,REASON_COST) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x17da,3,REASON_COST)
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
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.dice_effect(e,tp,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,0,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	s.dice_effect(e,tp,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.NegateAttack()
	end
end
function s.dice_effect(e,tp,rp)
	local c=e:GetHandler()

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TOSS_DICE_NEGATE)
	e4:SetLabel(tp)
	e4:SetOperation(s.diceop)
	Duel.RegisterEffect(e4,tp)

	for i=1,4 do
		local d1_1,d1_2=Duel.TossDice(tp,2)
		local d2_1,d2_2=Duel.TossDice(1-tp,2)
		local sum1=d1_1+d1_2
		local sum2=d2_1+d2_2
		if sum1<sum2 then
			Duel.Damage(tp,100,REASON_EFFECT)
		elseif sum2<sum1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			local atk_card=g:GetFirst()
			if atk_card then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_UPDATE_ATTACK)
				e5:SetValue(-400)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				atk_card:RegisterEffect(e5)
			end
			if i==1 then
				if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
					local g2=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
					local pos_card=g2:GetFirst()
					if pos_card then
						Duel.ChangePosition(pos_card,POS_FACEDOWN_DEFENSE)
					end
				end
			elseif i==4 then
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
	e4:Reset()
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
			if min_dice<5 then
				dc[min_idx]=5
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
①：对方怪兽的攻击宣言时或者对方把怪兽召唤·特殊召唤·反转召唤之际，把自己场上3个「光芒」指示物取除才能发动。双方各自投掷2个骰子并重复4次（可以把自己投掷出的最低数目作为5适用）。以是哪方投掷出来的合计数目较低来对应以下效果适用。那之后，可以把那次攻击宣言或者特殊召唤无效。
●自己较低的场合：自己受到100伤害。
●对方较低的场合：选对方场上1只怪兽攻击力下降400，是第1次投掷骰子的场合，可以选场上1只怪兽变成里侧表示。是第4次投掷骰子的场合，自己可以抽1张卡。


卡莉斯塔工作室的产品，双刃。


DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）



]]