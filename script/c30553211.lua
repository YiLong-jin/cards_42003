--墟界天使 审判侍从
function c30553211.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)	   
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,30553211)
	e1:SetCost(c30553211.spcost)
	e1:SetTarget(c30553211.sptg)
	e1:SetOperation(c30553211.spop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30553212)
	e3:SetCost(c30553211.cost)
	e3:SetTarget(c30553211.tg)
	e3:SetOperation(c30553211.op)
	c:RegisterEffect(e3)
end
function c30553211.costfil(c)
	return c:IsSetCard(0x302) 
end
function c30553211.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,1):GetCount()>0 end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.SendtoGrave(g,REASON_COST)
	if c30553211.costfil(g:GetFirst()) then
		e:SetLabel(1)
		e:SetLabelObject(g:GetFirst())
		Duel.SetTargetCard(g:GetFirst())
	end
end
function c30553211.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c30553211.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local gc=e:GetLabelObject()
		if gc:IsRelateToEffect(e) and gc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(30553211,0)) then
			Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP)
			if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
				 local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(gc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
function c30553211.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 e:SetLabel(100)
	return true
end
function c30553211.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetDecktopGroup(tp,3):GetCount()==3 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local gc=g:GetFirst()
	local num=0
	while gc do
		if gc:IsSetCard(0x302) then num=num+1 end
		gc=g:GetNext()
	end
	if num==3 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
		e:SetCategory(CATEGORY_TODECK)
		e:SetLabel(1)
	end
end
function c30553211.thfil(c)
	return c:IsSetCard(0x302) and c:IsAbleToHand()
end
function c30553211.tdfilter(c)
	return c:IsSetCard(0x302)
end
function c30553211.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	elseif e:GetLabel()==1 then
		local mg=Duel.SelectMatchingCard(tp,c30553211.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
		local mtc=mg:GetFirst()
		if mtc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(mtc,0)
		Duel.ConfirmDecktop(tp,1)
		end
		Duel.SendtoDeck(e:GetHandler(),tp,0,REASON_EFFECT)
	end
end