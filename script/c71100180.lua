--寒霜协议：零式升级
function c71100180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100180+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71100180.target)
	e1:SetOperation(c71100180.activate)
	c:RegisterEffect(e1)
end 
function c71100180.espfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsSetCard(0x7d9) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c71100180.pbfil(c,e,tp)
	if not (c:IsSetCard(0x7d9) and c:IsLevelAbove(5) and not c:IsPublic()) then return false end 
	if c:IsLocation(LOCATION_HAND) then 
		return Duel.IsExistingMatchingCard(c71100180.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and e:GetHandler():IsCanOverlay()
	elseif c:IsLocation(LOCATION_DECK) then 
		return c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	else return false end 
end
function c71100180.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c71100180.pbfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end 
	local pc=Duel.SelectMatchingCard(tp,c71100180.pbfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
	Duel.ConfirmCards(1-tp,pc) 
	if pc:IsLocation(LOCATION_HAND) then 
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else 
		Duel.SetTargetCard(pc)
		e:SetLabel(1) 
	end 
end
function c71100180.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	local tc=Duel.GetFirstTarget()
	if x==0 and Duel.IsExistingMatchingCard(c71100180.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
		local sc=Duel.SelectMatchingCard(tp,c71100180.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		if c:IsRelateToEffect(e) then 
			c:CancelToGrave() 
			Duel.Overlay(sc,c)
		end 
	elseif x==1 then  
		if tc==nil or not tc:IsRelateToEffect(e) then return end 
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end 
end


