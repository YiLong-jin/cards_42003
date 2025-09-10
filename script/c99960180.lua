--真魔法·创世纪
local s,id,o=GetID()
Duel.LoadScript("c99960010.lua")
function s.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	--e1:SetCountLimit(1,99960180+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(shenqi_Savior.spellcost4)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
		if not shenqi_Savior.global_check then
		shenqi_Savior.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(shenqi_Savior.aclimit)
		Duel.RegisterEffect(ge1,0)
	end
end

s.Savior_shenqi=true




function s.spfilter1(c,e,tp)
	return c:IsFaceup() and c.Savior_mojie
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function s.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsCode(99960090) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
	end
	local g3=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,tp)
	local g2=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if Duel.SpecialSummon(sc,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(99960180,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g4=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g4:GetFirst()
		if tc1 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc1,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	sc:CompleteProcedure()
end
function s.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and (c.Savior_mojie or c.Savior_shenqi) and c:IsAbleToDeck()
end
function s.filter1(c,tp)
	return c:IsCode(99960020) and c:GetActivateEffect():IsActivatable(tp,true,true)
end



function s.mtfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e) and c:IsCode(9990370)
end