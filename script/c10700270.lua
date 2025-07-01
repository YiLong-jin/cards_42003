--奇术师 狂欢节K
function c10700270.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700270,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10700270)
	e1:SetTarget(c10700270.thtg)
	e1:SetOperation(c10700270.thop)
	c:RegisterEffect(e1)  
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c10700270.regcon)
	e3:SetOperation(c10700270.regop)
	c:RegisterEffect(e3)  
end
function c10700270.thfilter(c)
	return c:IsSetCard(0xf1a3) and c:IsAbleToHand()
end
function c10700270.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700270.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700270.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700270.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10700270.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_COIN)
	return ex and Duel.GetFlagEffect(tp,10700270)==0
end
function c10700270.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(c10700270.effcon)
	e1:SetOperation(c10700270.effop)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	c:RegisterEffect(e1)
end
function c10700270.effcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local res={Duel.GetCoinResult()}
	   for i=1,ev do
		   if res[i]==1 then
			   ct=ct+1
		   end
	end
	return re==e:GetLabelObject() and ct>0
end
function c10700270.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local ng=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SelectYesNo(tp,aux.Stringid(10700270,2)) then
		 Duel.Hint(HINT_CARD,0,10700270)
		 local ct=0
		 local res={Duel.GetCoinResult()}
		 for i=1,ev do
			if res[i]==1 then
				ct=ct+1
			end
		 end
		 if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(10700270,3)) then
		   Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		 end
		 if ct>1 and #ng>0 and Duel.SelectYesNo(tp,aux.Stringid(10700270,4)) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		   local sg=ng:Select(tp,1,1,nil)
		   local tc=sg:GetFirst()
		   Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetCode(EFFECT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e2:SetCode(EFFECT_DISABLE_EFFECT)
		   e2:SetValue(RESET_TURN_SET)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e2)
		   if tc:IsType(TYPE_TRAPMONSTER) then
			  local e3=Effect.CreateEffect(c)
			  e3:SetType(EFFECT_TYPE_SINGLE)
			  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			  e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e3)
		   end
		 end
		if ct>2 and (g1:GetCount()>0 or g2:GetCount()>0) then
			 local sg=Group.CreateGroup()
			 if g1:GetCount()>0 and (g2:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(10700270,5))) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			   local sg1=g1:Select(tp,1,1,nil)
			   Duel.HintSelection(sg1)
			   sg:Merge(sg1)
			 end
			 if g2:GetCount()>0 and (g1:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(10700270,6))) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			   local sg2=g2:Select(tp,1,1,nil)
			   Duel.HintSelection(sg2)
			   sg:Merge(sg2)
			 end
			 Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	Duel.RegisterFlagEffect(tp,10700270,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end 
end