--灾难等级A-屠杀者
local cm,m=GetID()

function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
    e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    --to grave and des 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m*10)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:CheckRemoveOverlayCard(tp,1,1,REASON_COST) end
    c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsChainAttackable() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0e)
end

function cm.opdfilter(c)
    return c:IsType(0x1) or c:IsLocation(0x04)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToChain() then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c:GetAttack()*2)
		c:RegisterEffect(e1)
        Duel.ChainAttack()
        Duel.BreakEffect()
        if Duel.GetMatchingGroupCount(cm.opdfilter,tp,0x0e,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local dc=Duel.SelectMatchingCard(tp,cm.opdfilter,tp,0x0e,0,1,1,nil):GetFirst()
            if dc then
                if dc:IsLocation(0x0c) then Duel.HintSelection(Group.FromCards(dc)) end
                Duel.Destroy(dc,REASON_EFFECT)
            end
        end
    end
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end

function cm.tspfil(c)
	return c:IsFaceup() and c:IsSetCard(0x27e4) and c:IsAbleToDeck()
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tspfil,tp,0x30,0,3,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,0x30)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.tspfil,tp,0x30,0,3,5,nil)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==#g then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
