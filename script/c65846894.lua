--超可爱执行者·主存女
function c65846894.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,65846894)
	e0:SetCondition(c65846894.spcon)
	e0:SetTarget(c65846894.sptg)
	e0:SetOperation(c65846894.spop)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95846894)
	e1:SetCost(c65846894.cost)
	e1:SetTarget(c65846894.destg)
	e1:SetOperation(c65846894.desop)
	c:RegisterEffect(e1)
end
c65846894.SetCard_ZJ_CKAZXZ=true
function c65846894.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and c.SetCard_ZJ_CKAZXZ
end
function c65846894.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65846894.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c65846894.cfilter(c)
	return c.SetCard_ZJ_CKAZXZ  and c:IsAbleToGraveAsCost()
end
function c65846894.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846894.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846894.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65846894.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c65846894.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c65846894.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846894.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.GetFlagEffect(tp,65846894)==0 end
	Duel.RegisterFlagEffect(tp,65846894,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c65846894.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65846894.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end