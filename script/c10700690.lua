--孽驱君主 路西法
function c10700690.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,10700666)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10700690.slcon)
	e1:SetValue(7)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700690,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c10700690.descon)
	e3:SetTarget(c10700690.destg)
	e3:SetOperation(c10700690.desop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c10700690.immcon)
	e4:SetValue(c10700690.efilter)
	c:RegisterEffect(e4) 
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700690,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10700690)
	e5:SetCondition(c10700690.negcon)
	e5:SetTarget(c10700690.negtg)
	e5:SetOperation(c10700690.negop)
	c:RegisterEffect(e5) 
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(c10700690.regop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c10700690.damcon)
	e7:SetOperation(c10700690.damop)
	c:RegisterEffect(e7)   
end
function c10700690.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetOriginalLeftScale()==6
end
function c10700690.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700690.scfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c10700690.cfilter(c,e,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
		and (not e or c:IsRelateToEffect(e))
end
function c10700690.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10700690.cfilter,1,nil,nil,tp)
end
function c10700690.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,nil)
end
function c10700690.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(Group.FromCards(tc,c),REASON_EFFECT)
	end
end
function c10700690.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c10700690.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c10700690.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and tc:IsLocation(LOCATION_ONFIELD) and Duel.IsChainNegatable(ev)
end
function c10700690.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if e:GetHandler():IsSummonLocation(LOCATION_EXTRA) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 
		and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) then
		e:SetCategory(CATEGORY_CATEGORY_HANDES)
	end
end
function c10700690.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		if Duel.Destroy(eg,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and e:GetHandler():IsSummonLocation(LOCATION_EXTRA) and e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) 
		  and Duel.SelectYesNo(tp,aux.Stringid(10700690,3)) then
			local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c10700690.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10700690,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c10700690.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and dg and dg:IsContains(e:GetHandler()) then return false end
	return ep~=tp and c:GetFlagEffect(10700690)~=0
end
function c10700690.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10700690)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end