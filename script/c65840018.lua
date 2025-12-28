--大阿卡那 浮光月影
function c65840018.initial_effect(c)
	--aux.AddCodeList(c,65842060)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),nil,nil,aux.Tuner(nil),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840018,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65840018.poscon)
	e1:SetTarget(c65840018.postg)
	e1:SetOperation(c65840018.posop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c65840018.immval)
	c:RegisterEffect(e2)
end
function c65840018.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function c65840018.posfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanTurnSet()
end
function c65840018.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65840018.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c65840018.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c65840018.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65840018.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c65840018.immval(e,re)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and re:GetActivateLocation()==LOCATION_MZONE
		and (rc:IsRelateToEffect(re) and rc:IsAttackPos() or not rc:IsRelateToEffect(re) and rc:IsPreviousPosition(POS_ATTACK))
end
