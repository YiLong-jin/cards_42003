--破灭的前奏曲
local cm,m=GetID()

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m*10)
    e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
end

function cm.tgdfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x27e4) and c:IsRace(RACE_INSECT)
end

function cm.tgsfilter(c,e,tp)
    return c:IsRace(RACE_REPTILE) and c:IsSetCard(0x27e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tgdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tgdfilter,tp,0x04,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x01,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,cm.tgdfilter,tp,0x04,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x01,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
        Duel.BreakEffect()
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToChain() then
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end

function cm.tgrfilter2(c)
    return c:IsSetCard(0x27e4) and c:IsType(0x1) and c:IsAbleToRemove()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgrfilter2,tp,0x10,0,2,nil) and Duel.GetFieldGroupCount(tp,0,0x04)>0 end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,0x10)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,0x04)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgrfilter2,tp,0x10,0,2,2,nil)
    if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x04,1,1,nil)
        if #dg>0 then
            Duel.HintSelection(dg)
            Duel.Destroy(dg,REASON_EFFECT)
        end
    end
end