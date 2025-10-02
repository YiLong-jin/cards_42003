--超可爱执行者·花草女 D
function c65846910.initial_effect(c)
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846910,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65846910.cost)
	e1:SetTarget(c65846910.sptg)
	e1:SetOperation(c65846910.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846910,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65846910)
	e2:SetCost(c65846910.cost)
	e2:SetTarget(c65846910.cptg)
	e2:SetOperation(c65846910.cpop)
	c:RegisterEffect(e2)
end
c65846910.SetCard_ZJ_CKAZXZ=true
function c65846910.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65846910.spfilter(c,e,tp)
	return c.SetCard_ZJ_CKAZXZ and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65846910.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846910.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,65846910)==0 end
	Duel.RegisterFlagEffect(tp,65846910,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65846910.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c65846910.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65846910.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65846910.splimit(e,c)
	return not c.SetCard_ZJ_CKAZXZ
end
function c65846910.cpfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(true,true,false)~=nil
end
function c65846910.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c65846910.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65846910.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c65846910.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c65846910.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c65846910.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler().SetCard_ZJ_CKAZXZ
end