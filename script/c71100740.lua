--伙星之渴望驾驭 2025/08/12 04:48:11 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	-- 连接标记设置
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,71100738),1,1) -- 连接素材要求「九霄之渴望骑士」

	-- ①效果：永续降攻（非发动型）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(this.atkop)
	c:RegisterEffect(e1)
	
	-- ②效果：效果无效
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(this.negcon)
	e2:SetTarget(this.negtg)
	e2:SetOperation(this.negop)
	c:RegisterEffect(e2)
end
function this.cfiter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a3) and not c:IsCode(id)
end 
-- ①效果处理：降攻计数
function this.atkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	local st=Duel.GetMatchingGroupCount(this.cfiter,tp,LOCATION_MZONE,0,nil)
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) and st>0 and re:GetActivateLocation()~=LOCATION_MZONE then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		-- 应用降攻效果
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(st*-80)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

-- ②效果条件：已触发4次①效果
function this.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(id)>=4 and Duel.IsChainDisablable(ev)
end

-- ②效果处理
function this.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function this.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end