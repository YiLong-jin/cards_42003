--空腹企鹅 菠萝包
function c10701169.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701169,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10701169)
	e1:SetTarget(c10701169.sctg)
	e1:SetOperation(c10701169.scop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701169,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10701170)
	e2:SetCondition(c10701169.setcon)
	e2:SetTarget(c10701169.settg)
	e2:SetOperation(c10701169.setop)
	c:RegisterEffect(e2)
end
function c10701169.sfilter(c,tc)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSynchroSummonable(tc,g1)
end
function c10701169.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(c10701169.sfilter,tp,LOCATION_EXTRA,0,1,nil,c,g1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701169.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(c10701169.sfilter,tp,LOCATION_EXTRA,0,nil,c,g1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,g1)
	end
end

function c10701169.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c10701169.setfilter(c,e,tp,mft,sft)
	return c:IsSetCard(0x5a) and (sft>0 and c:IsSSetable(true) or mft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c10701169.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then sft=sft-1 end
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10701169.setfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mft,sft) 
   end
end
function c10701169.setop(e,tp,eg,ep,ev,re,r,rp)
	local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10701169.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mft,sft)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then 
	   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
	   Duel.SSet(tp,tc,tp,false)
	end
end