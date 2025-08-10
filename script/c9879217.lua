--核心列车 毁灭冲击
c9879217.hxlc=true
function c9879217.initial_effect(c)

	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(9879217,1)) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetCountLimit(1,9879217+EFFECT_COUNT_CODE_OATH)   
	e1:SetTarget(c9879217.actg2) 
	e1:SetOperation(c9879217.acop2) 
	c:RegisterEffect(e1)

	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,9879217,EVENT_SPSUMMON_SUCCESS)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879217,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(custom_code)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1879217)
	e3:SetLabelObject(e0)
	e3:SetCondition(c9879217.matcon)
	e3:SetTarget(c9879217.mattg)
	e3:SetOperation(c9879217.matop)
	c:RegisterEffect(e3)
end
function c9879217.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRankAbove(10) 
end 
function c9879217.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879217.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c9879217.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 


function c9879217.cfilter(c,e,se)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeEffectTarget(e) and (se==nil or c:GetReasonEffect()~=se)
end
function c9879217.matcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c9879217.cfilter,1,nil,e,se)
end
function c9879217.tgfilter(c,eg,tp)
	return eg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSummonPlayer(tp)
end
function c9879217.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9879217.tgfilter(chkc,eg,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9879217.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg,tp)
		and e:GetHandler():IsCanOverlay() end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9879217.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,eg,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9879217.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
