--月夜珍品猎人 十六夜咲夜
local s, id = GetID()

function s.initial_effect(c)
	-- 召唤/特殊召唤成功时发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCountLimit(1,99961020)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
	
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCountLimit(1,99961021)
	e11:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e11:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e11:SetCondition(s.condition)
	e11:SetCost(s.cost)
	e11:SetTarget(s.target)
	e11:SetOperation(s.operation)
	c:RegisterEffect(e11)

		Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
s.Savior_Koumakan=true
s.Savior_Xiaoye=true


function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not ((rc:GetType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and (rc.Savior_Xiaoye))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function s.filter(c)
	return c.Savior_Xiaoye and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	-- 根据数量回收
	local ct=Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)
	if ct>=3 then
		local thct=math.floor(ct/3)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,thct,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end











function s.setfilter(c)
	return c:IsCode(99961120) and c:IsSSetable() -- 99999999替换为"小刀奇术"的实际卡号
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_DECK)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end