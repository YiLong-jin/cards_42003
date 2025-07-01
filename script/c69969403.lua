--狩魂使×双枪
function c69969403.initial_effect(c)
	c:SetSPSummonOnce(69969403)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,c69969403.ovfilter,aux.Stringid(69969403,0))
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c69969403.descon)
	e1:SetOperation(c69969403.desop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969403,1))
	e3:SetProperty(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCost(c69969403.atkcost)
	e3:SetTarget(c69969403.destg)
	e3:SetOperation(c69969403.destop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969403,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969403)
	e4:SetTarget(c69969403.sptg)
	e4:SetOperation(c69969403.spop)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969403,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,69969403)
	e5:SetTarget(c69969403.sptg)
	e5:SetOperation(c69969403.spop)
	c:RegisterEffect(e5)	
end
--0
function c69969403.ovfilter(c)
	return c:IsFaceup() and c:IsCode(69969400)
end
--1
function c69969403.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c69969403.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
--2
function c69969403.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69969403.tdfilter(c)
	return (not aux.AtkEqualsDef(c) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsFaceup()
end
function c69969403.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c69969403.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c69969403.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c69969403.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c69969403.destop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c69969403.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--3
function c69969403.filter(c,e,tp)
	return c:IsSetCard(0x69d) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c69969403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969403.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local c=e:GetHandler()
	local g2=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69969403.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		 if tc then
		 tc:SetMaterial(nil)
		 if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		 tc:CompleteProcedure()
		 if c:IsRelateToEffect(e) and #g2>0 and tc:IsLocation(LOCATION_MZONE) then
		 Duel.Overlay(tc,g2) 
		 local c=e:GetHandler()
		 if c:IsExtraDeckMonster() then
		   Duel.BreakEffect()
		   Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
end
end
end
--3.2
function c69969403.nsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969403.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969403.nspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=c:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69969403.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
		 if tc then
		 tc:SetMaterial(nil)
		 if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		 tc:CompleteProcedure()
		 if c:IsRelateToEffect(e) and #g2>0 and tc:IsLocation(LOCATION_MZONE) then
		 Duel.Overlay(tc,g2) 
		 local c=e:GetHandler()
		 if c:IsExtraDeckMonster() then
		   Duel.BreakEffect()
		   Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
end
end
end


