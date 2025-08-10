--皇家收缩世界
local s, id = GetID()
function c99961080.initial_effect(c)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99961080.xiaoyecon1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
		--damage1
	local xiaoye=Effect.CreateEffect(c)
	xiaoye:SetType(EFFECT_TYPE_ACTIVATE)
	xiaoye:SetCategory(CATEGORY_DAMAGE)
	xiaoye:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	xiaoye:SetCode(EVENT_FREE_CHAIN)
	xiaoye:SetTarget(c99961080.xiaoyetg)
	xiaoye:SetCondition(c99961080.xiaoyecon)
	xiaoye:SetOperation(c99961080.xiaoyeop)
	c:RegisterEffect(xiaoye)
end
s.Savior_Xiaoye=true


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function s.thfilter(c)
	return c:IsCode(99961060) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,math.min(3,#g),nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		
		-- 赋予本回合效果
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(s.reccon)
		e1:SetOperation(s.recop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local e19=Effect.CreateEffect(e:GetHandler())
	e19:SetType(EFFECT_TYPE_FIELD)
	e19:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e19:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e19:SetTargetRange(1,0)
	e19:SetTarget(c99961080.splimit)
	e19:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e19,tp)
end
function c99961080.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c.Savior_Koumakan or c.Savior_Xiaoye)
end
-- 回收条件
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local fa=Duel.GetFlagEffect(tp,id)
	return re:GetHandler():IsCode(99961060) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and fa<6
end

-- 回收操作
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE,0,1)
		end
	end
end






function c99961080.xiaoyecon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function c99961080.xiaoyecon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)~=0
end
function c99961080.xiaoyetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961080.xiaoyeop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
