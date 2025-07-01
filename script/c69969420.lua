--狩魂·死神
local s,id,o=GetID()
function s.initial_effect(c)
  --special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,69969413)
	e3:SetTarget(c69969420.retg1)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
--1
function s.spfilter(c,e,tp,exc)
	local b2=c:IsSetCard(0x69d) and c:IsLocation(LOCATION_EXTRA)
		and Duel.GetLocationCountFromEx(tp,tp,exc,c)>0 and c:IsType(TYPE_XYZ)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and b2
end
function s.sptgfilter(c,e,tp)
	return c:IsSetCard(0x69d)  and c:IsType(TYPE_MONSTER)
end
function s.sptgexfilter(c,e,tp,code)
	local sc=e:GetHandler()
	return  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c:IsType(TYPE_XYZ) and sc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 and c:IsSetCard(0x69d)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.sptgfilter(chkc,e,tp) end   
	if chk==0 then return aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) and Duel.IsExistingTarget(s.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.sptgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
 end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if not sc:IsRelateToChain() then return end
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if not aux.MustMaterialCheck(sc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.sptgexfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=sg:GetFirst()
	if sg:GetCount()>0 then
	Duel.Overlay(tc,c) 
	Duel.Overlay(tc,sc)
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(500)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
	Duel.Damage(tp,500,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	end
end
--2
function c69969420.retg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter1(c,tp)
	return c:IsFaceup()  and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.filter2(c)
	return c:IsCanOverlay() and c:IsSetCard(0x69d) and not c:IsCode(69969420)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.Overlay(g1:GetFirst(),g2)
	end
end