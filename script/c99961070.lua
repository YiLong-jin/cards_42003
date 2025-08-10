--破魔银刃
local s, id = GetID()
function c99961070.initial_effect(c)
	
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	
	
	
	-- 赋予超量怪兽效果
	local e22=Effect.CreateEffect(c)
			e22:SetDescription(aux.Stringid(99961060,0))
	e22:SetCategory(CATEGORY_DAMAGE)
	e22:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e22:SetCategory(CATEGORY_DAMAGE)
	e22:SetCondition(c99961070.discon)
	e22:SetCost(c99961070.cost1)
	e22:SetTarget(c99961070.damtg1)
	e22:SetOperation(c99961070.damop1)
	c:RegisterEffect(e22)
		--damage1
	local xiaoye=Effect.CreateEffect(c)
	xiaoye:SetType(EFFECT_TYPE_ACTIVATE)
	xiaoye:SetCategory(CATEGORY_DAMAGE)
	xiaoye:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	xiaoye:SetCode(EVENT_FREE_CHAIN)
	xiaoye:SetTarget(c99961070.xiaoyetg)
	xiaoye:SetCondition(c99961070.xiaoyecon)
	xiaoye:SetOperation(c99961070.xiaoyeop)
	c:RegisterEffect(xiaoye)
end
s.Savior_Xiaoye=true


function s.filter(c)
	return c:IsFaceup() and c.Savior_Xiaoye
end
function s.filter1111(c)
	return c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end

-- 目标选择
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1111,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1111,tp,0,LOCATION_ONFIELD,1,1,nil)
	--Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


function c99961070.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.Savior_Xiaoye
end
function c99961070.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99961070.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961070.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end



function c99961070.xiaoyecon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function c99961070.xiaoyecon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)~=0
end
function c99961070.xiaoyetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961070.xiaoyeop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
