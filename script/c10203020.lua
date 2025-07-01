--玉莲帮“赤烟”腾武
function c10203020.initial_effect(c)

   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10203020,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10203020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10203020.spcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,102030201)
	--e2:SetCost(c9742784.spcost)
	e2:SetTarget(c10203020.thtg)
	e2:SetOperation(c10203020.thop)
	c:RegisterEffect(e2)

end
function c10203020.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe79e) and c:IsType(TYPE_MONSTER)
end
function c10203020.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10203020.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
----------------------------------------------------------------------------------------------
function c10203020.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10203020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and c10203020.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c10203020.tgfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c10203020.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetAttribute()~=ATTRIBUTE_WIND
end
function c10203020.spfilter(c,e,tp)
	return c:IsCode(10203001) or c:IsSetCard(0xe79e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10203020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local hg=Duel.SelectMatchingCard(tp,c10203020.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(hg)
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
	
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10203020.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10203020.splimit)
	Duel.RegisterEffect(e1,tp)
end