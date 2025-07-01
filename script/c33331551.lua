--天体神秘学
function c33331551.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33331551,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c33331551.con1)
	e1:SetTarget(c33331551.tg1)
	e1:SetOperation(c33331551.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33331551,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c33331551.tg3)
	e3:SetOperation(c33331551.op3)
	c:RegisterEffect(e3)
--
end
--
function c33331551.cfilter1(c,tp)
	return c:GetSummonPlayer()==1-tp and c:GetSequence()~=2
end
function c33331551.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_MZONE,2)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2
		and Duel.GetCurrentChain()==0 and eg:IsExists(c33331551.cfilter1,1,nil,tp)
end
function c33331551.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c33331551.cfilter1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c33331551.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33331551.cfilter1,nil,tp)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
--
function c33331551.tfilter3(c)
	return c:GetSequence()==2 and c:IsAbleToHand()
end
function c33331551.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33331551.tfilter3,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c33331551.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
--
