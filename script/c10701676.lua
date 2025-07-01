--阴云精－积状云
function c10701676.initial_effect(c)
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701676,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701676)
	e1:SetTarget(c10701676.optg)
	e1:SetOperation(c10701676.opop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c10701676.con)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701676,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10701677)
	e2:SetTarget(c10701676.target)
	e2:SetOperation(c10701676.operation)
	c:RegisterEffect(e2)	
end
function c10701676.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10701673)
end
function c10701676.lvfilter(c,e,tp,lv)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER) and ((((c:IsLevelAbove(1) and e:GetHandler():IsLocation(LOCATION_MZONE) and not c:IsLevel(lv)) or c:IsType(TYPE_XYZ)) and e:GetHandler():IsAttribute(ATTRIBUTE_WATER)) or (Duel.IsExistingMatchingCard(c10701676.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)))
end
function c10701676.spfilter(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c10701676.optg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or (chkc:IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,10701673))) and chkc:IsControler(tp) and c10701676.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c10701676.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701676.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,e:GetHandler():GetLevel())
end
function c10701676.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	 if c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10701676.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701676.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g==0 then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	 end
	 if c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and tc:IsFaceup() and c:GetLevel()~=tc:GetLevel() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	 end
	 if c:IsAttribute(ATTRIBUTE_WATER) and tc:IsType(TYPE_XYZ) then
		Duel.Overlay(tc,Group.FromCards(c))
	 end
end 
function c10701676.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10701676.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(34968834,2),aux.Stringid(34968834,3))
	 elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(34968834,2))
	 elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(34968834,3))+1
	 else return end
	 if op==0 then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		   local e0=Effect.CreateEffect(c)
		   e0:SetType(EFFECT_TYPE_SINGLE)
		   e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		   e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e0:SetValue(c10701676.xyzlimit)
		   e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		   c:RegisterEffect(e0)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		   e1:SetValue(LOCATION_REMOVED)
		   c:RegisterEffect(e1,true)
	   end
	else
	   if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
		   local e0=Effect.CreateEffect(c)
		   e0:SetType(EFFECT_TYPE_SINGLE)
		   e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		   e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e0:SetValue(c10701676.xyzlimit)
		   e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		   c:RegisterEffect(e0)
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		   e1:SetValue(LOCATION_REMOVED)
		   c:RegisterEffect(e1,true)
	   end
	end
end
function c10701676.xyzlimit(e,c)
	if not c then return false end
	return c:IsRank(2)
end