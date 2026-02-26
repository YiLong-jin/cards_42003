--人偶怪兽 龙仔
function c10701847.initial_effect(c)
	--Add from GY and destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701847,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10701847)
	e1:SetTarget(c10701847.hdtg)
	e1:SetOperation(c10701847.hdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10701848)
	e3:SetTarget(c10701847.sptg)
	e3:SetOperation(c10701847.spop)
	c:RegisterEffect(e3) 
	--Normal monster 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetTargetRange(LOCATION_GRAVE,0)
	e4:SetTarget(c10701847.type_tg)
	e4:SetValue(TYPE_NORMAL)
	Duel.RegisterEffect(e4,0)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetValue(TYPE_EFFECT)
	Duel.RegisterEffect(e5,0)
end
function c10701847.thfilter(c)
	return (c:IsType(TYPE_NORMAL) or c:IsCode(81587028)) and c:IsAbleToHand()
end
function c10701847.hdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701847.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701847.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10701847.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c10701847.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,75574498) then
		   local eg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		   g:Merge(eg)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=g:Select(tp,1,1,nil)
		if #tg>0 then
			Duel.BreakEffect()
			Duel.HintSelection(tg)
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
function c10701847.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10701847.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetCode())
end
function c10701847.spfilter2(c,e,tp,lv,code)
	return c:IsLevel(lv) and not c:IsCode(code) and c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701847.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.GetFlagEffect(0,10701847)~=0 then return false end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701847.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10701847.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10701847.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10701847.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if tc:IsRelateToChain() and tc:IsRelateToEffect(e) then
	 local lv=tc:GetLevel()
	 local code=tc:GetCode()
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	 local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701847.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,lv,code)
		if #g>0 then
			g:AddCard(tc)
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and Duel.GetFlagEffect(0,10701847)==0 then
			  Duel.RegisterFlagEffect(0,10701847,0,0,1)
			end
		end
	end
end
function c10701847.type_tg(e,c)
	return Duel.GetFlagEffect(0,10701847)~=0 and c:IsCode(10701847) 
end