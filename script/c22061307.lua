--☆再☆次☆发☆动☆
function c22061307.initial_effect(c)
	--宇宙
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22061307.spcon)
	c:RegisterEffect(e3)
	--宇宙2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22061307,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,220613071)
	e2:SetTarget(c22061307.target)
	--e2:SetOperation(c22061307.operation)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22061307,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22061307.discon)
	--e4:SetCondition(c22061307.rmcon)
	e4:SetCountLimit(1,220613072)
	e4:SetTarget(c22061307.target)
	--e4:SetOperation(c22061307.operation)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22061307,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c22061307.discon)
	--e4:SetCondition(c22061307.rmcon)
	e5:SetCountLimit(1,220613073)
	e5:SetTarget(c22061307.target)
	--e4:SetOperation(c22061307.operation)
	c:RegisterEffect(e5)
end
function c22061307.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetCode(22061307) and ep==tp and Duel.IsChainNegatable(ev)
end
--1效果
function c22061307.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	return g:GetCount()>=6 and g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c22061307.spfilter(c,e,tp)
	return c:IsSummonableCard() and c:IsType(TYPE_MONSTER)
end
-----------------------------------------
function c22061307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,1,nil) end
	local b1 = Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
	local b2 = Duel.GetMatchingGroup(c22061307.filters,tp,0,LOCATION_ONFIELD,nil):GetCount()>=1
	local b3 = Duel.IsExistingMatchingCard(c22061307.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)~=0
	local b4 = Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b5 = Duel.IsExistingMatchingCard(c22061307.thfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b6 = Duel.IsPlayerCanDiscardDeck(tp,3)
	local b7 = true
	local b8 = Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanSendtoDeck(tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=1
	local b9 = Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,LOCATION_MZONE,0,1,nil)
	
	if chk==0 then return b1 or b2 or b3 or b4 or b5 or b6 or b7 or b8 or b9 end
	local off=1
	local ops={}
	local opval={}
	local lps = {}
	while off<=3 do
	local t1= Duel.TossDice(tp,1)
	local t2= Duel.TossDice(tp,1)-3
	local t3= t1+t2
	
	if lps[1]==nil or (lps[2]==nil and t3~=lps[1]) or (lps[1]~=lps[2] and lps[1]~=lps[3] and lps[2]~=lps[3]) then
		if t3==1 then
			if b1 then
		ops[off]=aux.Stringid(22061307,1)
		opval[off-1]=1
		off=off+1
		end
		elseif t3==2 then
			if b2 then
		ops[off]=aux.Stringid(22061307,2)
		opval[off-1]=2
		off=off+1
		end
		elseif t3==3 then
			if b3 then
		ops[off]=aux.Stringid(22061307,3)
		opval[off-1]=3
		off=off+1
		end
		elseif t3==4 then
			if b4 then
		ops[off]=aux.Stringid(22061307,4)
		opval[off-1]=4
		off=off+1
		end
		elseif t3==5 then
			if b5 then
		ops[off]=aux.Stringid(22061307,5)
		opval[off-1]=5
		off=off+1
		end
		elseif t3==6 then
			if b6 then
		ops[off]=aux.Stringid(22061307,6)
		opval[off-1]=6
		off=off+1
		end
		elseif t3==7 then
			if b7 then
		ops[off]=aux.Stringid(22061307,7)
		opval[off-1]=7
		off=off+1
		end
		elseif t3==8 then
			if b8 then
		ops[off]=aux.Stringid(22061307,8)
		opval[off-1]=8
		off=off+1
		end
		elseif t3==9 then
			if b9 then
		ops[off]=aux.Stringid(22061307,9)
		opval[off-1]=9
		off=off+1
		end
		end
	end
------------------------------------------
	   
-----------------------------------------
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))

	-------

	if opval[op]==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw1)
		Duel.SetOperationInfo(1,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(1,CATEGORY_DRAW,nil,0,1-tp,1)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw2)
		local dg=Duel.GetMatchingGroup(c22061307.filters,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(1,CATEGORY_DISABLE,dg,1,0,0)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw3)
		local g=Duel.SelectTarget(tp,c22061307.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.SetOperationInfo(1,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif opval[op]==4 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw4)
		local g1=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(1,CATEGORY_TOHAND,g1,1,0,0)
	elseif opval[op]==5 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw5)
		local g2=Duel.SelectTarget(tp,c22061307.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(1,CATEGORY_DESTROY,g2,1,0,0)
	elseif opval[op]==6 then
		e:SetCategory(CATEGORY_DECKDES)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw6)
		Duel.SetOperationInfo(1,CATEGORY_DECKDES,nil,0,tp,3)
	elseif opval[op]==7 then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw7)
		Duel.SetOperationInfo(1,CATEGORY_DAMAGE,nil,0,1-tp,600)
		Duel.SetOperationInfo(1,CATEGORY_RECOVER,nil,0,tp,600)
	elseif opval[op]==8 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw8)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(1,CATEGORY_TODECK,nil,0,tp,1)
		Duel.SetOperationInfo(1,CATEGORY_DRAW,nil,0,tp,2)
	elseif opval[op]==9 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c22061307.draw9)
	end
----------------------------------
 
function c22061307.thfilter(c)
	return not c:IsCode(22061307) and c:IsDestructable()
end

end
function c22061307.draw1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c22061307.draw2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g4=Duel.SelectMatchingCard(tp,c22061307.filters,tp,0,LOCATION_ONFIELD,1,1,nil)
	
		--Duel.HintSelection(g4)
	   
		local c=g4:GetFirst()
		   
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
	  
end
function c22061307.draw3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g5=Duel.SelectMatchingCard(tp,c22061307.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g5:GetCount()>0 then
			Duel.SpecialSummon(g5,SUMMON_VALUE_MONSTER_REBORN,tp,tp,false,false,POS_FACEUP)
		end
end
function c22061307.draw4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g6=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g6:GetFirst()~=nil then
	Duel.SendtoHand(g6:GetFirst(),nil,REASON_EFFECT)
	end
end
function c22061307.draw5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g7=Duel.SelectTarget(tp,c22061307.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g7:GetFirst()~=nil then
	Duel.Destroy(g7:GetFirst(),nil,REASON_EFFECT)
	end
end
function c22061307.draw6(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function c22061307.draw7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,600,REASON_EFFECT,true)
	Duel.Recover(tp,600,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c22061307.draw8(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g8=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g8:GetCount()>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
		if 1==1 then
			Duel.SendtoDeck(g8,tp,REASON_EFFECT,1)
		end
	end
end
function c22061307.draw9(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g9=Duel.SelectMatchingCard(tp,Card.IsAttackable and Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		local c=g9:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(600)
		c:RegisterEffect(e2)
end
function c22061307.filters(c)
	return c:IsType(TYPE_EFFECT)
end





