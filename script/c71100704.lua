--风雪·猎人·展翼 奥哈威英 2025/05/31 22:31:02 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.spcon)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(this.value)
	c:RegisterEffect(e2)
	--lim
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(this.splimit)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+ofs)
	e4:SetTarget(this.settg)
	e4:SetOperation(this.setop)
	c:RegisterEffect(e4)
end
function this.spfilter(c)
	return not c:IsRace(RACE_WYRM) or c:IsFacedown()
end
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(this.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function this.thfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(this.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(this.thfilter,tp,LOCATION_DECK,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function this.atkf(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON+RACE_WYRM)
end 
function this.value(e,c)
	return Duel.GetMatchingGroupCount(this.atkf,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*-200
end
function this.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function this.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.atkf,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function this.setop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(this.negcon)
	e1:SetOperation(this.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function this.setfilter(c,e,tp)
	return c:IsSummonPlayer(1-tp)
end
function this.negcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(this.setfilter,1,nil,nil,tp)
end
function this.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=eg:Filter(this.setfilter,nil,e,tp)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	e:Reset()
end
