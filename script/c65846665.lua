--小阿卡那的宝剑 王牌
function c65846665.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	--e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(0x3)
	--c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846665,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846665+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846665.target)
	e1:SetOperation(c65846665.activate)
	c:RegisterEffect(e1)
end
function c65846665.filter(c,e,tp)
	return c:IsRace(0x3) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65846665.eqfilter(c,tp,ec)
	return c:IsSetCard(0x13ef) and (not c:IsType(TYPE_EQUIP) or c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() 
end
function c65846665.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65846665.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65846665.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65846665.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c65846665.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,g:GetFirst()) and Duel.SelectYesNo(tp,aux.Stringid(65846665,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqg=Duel.SelectMatchingCard(tp,c65846665.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,g:GetFirst())
		local eqc=eqg:GetFirst()
		if Duel.Equip(tp,eqc,g:GetFirst())~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(g:GetFirst())
			e1:SetValue(c65846665.eqlimit)
			eqg:GetFirst():RegisterEffect(e1)
		end
	end
end
function c65846665.eqlimit(e,c)
	return c==e:GetLabelObject()
end