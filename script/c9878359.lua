--天之逆鳞
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
    e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
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

function cm.tgtfilter(c,e,tp)
    return (c:IsControler(1-tp) or (c:IsFaceup() and c:IsCode(9878355))) and c:IsCanBeEffectTarget(e)
end

function cm.tgtfilterg(g)
    return g:GetClassCount(Card.GetControler)==2
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,0x04,0x04,nil,e,tp)
    if chkc then return false end
	if chk==0 then return #g>0 and g:CheckSubGroup(cm.tgtfilterg,2,2) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    g=g:SelectSubGroup(tp,cm.tgtfilterg,false,2,2)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,nil)
    if #tg>0 then
        local tpg=tg:Filter(Card.IsControler,nil,tp)
        local opg=tg:Filter(Card.IsControler,nil,1-tp)
        if tg:CheckSubGroup(cm.tgtfilterg,2,2) then
            local tpc,opc=tpg:GetFirst(),opg:GetFirst()
            if Duel.Destroy(opc,REASON_EFFECT)~=0 then
                Duel.BreakEffect()
                if Duel.GetLocationCount(tp,0x04,2,0)>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
                    Duel.MoveSequence(tpc,math.log(Duel.SelectDisableField(tp,1,0x04,0,0),2))
                end
            else
                Duel.Destroy(tpc,REASON_EFFECT)
            end
        elseif #tpg==1 then
            Duel.Destroy(tpg,REASON_EFFECT)
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