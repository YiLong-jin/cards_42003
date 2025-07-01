--超天斎 神奈川级自走波能炮
local cm,m,offset=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x17dc)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),aux.NonTuner(Card.IsRace,RACE_PYRO),1)
	c:EnableReviveLimit()
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
	--Add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
end
function cm.srfilter(c)
	return c:IsSetCard(0x7dc) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then
		e:GetHandler():AddCounter(0x17dc,1)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x17dc)>0 end
	local ct=e:GetHandler():GetCounter(0x17dc)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x17dc,ct,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end
	local ct=e:GetLabel()
	local cate=0
	if ct>0 then 
		cate=cate+CATEGORY_DAMAGE 
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
	end
	if ct>2 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then 
		cate=cate+CATEGORY_DESTROY 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	end
	if ct>4 and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 then 
		cate=cate+CATEGORY_REMOVE 
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
	end
	e:SetCategory(cate)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 then 
		Duel.Damage(1-tp,ct*400,REASON_EFFECT)
	end
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if ct>2 and #dg>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=dg:Select(tp,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end 
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
	if ct>4 and #rg>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=rg:Select(tp,1,1,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end 
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if ct>6 and #hg>0 then 
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=hg:Select(tp,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end 
end
