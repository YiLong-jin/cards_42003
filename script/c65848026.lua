--CAN：D LIVE
function c65848026.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,65847994)
	aux.AddFusionProcCodeFunRep(c,65847994,c65848026.mfilter,1,127,false,false)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65848026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65848026)
	e1:SetCondition(c65848026.spcon)
	e1:SetTarget(c65848026.sptg)
	e1:SetOperation(c65848026.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65848026,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65848026.spcon1)
	e2:SetTarget(c65848026.sptg1)
	e2:SetOperation(c65848026.spop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RECOVER)
	e3:SetCondition(c65848026.spcon2)
	c:RegisterEffect(e3)
end
function c65848026.mfilter(c)
	return c:IsRace(RACE_PSYCHO) and (c:IsLevelAbove(6) or c:IsRankAbove(6))
end
function c65848026.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65848026.spfilter(c,e,tp)
	return aux.IsCodeListed(c,65847994) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		 and Duel.GetMZoneCount(tp)>0		
end
function c65848026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65848026.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65848026.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65848026.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65848026.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c65848026.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c65848026.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c65848026.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return (b1 or b2) and Duel.GetFlagEffect(tp,65848026)==0 end
	Duel.RegisterFlagEffect(tp,65848026,RESET_PHASE+PHASE_END,0,1)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(65848026,1)},
		{b2,aux.Stringid(65848026,2)})
	e:SetLabel(op)
	if op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c65848026.spop1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==2 then
		c65848026.atkop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		c65848026.sp(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c65848026.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c65848026.spfilter1(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
				
end
function c65848026.sp(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65848026.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end