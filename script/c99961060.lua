--银刀投掷
function c99961060.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c99961060.xiaoyecon1)
	e1:SetTarget(c99961060.damtg)
	e1:SetOperation(c99961060.damop)
	c:RegisterEffect(e1)
	
-- 赋予超量怪兽效果
	local e22=Effect.CreateEffect(c)
		e22:SetDescription(aux.Stringid(99961060,0))
	e22:SetCategory(CATEGORY_DAMAGE)
	e22:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e22:SetCategory(CATEGORY_DAMAGE)
	e22:SetCondition(c99961060.discon)
	e22:SetCost(c99961060.cost1)
	e22:SetTarget(c99961060.damtg1)
	e22:SetOperation(c99961060.damop1)
	c:RegisterEffect(e22)
	
		--damage1
	local xiaoye=Effect.CreateEffect(c)
	xiaoye:SetType(EFFECT_TYPE_ACTIVATE)
	xiaoye:SetCategory(CATEGORY_DAMAGE)
	xiaoye:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	xiaoye:SetCode(EVENT_FREE_CHAIN)
	xiaoye:SetTarget(c99961060.xiaoyetg)
	xiaoye:SetCondition(c99961060.xiaoyecon)
	xiaoye:SetOperation(c99961060.xiaoyeop)
	c:RegisterEffect(xiaoye)
end
c99961060.Savior_Xiaoye=true


function c99961060.xiaoyecon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function c99961060.xiaoyecon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)~=0
end
function c99961060.xiaoyetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961060.xiaoyeop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end








function c99961060.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.Savior_Xiaoye
end
function c99961060.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99961060.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961060.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end














function c99961060.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961060.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
