--通往进化的未来
function c10701199.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x304e)
	aux.AddSetNameMonsterList(c,0x604e)   
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701199,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10701199)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c10701199.target)
	e1:SetOperation(c10701199.activate)
	c:RegisterEffect(e1)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701199,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10701199.opcon)
	e3:SetTarget(c10701199.optg)
	e3:SetOperation(c10701199.opop)
	c:RegisterEffect(e3)
end
function c10701199.filtera(c,e,tp,check)
	return c:IsSetCard(0x304e) and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c10701199.filterb(c)
	return c:IsSetCard(0x604e) and c:IsAbleToDeck()
end
function c10701199.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c10701199.filtera,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,check) and Duel.IsExistingMatchingCard(c10701199.filterb,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701199.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c10701199.filterb,p,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,c10701199.filtera,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,check)
			local tc=g:GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not (check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or Duel.SelectOption(tp,1190,1152)==0) then
				  Duel.SendtoHand(tc,nil,REASON_EFFECT)
				  Duel.ConfirmCards(1-tp,tc)
				else
				  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
	end
end
function c10701199.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function c10701199.thfilter(c)
	return (((aux.IsSetNameMonsterListed(c,0x304e) or aux.IsSetNameMonsterListed(c,0x604e)) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(5338223,8632967,14154221,34026662,88760522,78933589,24362891,74100225,93504463,64815084)) and c:IsAbleToHand()
end
function c10701199.opcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701199.cfilter,1,nil)
end
function c10701199.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b1=dg:GetCount()>0
		and Duel.GetFlagEffect(tp,10701188)==0
	local b2=Duel.IsExistingMatchingCard(c10701199.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,10701189)==0
	if chk==0 then return b1 or b2 end
end
function c10701199.opop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b1=dg:GetCount()>0
		and Duel.GetFlagEffect(tp,10701188)==0
	local b2=Duel.IsExistingMatchingCard(c10701199.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,10701189)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(10701199,2),aux.Stringid(10701199,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(10701199,2))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(10701199,3))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
		   Duel.HintSelection(g)
		   Duel.Destroy(g,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,10701188,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c10701199.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()>0 then
			 Duel.SendtoHand(tg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,tg)
		end
		Duel.RegisterFlagEffect(tp,10701189,RESET_PHASE+PHASE_END,0,1)
	end
end