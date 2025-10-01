--生存降临·菲尼克斯
function c9879289.initial_effect(c)
	 aux.AddCodeList(c,71100740,9879288)


	 local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9879289+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9879289.con)
	e1:SetTarget(c9879289.actg) 
	e1:SetOperation(c9879289.acop) 
	c:RegisterEffect(e1) 

	
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879289,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1879289)
	e3:SetCost(c9879289.cost1)
	e3:SetTarget(c9879289.destg)
	e3:SetOperation(c9879289.desop)
	c:RegisterEffect(e3)
end
function c9879289.confilter(c)
	return c:IsFaceup() and c:IsAttackAbove(4000)
end
function c9879289.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879289.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function c9879289.ctfil(c,e,tp) 
	return c:IsFaceup() and c:IsCode(71100740) and c:IsSummonLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c9879289.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) 
end  
function c9879289.spfil(c,e,tp,sc)
	return c:IsCode(9879288) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0   
end 
function c9879289.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c9879289.ctfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c9879289.ctfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c9879289.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c9879289.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,tc)
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.SpecialSummon(sc,0,tp,tp,true,true,POS_FACEUP)
	sc:CompleteProcedure()
	end 
end 



function c9879289.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9879289.thfil(c,tp) 
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x67a3)
end 
function c9879289.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x67a3) and c:IsType(TYPE_MONSTER)
end 
function c9879289.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingTarget(c9879289.thfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9879289.thfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9879289.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		  local g2=Duel.GetMatchingGroup(c9879289.tgfil1,tp,LOCATION_DECK,0,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9879289,0)) then
				local sg=g2:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			 end
		end
	end
end