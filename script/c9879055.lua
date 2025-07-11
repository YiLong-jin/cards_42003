--幻梦恋歌
function c9879055.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879055,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9879055+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9879055.sptg)
	e1:SetOperation(c9879055.spop)
	c:RegisterEffect(e1)
end
function c9879055.filter(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2)
end
function c9879055.filter1(c,e,tp)
	return c:IsCanHaveCounter(0x7e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879055.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9879055.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9879055.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9879055.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x7e2)
end
function c9879055.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c9879055.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x7e2,2) then
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9879055,0))  then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end  
end