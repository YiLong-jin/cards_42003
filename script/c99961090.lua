--妖剑银刃
local s, id = GetID()
function c99961090.initial_effect(c)
	
	-- 效果①：除外怪兽并回收
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
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
	e22:SetCondition(c99961090.discon)
	e22:SetCost(c99961090.cost1)
	e22:SetTarget(c99961090.damtg1)
	e22:SetOperation(c99961090.damop1)
	c:RegisterEffect(e22)
		--damage1
	local xiaoye=Effect.CreateEffect(c)
	xiaoye:SetType(EFFECT_TYPE_ACTIVATE)
	xiaoye:SetCategory(CATEGORY_DAMAGE)
	xiaoye:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	xiaoye:SetCode(EVENT_FREE_CHAIN)
	xiaoye:SetTarget(c99961090.xiaoyetg)
	xiaoye:SetCondition(c99961090.xiaoyecon)
	xiaoye:SetOperation(c99961090.xiaoyeop)
	c:RegisterEffect(xiaoye)
end
s.Savior_Xiaoye=true



-- 发动条件：自己场上有"咲夜"怪兽
function s.cfilter(c)
	return c:IsFaceup() and c.Savior_Xiaoye
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

-- 目标选择
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

-- 效果处理
function s.thfilter(c)
	return c:IsCode(99961060) and c:IsAbleToHand()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and atk>0 then
			local ct=math.floor(atk/500)
			if ct<=0 then return end
			
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,math.min(ct,#g),nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
	local e19=Effect.CreateEffect(e:GetHandler())
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e19:SetTargetRange(1,0)
	e19:SetTarget(c99961090.splimit)
	e19:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e19,tp)
end
function c99961090.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c.Savior_Koumakan or c.Savior_Xiaoye)
end






function c99961090.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c.Savior_Xiaoye
end
function c99961090.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99961090.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961090.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end





function c99961090.xiaoyecon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function c99961090.xiaoyecon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)~=0
end
function c99961090.xiaoyetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961090.xiaoyeop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
