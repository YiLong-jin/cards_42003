--翱翔的魔石圣兽
function c9879394.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879394,1))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9879394+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9879394.sptg)
	e1:SetOperation(c9879394.spop)
	c:RegisterEffect(e1)
end

function c9879394.filter1(c,e,tp)
	return c:IsSetCard(0x27e3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879394.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x107e,1)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x107e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x107e,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x107e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c9879394.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c9879394.filter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x107e,1) then
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9879394,0))  then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end  
end
