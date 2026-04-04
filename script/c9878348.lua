--银月鬼杀大式神-九尾六津
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877864,9877870)
    --synchro summon
	aux.AddSynchroProcedure(c,cm.cck,aux.NonTuner(cm.cck),1,1)
	c:EnableReviveLimit()
    --
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(0x04)
	e2:SetTargetRange(0x04,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
    --set
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
    --set
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m*10)
    e4:SetCondition(cm.recon)
	e4:SetTarget(cm.retg)
	e4:SetOperation(cm.reop)
	c:RegisterEffect(e4)
end

function cm.cck(c)
    return aux.IsCodeListed(c,9877864)
end

function cm.indtg(e,c)
	return aux.IsCodeListed(c,9877864) and c:IsRace(RACE_DRAGON+RACE_WARRIOR)
end

function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(0x1)
end

function cm.tgsfilter(c,e,tp)
    return aux.IsCodeListed(c,9877864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x30,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.tgsfilter,tp,0x30,0,1,1,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsCode(9877870) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function cm.tgrfilter(c,tp)
    return c:IsType(0x6) and c:IsAbleToRemoveAsCost(tp,POS_FACEDOWN)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgrfilter,tp,0,0x0c,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,0x0c)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgrfilter,tp,0,0x0c,1,1,nil,tp)
    if #g>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end
end