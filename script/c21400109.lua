--与奸奇的约会
function c21400109.initial_effect(c)
	c:SetSPSummonOnce(21400109)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3210),1) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400109,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,21400109) 
	e1:SetCondition(c21400109.spcon)
	e1:SetTarget(c21400109.sptg)
	e1:SetOperation(c21400109.spop)
	c:RegisterEffect(e1)  
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e) 
	return Duel.GetFlagEffectLabel(e:GetHandlerPlayer(),21400109)*1000 end)
	c:RegisterEffect(e1)
	if not c21400109.global_check then
		c21400109.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TOSS_COIN)
		ge1:SetOperation(c21400109.checkop)
		Duel.RegisterEffect(ge1,0) 
	end 
end
function c21400109.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local flag=Duel.GetFlagEffectLabel(tp,21400109)
	if flag==nil then 
		Duel.RegisterFlagEffect(rp,21400109,RESET_PHASE+PHASE_END,0,1,1)  
	else 
		Duel.SetFlagEffectLabel(rp,21400109,flag+1) 
	end 
end
function c21400109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21400109.spfilter(c,e,tp)
	return c:IsSetCard(0x3210) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400109.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21400109.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21400109.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21400109.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21400109.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


