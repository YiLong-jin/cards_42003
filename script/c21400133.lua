--亡灵海岸之战-抢夺宝藏
function c21400133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)  
	--spsummon spell
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(21400133,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,21400133) 
	e2:SetTarget(c21400133.spstg)
	e2:SetOperation(c21400133.spsop)
	c:RegisterEffect(e2)  
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(21400133,2))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1,11400133)
	e2:SetCondition(c21400133.xxcon) 
	e2:SetTarget(c21400133.xxtg)
	e2:SetOperation(c21400133.xxop)
	c:RegisterEffect(e2)  
end 
function c21400133.spfilter(c,e,tp)
	return c:IsSetCard(0x3211) and c:IsType(TYPE_SYNCHRO)
end
function c21400133.spsumfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end
function c21400133.spsumfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCountFromEx(1-tp,tp,nil,c)>0 
end
function c21400133.gcheck(g,e,tp)
	if #g~=2 then return false end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return c21400133.spsumfilter1(ac,e,tp) and c21400133.spsumfilter2(bc,e,tp)
		or c21400133.spsumfilter1(bc,e,tp) and c21400133.spsumfilter2(ac,e,tp)
end
function c21400133.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21400133.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(c21400133.gcheck,2,2,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_EXTRA)
end
function c21400133.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21400133.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
	if not g:CheckSubGroup(c21400133.gcheck,2,2,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400133,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xsg=g:SelectSubGroup(tp,c21400133.gcheck,false,2,2,e,tp) 
	local tc1=xsg:FilterSelect(tp,c21400133.spsumfilter1,1,1,nil,e,tp):GetFirst()
	xsg:RemoveCard(tc1) 
	local tc2=xsg:GetFirst()
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2,true) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(c21400133.spdesop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tc1:RegisterEffect(e3,true)
	Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2,true) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetOperation(c21400133.spdesop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		tc2:RegisterEffect(e3,true)
	Duel.SpecialSummonComplete()
end 
function c21400133.spdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c21400133.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()  
end 
function c21400133.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end
function c21400133.rthfil(c) 
	return c:IsSetCard(0x3211) and c:IsAbleToHand()  
end 
function c21400133.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.RockPaperScissors(false)  
	if tp==op then 
		local rg=Duel.GetMatchingGroup(c21400133.rmfil,tp,0,LOCATION_MZONE,nil) 
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		local sg=Duel.SelectMatchingCard(tp,c21400133.rthfil,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	elseif 1-tp==op then 
		local rg=Duel.GetMatchingGroup(c21400133.rmfil,tp,LOCATION_MZONE,0,nil) 
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) 
		Duel.Draw(1-tp,1,REASON_EFFECT)
	else 
		Duel.Draw(tp,1,REASON_EFFECT) 
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end 
end 


