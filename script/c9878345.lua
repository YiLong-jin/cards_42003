--银月鬼杀御神术-奔雷
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877864)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.ckcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
    --atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(0x08)
    e2:SetTargetRange(1,0)
    e2:SetTarget(cm.attg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
    local e9=e2:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)
    --Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(0x08)
    e3:SetCountLimit(1,m)
    e3:SetCost(cm.eacost)
	e3:SetTarget(cm.eatg)
	e3:SetOperation(cm.eaop)
	c:RegisterEffect(e3)
end

function cm.ckfil(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9877864)
end

function cm.ckcon(e)
	return Duel.IsExistingMatchingCard(cm.ckfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end

function cm.tgtfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x04) and cm.tgtfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgtfilter,tp,0x04,0x04,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tgtfilter,tp,0x04,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function cm.attg(e,c)
    return aux.IsCodeListed(c,9877864) and c:IsRace(RACE_DRAGON)
end

function cm.eacost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end

function cm.tgefilter(c)
    return c:IsFaceup() and aux.IsCodeListed(c,9877864) and c:IsRace(RACE_DRAGON)
end

function cm.eatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tgefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgefilter,tp,0x04,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tgefilter,tp,0x04,0,1,1,nil)
end

function cm.eaop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
        e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end