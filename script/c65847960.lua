--镜魔 魔法
function c65847960.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65847960+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65847960.cost)
	e1:SetTarget(c65847960.target)
	e1:SetOperation(c65847960.activate)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c65847960.reptg)
	e2:SetValue(c65847960.repval)
	e2:SetOperation(c65847960.repop)
	c:RegisterEffect(e2)
end
function c65847960.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65847960.selfilter(c,e,tp,check)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToGrave() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function c65847960.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c65847960.selfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c65847960.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c65847960.selfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check)
	if #g==0 then return end
	local tc=g:GetFirst()
	if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1191,1152)==1) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c65847960.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3e6)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c65847960.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c65847960.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c65847960.repval(e,c)
	return c65847960.repfilter(c,e:GetHandlerPlayer())
end
function c65847960.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end