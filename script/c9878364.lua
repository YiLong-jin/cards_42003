--炎鸟极翔斩
local cm,m=GetID()

--风鸣翼字段伪造
--get c.Kazanari_Tsubasa
cm.Kazanari_Tsubasa=true

function cm.initial_effect(c)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
    --
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
    e4:SetCost(cm.tgcost)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
    --
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x02)
	e1:SetCountLimit(1,m*10)
    e1:SetCondition(aux.NOT(cm.actcon))
    e1:SetCost(cm.secost)
	e1:SetTarget(cm.setg)
	e1:SetOperation(cm.seop)
	c:RegisterEffect(e1)
end

function cm.conafilter(c)
    return c:IsCode(9878355) and c:IsFaceup()
end

function cm.actcon(e)
    return Duel.IsExistingMatchingCard(cm.conafilter,e:GetHandlerPlayer(),0x04,0,1,nil)
end

function cm.costtfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end

function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costtfilter,tp,0x0c,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.costtfilter,tp,0x0c,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and cm.conafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.conafilter,tp,0x04,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tgtfilter,tp,0x04,0,1,1,nil)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>1 then
        local te,tep,teloc=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
        if te:IsActiveType(0x1) and tep~=tp and teloc&0x12~=0 then
            e:SetLabel(1)
            e:SetCategory(e:GetCategory()|CATEGORY_DISABLE)
        end
    end
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToChain() and Duel.GetLocationCount(tp,0x04,2,0)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
        Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,0x04,0,0),2))
        if e:GetLabel()==1 and Duel.IsChainNegatable(Duel.GetCurrentChain()-1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.NegateEffect(Duel.GetCurrentChain()-1)
        end
    end
end

function cm.secost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
    Duel.SendtoGrave(c,REASON_COST)
end

function cm.tgsfilter(c)
    return c:IsCode(9878355) and c:IsAbleToHand()
end

function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x11,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x11)
end

function cm.seop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x11,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end