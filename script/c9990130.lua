--逐火之蛾的终局
function c9990130.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9990130,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,9990130+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c9990130.drop)
	c:RegisterEffect(e2) 

	--banana
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990130,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetCountLimit(1,9990131+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c9990130.tg2)
	e1:SetOperation(c9990130.op2)
	e1:SetCondition(c9990130.spcon)
--  e1:SetTarget(c9990130.tdtg)
--  e1:SetOperation(c9990130.tdop)
	c:RegisterEffect(e1)



--end
--function c9990130.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
--  Duel.IsExistingMatchingCard(c9990130.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
--end
end
function c9990130.filter(c)
	return c:IsFaceup() and c:IsCode(9990970)
end

function c9990130.spcon(e,c,tp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	  and Duel.IsExistingMatchingCard(c9990130.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-Duel.GetLP(1-tp)/2
end
function c9990130.filter2(c,e,tp)
	return c:IsCode(9991110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9990130.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990130.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990130.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	local g=Duel.SelectMatchingCard(tp,c9990130.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end


function c9990130.drop(e,tp,eg,ep,ev,re,r,rp)
	--remove
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTarget(c9990130.rmtg)
	e2:SetTargetRange(0xff,0xff)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(LOCATION_DECKSHF)
	Duel.RegisterEffect(e2,tp)
end
function c9990130.rmtg(e,c)
	return c:IsSetCard(0x669)
end