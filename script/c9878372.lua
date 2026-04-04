--炎乱逆鳞斩
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
    e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
    e4:SetCondition(cm.tgcon)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
    --
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(0x02)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m*10)
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

function cm.contfilter(c,tp)
    return not c:IsCode(9878355) and c:IsPreviousLocation(0x0c) and c:IsPreviousControler(tp) and c:GetPreviousAttributeOnField()&ATTRIBUTE_LIGHT~=0 and c:GetPreviousRaceOnField()&RACE_WARRIOR~=0
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.contfilter,1,nil,tp)
end

function cm.tgtfilter(c)
    return aux.NegateMonsterFilter(c) and c:IsAbleToRemove()
end

function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,0,0x04,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,0x04)
end

function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,0,0x04,1,1,nil):GetFirst()
    if tc and tc:IsCanBeDisabledByEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        tc:RegisterEffect(e2)
        Duel.AdjustInstantly()
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
            Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
        end
    end
end

function cm.secost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() end
    Duel.SendtoGrave(c,REASON_COST)
end

function cm.tgsfilter(c,tp)
    return c:GetType()==0x40002 and (c:IsAbleToHand() or c:IsAbleToGrave()) and not (c:IsControler(1-tp) and c:IsFacedown() and not c:GetEquipTarget())
end

function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x04) and cm.conafilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.conafilter,tp,0x04,0,1,nil) and Duel.IsExistingMatchingCard(cm.tgsfilter,tp,0x0e,0x0c,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tgtfilter,tp,0x04,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,0x0e)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x31)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,0x0e)
end

function cm.opsfilter1(c)
    return c:IsAbleToHand() and not c:IsAbleToGrave()
end

function cm.opsfilter2(c)
    return c:IsAbleToGrave() and not c:IsAbleToHand()
end

function cm.opsfilter3(c)
    return c:IsAbleToGrave() and c:IsAbleToHand()
end

function cm.opsfilter4(c,tc,tp)
    return c.Kazanari_Tsubasa and c:IsType(TYPE_EQUIP) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(tc) and (c:IsLocation(0x11) or c:IsFaceup())
end

function cm.opsfilterg(g,exg)
    return g:__band(exg):GetCount()==0 and aux.dncheck(g)
end

function cm.seop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.tgsfilter,tp,0x0e,0x0c,nil,tp)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
        g=g:Select(tp,1,#g,nil)
        local thg=g:Filter(cm.opsfilter1,nil)
        local tgg=g:Filter(cm.opsfilter2,nil)
        local thtgg=g:Filter(cm.opsfilter3,nil)
        if #thtgg>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local nthtgg=thtgg:Select(tp,0,#thtgg,nil)
            thg:Merge(nthtgg)
            tgg:Merge(thtgg:__sub(nthtgg))
        end
        Duel.HintSelection(g)
        if Duel.SendtoHand(thg,nil,REASON_EFFECT) and Duel.SendtoGrave(tgg,REASON_EFFECT) then
            if thg:FilterCount(Card.IsLocation,nil,0x02) then
                Duel.ConfirmCards(1-tp,thg:Filter(Card.IsLocation,nil,0x02))
            end
            Duel.BreakEffect()
            local tc=Duel.GetFirstTarget()
            if tc:IsRelateToChain() then
                local n=math.min(g:FilterCount(Card.IsLocation,nil,0x12),Duel.GetLocationCount(tp,0x08))
                local qg=Duel.GetMatchingGroup(cm.opsfilter4,tp,0x31,0,nil,tc,tp)
                if #qg>0 and qg:CheckSubGroup(cm.opsfilterg,1,n,g) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
                    qg=qg:SelectSubGroup(tp,cm.opsfilterg,false,1,n,g)
                    for ec in aux.Next(qg) do
                        Duel.Equip(tp,ec,tc,true,true)
                        local e1=Effect.CreateEffect(e:GetHandler())
                        e1:SetType(EFFECT_TYPE_SINGLE)
                        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                        e1:SetCode(EFFECT_EQUIP_LIMIT)
                        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                        e1:SetLabelObject(tc)
                        e1:SetValue(cm.eqlimit)
                        ec:RegisterEffect(e1)
                    end
                    Duel.EquipComplete()
                end
            end
        end
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end