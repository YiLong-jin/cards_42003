--一番合戦初命·斗皇
function c9879423.initial_effect(c)
	aux.AddCodeList(c,9879421)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9879421,c9879423.fusfilter2,2,true,true)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9879423.sprcon)
	e2:SetTarget(c9879423.sprtg)
	e2:SetOperation(c9879423.sprop)
	c:RegisterEffect(e2)
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879423,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9879423)
	e3:SetTarget(c9879423.destg)
	e3:SetOperation(c9879423.desop)
	c:RegisterEffect(e3)

	 local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9879423,0))
	e13:SetCategory(CATEGORY_DESTROY)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1879423)
	e13:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e13:SetCost(c9879423.discost)
	e13:SetTarget(c9879423.destg1)
	e13:SetOperation(c9879423.desop1)
	c:RegisterEffect(e13)
	
end
function c9879423.fusfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c9879423.cfilter(c)
	return c:IsFaceup() and c:GetOriginalRace()&RACE_ZOMBIE~=0 and c:GetOriginalAttribute()&ATTRIBUTE_FIRE~=0
end
function c9879423.sprfilter(c,tp,sc)
	local eqc=c:GetEquipGroup():FilterCount(c9879423.cfilter,nil)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR) and eqc==2 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9879423.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c9879423.sprfilter,1,REASON_SPSUMMON,false,nil,tp,c)
end
function c9879423.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(c9879423.sprfilter,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c9879423.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	c:SetMaterial(Group.FromCards(tc))
	Duel.Release(tc,REASON_SPSUMMON)
end


function c9879423.spfilter(c,e,tp)
	return c:IsCode(9879421) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9879423.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c9879423.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c9879423.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879423.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end



function c9879423.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9879423.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879423.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9879423.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9879423.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9879423.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end