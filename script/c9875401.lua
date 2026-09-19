--放置少女不能输的对决
local m=9875401
local cm=_G["c"..m]

function cm.initial_effect(c)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e3:SetCost(cm.csuspcost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
    Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
end

function cm.counterfilter(c)
	return c:IsSetCard(0xda3a)
end

function cm.csuspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.csusplimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function cm.csusplimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xda3a)
end

function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3a) and c:IsControlerCanBeChanged()
end

function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xda3a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,0x01,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,1-tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,0x01,0,1,nil,e,tp) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0x01,0,1,1,nil,e,tp)
        local gc=g:GetFirst()
        if gc and Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
            gc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
            --activate limit
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetCode(EFFECT_CANNOT_ACTIVATE)
            e1:SetLabelObject(gc)
            e1:SetTargetRange(1,1)
            e1:SetValue(cm.aclimit)
            e1:SetCondition(cm.accon)
            Duel.RegisterEffect(e1,tp)
        end
	end
end

function cm.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_LINK)
end

function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(m)~=0
end
