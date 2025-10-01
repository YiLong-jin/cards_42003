--极乐爱乐·最高指挥 涅基蒂亚
--移动堡垒 涅基蒂亚
local m=9990780
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)

	aux.EnablePendulumAttribute(c,false)

	--Senya.CommonEffect_3L(c,m)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)


	--pendulum
	-- 怪兽效果②：破坏时放置灵摆
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9990780,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m+2)
	e5:SetCondition(c9990780.pencon)
	e5:SetTarget(c9990780.pentg)
	e5:SetOperation(c9990780.penop)
	c:RegisterEffect(e5)

	--fusion
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990780,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(c9990780.cost)
	e1:SetTarget(c9990780.ftg)
	e1:SetOperation(c9990780.fop)
	c:RegisterEffect(e1)
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990780,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(c9990780.cost)
	e1:SetTarget(c9990780.stg)
	e1:SetOperation(c9990780.sop)
	c:RegisterEffect(e1)
	--XYZ
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990780,5))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(c9990780.cost)
	e1:SetTarget(c9990780.xtg)
	e1:SetOperation(c9990780.xop)
	c:RegisterEffect(e1)

end

function c9990780.matfilter1(c)
	return c:IsSetCard(0x671)


end
function c9990780.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9990780)==0 end
	e:GetHandler():RegisterFlagEffect(9990780,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c9990780.ffilter1(c)
	return c:IsSetCard(0x673) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9990780.ffilter2(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove() and c:IsFaceup()
end
function c9990780.ffilter3(c,e,tp)
	return c:IsSetCard(0x675) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c9990780.ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c9990780.ffilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c9990780.ffilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c9990780.ffilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c9990780.ffilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c9990780.ffilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990780.ffilter4(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c9990780.fop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c9990780.ffilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9990780.ffilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then tc:CompleteProcedure() end
	end
end
function c9990780.sfilter1(c)
	return c:IsSetCard(0x673) and c:IsType(TYPE_MONSTER)
end
function c9990780.sfilter2(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c9990780.sfilter3(c,e,tp)
	return c:IsSetCard(0x671) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9990780.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c9990780.sfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c9990780.sfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c9990780.sfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c9990780.sfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c9990780.sfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990780.sfilter4(c)
	return c:IsOnField()
end
function c9990780.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c9990780.sfilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9990780.sfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		Duel.SendtoGrave(tg,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9990780.xfilter1(c)
	return c:IsSetCard(0x673) and c:IsType(TYPE_MONSTER)
end
function c9990780.xfilter2(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c9990780.xfilter3(c,e,tp)
	return c:IsSetCard(0x672) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9990780.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
		and Duel.IsExistingTarget(c9990780.xfilter1,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c9990780.xfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c9990780.xfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c9990780.xfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c9990780.xfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990780.xfilter4(c)
	return c:IsOnField()
end
function c9990780.xop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:Filter(c9990780.xfilter4,nil):GetCount()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c9990780.xfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		local og=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst():GetOverlayGroup()
		if og:GetCount()~=0 then Duel.SendtoGrave(og,REASON_RULE) end
		Duel.Overlay(tc,tg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

























function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x673)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


-- 怪兽效果②：破坏时放置灵摆
function c9990780.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c9990780.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c9990780.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end