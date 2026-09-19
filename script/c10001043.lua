 --以血肉一瞬灿若天上繁星之造物人偶
local s,id,o=GetID()
local SET_HZ=0x7fe0
function s.initial_effect(c)

	c:EnableReviveLimit()
	--aux.AddFusionProcFunRep2(c,s.monfilter,2,2,false)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,SET_HZ),s.monfilter,true)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.monfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_EFFECT)
end
function s.relfilter(c)
	return c:IsSetCard(SET_HZ) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4) and c:IsReleasable()
end
function s.oppfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return false end
	local g=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_MZONE,0,c)
	local og=Duel.GetMatchingGroup(s.oppfilter,tp,0,LOCATION_MZONE,nil)
	return g:GetCount()>0 and og:GetCount()>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_MZONE,0,c)
	local og=Duel.GetMatchingGroup(s.oppfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local t1=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local t2=og:Select(tp,1,1,nil)
	local t=t1:Clone()
	t:Merge(t2)
	t:KeepAlive()
	e:SetLabelObject(t)
	return true
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end