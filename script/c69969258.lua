--交响曲·欢乐颂
function c69969258.initial_effect(c)
aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x69b),3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c69969258.splimit)
	c:RegisterEffect(e1)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c69969258.dircon)
	e1:SetValue(c69969258.efilter)
	c:RegisterEffect(e1)
local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69969153,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,69969248)
	e5:SetTarget(c69969258.target)
	e5:SetOperation(c69969258.operation)
	c:RegisterEffect(e5)
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(69969153,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,69969248)
	e6:SetTarget(c69969258.target)
	e6:SetOperation(c69969258.operation)
	c:RegisterEffect(e6)
local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(69969153,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,69969258)
	e7:SetCondition(c69969258.spcon2)
	e7:SetTarget(c69969258.sptg2)
	e7:SetOperation(c69969258.spop2)
	c:RegisterEffect(e7)
local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	end
--0
function c69969258.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK or se:GetHandler():IsCode(69969258)
end
--1
function c69969258.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x69b)
end
function c69969258.dircon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1
end
--2
function c69969258.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c69969258.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end

--3
function c69969258.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c69969258.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969258.spop2(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetValue(c69969258.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c69969258.eqlimit(e,c)
	return e:GetOwner()==c
end