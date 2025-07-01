--比绝望更深邃
function c99900450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99900450,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetTarget(c99900450.target)
	e2:SetOperation(c99900450.activate)
	c:RegisterEffect(e2)
end
function c99900450.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION)
		and Duel.IsExistingTarget(c99900450.filter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel(),e,tp)
end
function c99900450.filter(c,lv,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<lv and c:IsSetCard(0x676)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99900450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99900450.filter(chkc,eg:GetFirst():GetLevel(),e,tp) end
	if chk==0 then return e:GetHandler():GetFlagEffect(69711728)==0
		and eg:IsExists(c99900450.cfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	e:GetHandler():RegisterFlagEffect(99900450,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99900450.filter,tp,LOCATION_GRAVE,0,1,1,nil,eg:GetFirst():GetLevel(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99900450.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end