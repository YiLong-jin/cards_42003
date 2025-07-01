--神谕昭现 群星之主
local m=99982080
local cm=_G["c"..m]
function cm.initial_effect(c)
				--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.spcon1)
	e1:SetCountLimit(1,99982080+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99982080.sumtg)
	e1:SetOperation(c99982080.sumop)
	c:RegisterEffect(e1)
	
					--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.spcon2)
	e2:SetCountLimit(1,99982080+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c99982080.tg)
	e2:SetOperation(c99982080.op)
--	c:RegisterEffect(e2)
	
	
						--Activate3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.spcon3)
	e3:SetCountLimit(1,99982080+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c99982080.tgtg)
	e3:SetOperation(c99982080.tgop)
--	c:RegisterEffect(e3)
end
						--Activate3
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
			Duel.RegisterFlagEffect(tp,99982082,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end






				--Activate2
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c99982080.tg(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if chk==0 then return mg:GetCount()>=3 end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
end
function c99982080.op(e,tp,eg,ep,ev,re,r,rp)
			Duel.RegisterFlagEffect(tp,99982081,0,0,0)
			local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			local g=mg:Select(tp,3,3,nil)
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function cm.check(c)
	return c:IsAbleToDeck() 
end









				--Activate1
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function c99982080.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function c99982080.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99982080.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c99982080.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99982080,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c99982080.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end



