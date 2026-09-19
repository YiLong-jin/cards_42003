--人形の家
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67331360,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,67331360)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67331360,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.matcon)
	e2:SetTarget(s.mattg)
	e2:SetOperation(s.matop)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp,check)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0)) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode(),nil)
end
function s.spfilter(c,e,tp,code,code2)
	return c:IsCode(code,code2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsPlayerAffectedByEffect(tp,10701753) or c:IsLocation(LOCATION_DECK))
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(75574498)
end
function s.gcheck(sg,e,tp,check)
	if #sg==1 then return true end
	local code1=sg:GetFirst():GetCode()
	local code2=sg:GetNext():GetCode()
	local zone=LOCATION_DECK
	if check then zone=LOCATION_DECK+LOCATION_GRAVE end
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,code1,code2)
	return tg:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,code1,code2)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.IsPlayerAffectedByEffect(tp,10701753)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp,check) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,check) end
	local ct=math.min(2,ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133)
		or not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) then ct=1 end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp,check)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,s.gcheck,false,1,ct,e,tp,check)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#tg,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local check=Duel.IsPlayerAffectedByEffect(tp,10701753)
	local zone=LOCATION_DECK
	if Duel.IsPlayerAffectedByEffect(tp,10701753) then zone=LOCATION_DECK+LOCATION_GRAVE end
	if ft<=0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local code1,code2
	local tc=tg:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,tc:GetCode(),nil) then
			if code1==nil then code1=tc:GetCode() else code2=tc:GetCode() end
		end
		tc=tg:GetNext()
	end
	if code1==nil then return end
	local sg
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft==1 or code2==nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,zone,0,1,1,sg,e,tp,code1,code2)
	else
		local g=Duel.GetMatchingGroup(s.spfilter,tp,zone,0,nil,e,tp,code1,code2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,code1,code2)
	end
	if not sg then return end
	local sc=sg:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(6)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.matfilter(c)
	return c:IsCode(44190146) and c:IsFaceup() and c:IsCanOverlay()
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g2:GetFirst()
		if tc and not tc:IsImmuneToEffect(e) and Duel.Overlay(tc,g1)~=0 then
			Duel.BreakEffect()
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
