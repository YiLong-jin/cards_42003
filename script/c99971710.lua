--创造物充能
local s, id = GetID()
function c99971710.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,99971710+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99971710.thtg)
	e1:SetOperation(c99971710.thop)
	c:RegisterEffect(e1)	
	
	
	-- 效果②：墓地除外回收永续魔法并检索（从e2开始）
	local e2=Effect.CreateEffect(c)  -- 改为e2
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)  -- 注册e2
end


-- cost：除外自身
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

-- 检查除外的永续魔法卡
function s.tdfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToDeck()
		and c:IsLocation(LOCATION_REMOVED)
end

-- 检索超凡世界怪兽
function s.thfilter(c)
	return c:IsSetCard(0x67f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_REMOVED,0,nil)
		return #g>=2
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 选择2张除外的永续魔法卡回到卡组
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	if #g>=2 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		-- 从卡组检索超凡世界怪兽
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end







function c99971710.thfilter2(c,tp)
	return c:IsCode(99971660) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c99971710.thfilter2a,tp,LOCATION_DECK,0,1,nil)
end
function c99971710.thfilter2a(c)
	return c:IsCode(99971670) and c:IsAbleToHand()
end
function c99971710.thfilter2t(c)
	return c:IsCode(99971660) and c:IsAbleToHand()
end
function c99971710.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971710.thfilter2,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c99971710.fselect(g)
	return g:FilterCount(c99971710.thfilter2t,nil)==1
end
function c99971710.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(function(c) return c:IsCode(99971670) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(function(c) return c:IsCode(99971660) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		local g=Group.__add(g1,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c99971710.fselect,false,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end