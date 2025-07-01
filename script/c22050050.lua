--悲叹之雏 美树沙耶香
function c22050050.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22050050,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22050050)
	e1:SetTarget(c22050050.target)
	e1:SetOperation(c22050050.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050050,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,22050050)
	e2:SetTarget(c22050050.sptg)
	e2:SetOperation(c22050050.spop)
	c:RegisterEffect(e2)
end
function c22050050.tgfilter(c)
	return c:IsSetCard(0xff8) and c:IsAbleToGrave()
end
function c22050050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22050050.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c22050050.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22050050.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22050050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22050001,0xff8,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22050001,0xff8,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c22050050.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22050001,0xff8,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22050001,0xff8,TYPES_TOKEN_MONSTER,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE,1-tp) then
		local token=Duel.CreateToken(tp,22050004)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token=Duel.CreateToken(tp,22050004)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end
