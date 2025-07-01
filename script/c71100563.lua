--V城默示录~死者狂乱之日
function c71100563.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c71100563.actg)
	e1:SetOperation(c71100563.acop)
	c:RegisterEffect(e1)  
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),71100563)~=0 end)
	c:RegisterEffect(e2)
	if not c71100563.global_check then
		c71100563.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c71100563.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c71100563.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and tc:IsRace(RACE_INSECT) then 
		Duel.RegisterFlagEffect(1-rp,71100563,RESET_PHASE+PHASE_END,0,1) 
	end
end 
function c71100563.thfil(c)
	return c:IsLevel(2) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c71100563.actg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100563.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100563.xyzfil(c,mg) 
	return c:IsRank(2) and c:IsXyzSummonable(mg,1,99) 
end 
function c71100563.acop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100563.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
		local mg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,nil) 
		if Duel.IsExistingMatchingCard(c71100563.xyzfil,tp,LOCATION_EXTRA,0,1,nil,mg) and Duel.SelectYesNo(tp,aux.Stringid(71100563,0)) then 
			local xc=Duel.SelectMatchingCard(tp,c71100563.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst() 
			Duel.XyzSummon(tp,xc,mg,1,99) 
		end 
	end
end
function c71100563.spfil(c,e,tp)
	if not (c:IsSetCard(0x17a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end 
	if c:IsLocation(LOCATION_EXTRA) then  
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	else 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end 
end
function c71100563.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100563.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end 
function c71100563.acop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c71100563.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		sc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		sc:RegisterEffect(e1)
	end
end
function c71100563.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=c71100563.actg1(e,tp,eg,ep,ev,re,r,rp,0) 
	local b2=c71100563.actg2(e,tp,eg,ep,ev,re,r,rp,0) 
	if chk==0 then return b1 or b2 end 
	local xtable={}   
	if b1 then table.insert(xtable,aux.Stringid(71100563,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(71100563,2)) end  
	local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
	e:SetCategory(0) 
	e:SetLabel(0) 
	if xtable[op]==aux.Stringid(71100563,1) then  
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
		c71100563.actg1(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetLabel(1)
	end 
	if xtable[op]==aux.Stringid(71100563,2) then  
		e:SetCategory(CATEGORY_SPECIAL_SUMMON) 
		c71100563.actg2(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetLabel(2)
	end  
end 
function c71100563.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=e:GetLabel() 
	if x==0 then return end 
	if x==1 then 
		c71100563.acop1(e,tp,eg,ep,ev,re,r,rp)
	end  
	if x==2 then 
		c71100563.acop2(e,tp,eg,ep,ev,re,r,rp)
	end   
end 


