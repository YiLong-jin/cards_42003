--超可爱执行者紧急事态！
function c65846907.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846907+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846907.target)
	e1:SetOperation(c65846907.operation)
	c:RegisterEffect(e1)	
end
c65846907.SetCard_ZJ_CKAZXZ=true 
function c65846907.spfilter(c,e,tp)
	return c.SetCard_ZJ_CKAZXZ and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65846907.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846907.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65846907.stfilter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65846907.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65846907.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c65846907.stfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SSet(tp,g)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(36346532,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCondition(c65846907.actcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			--g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c65846907.stfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(65846907)
end
function c65846907.filter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsFaceup()
end
function c65846907.actcon(e)
	return Duel.IsExistingMatchingCard(c65846907.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
