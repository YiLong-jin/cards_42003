--试做体：破坏蚀菌M
function c71100591.initial_effect(c)
	--dis 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,71100591)
	e1:SetTarget(c71100591.negtg)
	e1:SetOperation(c71100591.negop)
	c:RegisterEffect(e1) 
	--sp
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,11100591) 
	e2:SetTarget(c71100591.esptg)
	e2:SetOperation(c71100591.espop)
	c:RegisterEffect(e2)
end 
function c71100591.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c71100591.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end 
function c71100591.tarfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x7d0) and c:IsLevelBelow(4) 
end 
function c71100591.espfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7d0) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c71100591.esptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return c71100591.tarfil(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c71100591.tarfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c71100591.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c71100591.tarfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71100591.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.SelectMatchingCard(tp,c71100591.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local og=Group.FromCards()
		local tc=Duel.GetFirstTarget() 
		if tc:IsRelateToEffect(e) then 
			og:AddCard(tc) 
		end 
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_REMOVED) then 
			og:AddCard(c) 
		end 
		if og:GetCount()>0 then 
			Duel.Overlay(sc,og) 
		end 
		local e1=Effect.CreateEffect(sc)
		e1:SetDescription(aux.Stringid(71100591,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT) 
		e1:SetTarget(c71100591.xdestg) 
		e1:SetOperation(c71100591.xdesop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)
		if not sc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
		end
	end 
end 
function c71100591.xdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE) 
end 
function c71100591.xdesop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil) 
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT) 
	end  
end 




