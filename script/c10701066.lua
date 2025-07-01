--炽天武装 莎葵艾
function c10701066.initial_effect(c)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10701066)
	e4:SetCondition(c10701066.thcon)
	e4:SetCost(c10701066.drcost)
	e4:SetTarget(c10701066.drtg)
	e4:SetOperation(c10701066.drop)
	c:RegisterEffect(e4)   
	--synchro effect
	local e2=aux.GrandsCychroTargetCheckEffect(c)
	e2:SetCountLimit(1,10701066+1)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(10701047,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return not (tc:IsType(TYPE_SYNCHRO) or tc:IsRace(RACE_FAIRY)) and tc:IsLocation(LOCATION_EXTRA) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(10701047,ACTIVITY_SPSUMMON,function(tc) return (tc:IsType(TYPE_SYNCHRO) or tc:IsRace(RACE_FAIRY)) or not tc:IsPreviousLocation(LOCATION_EXTRA) end)
end
function c10701066.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c10701066.cfilter(c)
	return (c:IsRace(RACE_FAIRY) and c:IsAbleToDeckAsCost()) or (c:IsAbleToExtra() and c:IsType(TYPE_SYNCHRO))
end
function c10701066.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701066.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10701066.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c10701066.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10701066.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end