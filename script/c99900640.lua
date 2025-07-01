--探寻一线的希望
function c99900640.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99900640+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99900640.cost)
	e1:SetTarget(c99900640.target)
	e1:SetOperation(c99900640.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(99900640,ACTIVITY_SUMMON,c99900640.counterfilter)
	Duel.AddCustomActivityCounter(99900640,ACTIVITY_NORMALSUMMON,c99900640.counterfilter)
	Duel.AddCustomActivityCounter(99900640,ACTIVITY_SPSUMMON,c99900640.counterfilter)
	Duel.AddCustomActivityCounter(99900640,ACTIVITY_FLIPSUMMON,c99900640.counterfilter)
	Duel.AddCustomActivityCounter(99900640,ACTIVITY_ATTACK,c99900640.counterfilter)
end
function c99900640.counterfilter(c)
	return c:IsSetCard(0x676)
end
function c99900640.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99900640,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(99900640,tp,ACTIVITY_NORMALSUMMON)==0 
		and Duel.GetCustomActivityCount(99900640,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(99900640,tp,ACTIVITY_FLIPSUMMON)==0 
		and Duel.GetCustomActivityCount(99900640,tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99900640.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c99900640.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x676)
end
function c99900640.cfilter(c)
	return c:IsCode(99900640) and c:IsFaceup()
end
function c99900640.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())==0 and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)==Duel.GetMatchingGroupCount(c99900640.cfilter,tp,LOCATION_SZONE,0,nil) then
		e:GetHandler():RegisterFlagEffect(99900640,RESET_CHAIN,0,1)
	end
		local ct=1 if e:GetHandler():GetFlagEffect(99900640)>0 then ct=5 end
		local g=Duel.GetMatchingGroup(c99900640.thfilter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c99900640.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c99900640.thfilter(c)
	return c:IsCode(99900190,99900200,99900210,99900230,99900220) and c:IsAbleToHand()
end
function c99900640.activate(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.GetFirstMatchingCard(c99900640.filter,tp,LOCATION_DECK,0,nil,99900190)
	local t2=Duel.GetFirstMatchingCard(c99900640.filter,tp,LOCATION_DECK,0,nil,99900200)
	local t3=Duel.GetFirstMatchingCard(c99900640.filter,tp,LOCATION_DECK,0,nil,99900210)
	local t4=Duel.GetFirstMatchingCard(c99900640.filter,tp,LOCATION_DECK,0,nil,99900230)
	local t5=Duel.GetFirstMatchingCard(c99900640.filter,tp,LOCATION_DECK,0,nil,99900220)
		local g=nil if e:GetHandler():GetFlagEffect(99900640)>0 
		then g=Group.FromCards(t1,t2,t3,t4,t5) 
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=Duel.SelectMatchingCard(tp,c99900640.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	end
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
	end
	local tc=g:GetFirst()
	while tc do
		--special summon
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_HAND)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCondition(c99900640.spcon)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end

function c99900640.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end