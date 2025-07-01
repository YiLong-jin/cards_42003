--EN新宇宙接触
function c10701560.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701560+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10701560.activate)
	c:RegisterEffect(e1) 
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9))
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(89943723)
	--c:RegisterEffect(e2)
	-- Special Summon 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701560,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,10701561)
	e3:SetCondition(c10701560.gspcon)
	e3:SetTarget(c10701560.gsptg)
	e3:SetOperation(c10701560.gspop)
	c:RegisterEffect(e3) 
	--may not return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(42015635)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e4)  
end
function c10701560.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,89943723) and c:IsAbleToHand()
end
function c10701560.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701560.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701560,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10701560.gspconfilter(c,tp)
	return (c:IsSetCard(0x8) or c:IsSetCard(0x1f)) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousControler(tp) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function c10701560.gspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701560.gspconfilter,1,nil,tp)
end
function c10701560.gspfilter(c,e,tp)
	return c:IsSetCard(0x1f,0x3008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701560.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701560.gspfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701560.gspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701560.gspfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end