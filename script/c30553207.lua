--墟界天使 沉默巨人
function c30553207.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)	   
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30553207)
	e1:SetCost(c30553207.spcost)
	e1:SetTarget(c30553207.sptg)
	e1:SetOperation(c30553207.spop)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30553208)
	e3:SetCost(c30553207.cost)
	e3:SetTarget(c30553207.tg)
	e3:SetOperation(c30553207.op)
	c:RegisterEffect(e3)
end
function c30553207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c30553207.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c30553207.spfil(c,e,tp)
	return c:IsSetCard(0x302) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30553207.op(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSetCard(0x302) and Duel.IsExistingMatchingCard(c30553207.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(30553207,1)) then
			local g=Duel.SelectMatchingCard(tp,c30553207.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ShuffleHand(tp)
	end
end
function c30553207.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 e:SetLabel(100)
	return true
end
function c30553207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetDecktopGroup(tp,2):GetCount()==2 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.ConfirmDecktop(tp,2)
	local gc=g:GetFirst()
	local num=0
	while gc do
		if gc:IsSetCard(0x302) then num=num+1 end
		gc=g:GetNext()
	end
	if num==2 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetLabel(1)
	end
end
function c30553207.thfil(c)
	return c:IsSetCard(0x302) and c:IsAbleToHand()
end
function c30553207.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==1 then
		if Duel.IsExistingMatchingCard(c30553207.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(30553207,0)) then
			local mg=Duel.SelectMatchingCard(tp,c30553207.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(mg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mg)
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
	end
end