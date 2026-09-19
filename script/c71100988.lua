-- 形而上学的狄拉克海 (71100988)
-- 场地魔法
-- DoItYourself —— 「神奥传说」by：RTSJ
-- Script —— by：AI

local this,id,ofs=GetID()
function this.initial_effect(c)
    aux.AddCodeList(c,71100992)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(this.activate)
    c:RegisterEffect(e1)
    -- ②：怪兽区域卡移动时除外
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_MOVE)
    e2:SetCountLimit(1)
    e2:SetCondition(this.rmcon)
    e2:SetTarget(this.rmtg)
    e2:SetOperation(this.rmop)
    c:RegisterEffect(e2)
    -- ③：帕路奇犽不受相同纵列以外的卡的效果影响
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(this.immtg)
    e3:SetValue(this.immval)
    c:RegisterEffect(e3)
end

-- ====== ①：发动时检索 ======
function this.mschk(c)
    return c:IsCode(71100992) and c:IsFaceup()
end
function this.filter(c,tp)
    if Duel.IsExistingMatchingCard(this.mschk,tp,LOCATION_ONFIELD,0,1,nil) 
        and c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,71100992) 
        and c:IsAbleToHand() and c:IsFaceupEx() then
        return true
    end
    return c:IsCode(71100992) and c:IsAbleToHand() and c:IsFaceupEx()
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(this.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,tp)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end

-- ====== ②：怪兽区域移动时除外 ======
function this.rmconfilter(c,tp,re)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_MZONE)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp)
end

function this.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(this.rmconfilter,1,nil,tp,re)
end

function this.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end

function this.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end

-- ====== ③：帕路奇犽不受相同纵列以外的卡的效果影响 ======
function this.immtg(e,c)
    return c:IsCode(71100992) and c:IsFaceup()
end

function this.immval(e,c)
	return c and not c:GetBattleTarget():GetColumnGroup():IsContains(c)
end
