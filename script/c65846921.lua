--幽幽子
function c65846921.initial_effect(c)
	aux.AddCodeList(c,65846916)
	local e1=Effect.CreateEffect(c)----{送墓效果}
	e1:SetDescription(aux.Stringid(65846921,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65846921)
	e1:SetTarget(c65846921.tgtg)
	e1:SetOperation(c65846921.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)----{回手/同调效果}
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c65846921.condition)
	e4:SetTarget(c65846921.target)
	e4:SetOperation(c65846921.activate)
	c:RegisterEffect(e4)	
end
----{送墓效果-处理}
function c65846921.tgfilter(c)
	return aux.IsCodeListed(c,65846916) and c:IsAbleToGrave()
end
function c65846921.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846921.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65846921.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846921.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.SendtoGrave(tc,REASON_EFFECT)

end
----{回手/同调召唤效果-处理}
function c65846921.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function c65846921.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,65846921)==0 end
	Duel.RegisterFlagEffect(tp,65846921,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65846921.scfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg) and c:IsRace(0x10)
end
function c65846921.fselect(g,ec)
	return ec:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c65846921.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_NONTUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+TIMING_CHAIN_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local mg=Duel.GetMatchingGroup(function(c) return c:IsFaceupEx() and c:IsRace(0x10) and c:IsType(0x1) end,tp,0x06,0,nil)
		local g=Duel.GetMatchingGroup(c65846921.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(65846921,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local yg=mg:SelectSubGroup(tp,c65846921.fselect,false,2,#mg,sg:GetFirst())
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,yg)
		end
	end
end