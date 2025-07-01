--廻集归来之龍
local m=71100214
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	c:EnableReviveLimit()
	aux.AddCodeList(c,71100213)
	--spsummon condition
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_SINGLE)
	e31:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e31:SetCode(EFFECT_SPSUMMON_CONDITION)
	e31:SetValue(aux.FALSE)
	c:RegisterEffect(e31)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.ex,tp,LOCATION_EXTRA,0,nil,e,tp)
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() 
		and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 
		and c:IsLocation(LOCATION_EXTRA)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and #g>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.ex(c,e,tp)
	return c:IsCode(m-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
--Effect 2
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return   Duel.IsChainDisablable(ev) 
		and e:GetHandler():GetFlagEffect(m)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev) 
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
--Effect 3 
--Effect 4 