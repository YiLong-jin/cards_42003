--交响曲·命运Ⅱ
function c69969276.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,69969152,69969153,true,true)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCondition(c69969276.hspcon)
	e7:SetOperation(c69969276.hspop)
	c:RegisterEffect(e7)
--1
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969276,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969276)
	e4:SetTarget(c69969276.destg)
	e4:SetOperation(c69969276.desop)
	c:RegisterEffect(e4)
local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_SSET+TIMING_EQUIP+TIMING_END_PHASE)
	e5:SetCondition(c69969276.rmcon2)
	c:RegisterEffect(e5)
--2
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969276,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,69969263)
	e2:SetCondition(c69969276.spcon2)
	e2:SetTarget(c69969276.sptg2)
	e2:SetOperation(c69969276.spop2)
	c:RegisterEffect(e2)
end
--0
function c69969276.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x69b) and not c:IsRace(RACE_PSYCHO)
end
function c69969276.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	return not g or not g:IsExists(c69969276.confilter,1,nil)
end
function c69969276.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup()
	return g and g:IsExists(c69969276.confilter,1,nil)
end
function c69969276.eqspfilter(c)
	return c:IsFaceup() and c:IsCode(69969153)
end
function c69969276.hspfilter(c,tp,sc)
	return c:IsCode(69969152) 
		and c:IsControler(tp) and c:GetEquipGroup():IsExists(c69969276.eqspfilter,1,nil) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
		and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c69969276.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroupEx(c:GetControler(),c69969276.hspfilter,1,REASON_SPSUMMON,false,nil,c:GetControler(),c)
end
function c69969276.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroupEx(tp,c69969276.hspfilter,1,1,REASON_SPSUMMON,false,nil,tp,c)
	c:SetMaterial(g)
	 Duel.Release(g,REASON_SPSUMMON)
end
--1
function c69969276.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c69969276.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--2
function c69969276.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c69969276.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969276.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and tc then
		Duel.BreakEffect()
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c69969276.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c69969276.eqlimit(e,c)
	return e:GetOwner()==c
end