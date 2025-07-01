--墟界天使 游荡守卫
function c30553209.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)	   
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30553209)
	e1:SetCost(c30553209.spcost)
	e1:SetTarget(c30553209.sptg)
	e1:SetOperation(c30553209.spop)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30553210)
	e3:SetCost(c30553209.cost)
	e3:SetTarget(c30553209.tg)
	e3:SetOperation(c30553209.op)
	c:RegisterEffect(e3)
end
function c30553209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c30553209.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c30553209.spfil(c)
	return c:IsSetCard(0x302) 
end
function c30553209.op(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsSetCard(0x302) then
			Duel.BreakEffect()
			--Duel.DisableShuffleCheck()
			--Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			local g=Duel.SelectMatchingCard(tp,c30553209.spfil,tp,LOCATION_DECK,0,2,2,nil)
			if g:GetCount()==2 then
			local gc=g:GetFirst()
			while gc do
				Duel.MoveSequence(gc,0)
				gc=g:GetNext()
			end
			Duel.SortDecktop(tp,tp,2)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function c30553209.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 e:SetLabel(100)
	return true
end
function c30553209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c30553209.thfil(c)
	return c:IsSetCard(0x302) and c:IsAbleToHand()
end
function c30553209.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==1 then
		if Duel.IsExistingMatchingCard(c30553209.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(30553209,0)) then
			local mg=Duel.SelectMatchingCard(tp,c30553209.thfil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(mg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,mg)
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
	end
end