--炽天武装的呼声
function c10701060.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701060)
	e1:SetTarget(c10701060.sptg)
	e1:SetOperation(c10701060.spop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701060,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,10701061)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c10701060.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701060.negtg)
	e2:SetOperation(c10701060.negop)
	--c:RegisterEffect(e2)   
end
function c10701060.spfilter(c,e,tp,thchk)
	return ((c:IsSetCard(0x7cf) and c:IsType(TYPE_MONSTER)) or (thchk and c:IsType(TYPE_TUNER))) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c10701060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local thchk=Duel.IsEnvironment(56433456)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701060.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,thchk) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701060.spop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701060.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,thchk):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10701060.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsType(TYPE_SYNCHRO) and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c10701060.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10701060.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end