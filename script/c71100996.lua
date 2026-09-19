-- 无限空间的不定数 (71100996)
-- 通常魔法
-- ①：以对方场上1张卡为对象才能发动。那张卡破坏。自己场上的「神奥大尊 帕路奇犽」的原本攻击力每有1500，这个效果的对象可以多1张。
-- ②：自己场上的「神奥大尊 帕路奇犽」因对方从场上离开的场合发动。那张卡和墓地的这张卡加入手卡。
local this,id,ofs=GetID()

function this.initial_effect(c)
    aux.AddCodeList(c,71100992)

    -- ①：破坏效果
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetTarget(this.tg1)
    e1:SetOperation(this.op1)
    c:RegisterEffect(e1)

    -- ②：墓地回收效果（帕路奇犽因对方离场时触发）
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+ofs)
    e2:SetCondition(this.cond2)
    e2:SetTarget(this.tg2)
    e2:SetOperation(this.op2)
    c:RegisterEffect(e2)
end

-- ====== 效果①：破坏 ======

function this.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    -- 计算可选目标数
    local maxct=1
    local palkia=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(71100992) end,tp,LOCATION_MZONE,0,nil)
    if #palkia>0 then
        local tc=palkia:GetFirst()
        local atk=tc:GetAttack()
        if atk>=1500 then
            maxct=1+math.floor(atk/1500)
        end
    end
    if chk==0 then
        return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,maxct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function this.op1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetsRelateToChain()
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end

-- ====== 效果②：墓地回收 ======

function this.lvfilter(c,tp)
    local code1,code2 = c:GetPreviousCodeOnField()
    return (code1==71100992 or code2==71100992) and c:IsPreviousControler(tp)
        and c:IsPreviousLocation(LOCATION_MZONE)
        and c:GetReasonPlayer()==1-tp
end

function this.cond2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(this.lvfilter,1,nil,tp)
end

function this.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand()
        and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,Card.IsCode,71100992) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end

function this.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 回收帕路奇犽
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil,Card.IsCode,71100992)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        if #sg>0 then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
        end
    end
    -- 回收这张卡
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
