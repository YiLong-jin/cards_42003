--交响曲·致爱丽丝
function c69969234.initial_effect(c)
c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x69b),aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),true) 
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969234,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,69969234)
	e1:SetCondition(c69969234.descon)
	e1:SetCost(c69969234.cpcost)
	e1:SetTarget(c69969234.cptg)
	e1:SetOperation(c69969234.cpop)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969234,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,69969234)
	e3:SetCondition(c69969234.discon)
	e3:SetTarget(c69969234.distg)
	e3:SetOperation(c69969234.disop)
	c:RegisterEffect(e3)
	end
function c69969234.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c69969234.cpfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x69b) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)
end
function c69969234.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
 e:SetLabel(1)
	if chk==0 then return true end
end
function c69969234.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(c69969234.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.PayLPCost(tp,2000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c69969234.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c69969234.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end


--2
function c69969234.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_MONSTER) and Duel.IsChainDisablable(ev) and re:GetHandler():IsSetCard(0x69b)
end
function c69969234.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c69969234.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end