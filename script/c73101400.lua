local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,73101486,73101488)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+114514)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.counterfilter(c)
	return c:IsSetCard(0xa797)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
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
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101486) end,tp,LOCATION_MZONE,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id)==0)
	local b2=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,73101488)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+114514)==0)
	local b3=Duel.IsExistingMatchingCard(function(c) return c:IsCode(73101488) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0x16da))
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,id+1919810)==0)
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 or b2 or b3 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),1},
			{b2,aux.Stringid(id,2),2},
			{b3,aux.Stringid(id,3),3})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetCategory(0)
	elseif op==2 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+114514,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==3 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id+1919810,RESET_PHASE+PHASE_END,0,1)
		end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(73101486) end,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(aux.tgoval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,73101488)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==3 then
		local op1=0
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0x16da) then
			op1=Duel.SelectOption(tp,aux.Stringid(id,7),aux.Stringid(id,8))
		elseif Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then
			op1=0
		else
			op1=1
		end
		if op1==0 then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x16da)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		end
		local op2=0
		if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(73101488) end,tp,LOCATION_MZONE,0,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(id,9)) then
				op2=0
			else
				op2=1
			end
		else
			op2=0
		end
		if op2==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(73101488) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op2==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.spfilter2(c,tp)
	return c:IsFaceup() and (c:IsCode(73101486) or c:IsCode(73101488)) and c:IsControler(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter2,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
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


这张卡发动的回合，自己不是「收尾人」怪兽不能特殊召唤。
①：从以下效果选1个发动。（这个卡名的以下效果1回合各能选择1次）。
●这个回合，自己的「“罗兰”，漆黑噤默」不会成为对方的效果对象。
●从卡组把1只「“安吉丽卡”，漆黑噤默」加入手卡。
●丢弃1张手卡或者把手卡的1张「工坊」卡给对方确认才能发动。从手卡·墓地把1只「“安吉丽卡”，漆黑噤默」特殊召唤，自己场上有「“安吉丽卡”，漆黑噤默」存在的场合，也可以作为代替抽1张卡。
②：这张卡在墓地存在的场合，自己对「“罗兰”,漆黑噤默」或者「“安吉丽卡”，漆黑噤默」特殊召唤的场合才能发动。这张卡加入手卡。


“怎么了？……我觉得很好用啊？”
——被安吉丽卡拒绝使用面具的罗兰

DoItYourself——「漆黑噤默」 By 淡淡忧伤
效果参与设计 By 蓝烯/飞翔中的地龙（吉祥物）



]]
