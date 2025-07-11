--星变偶像·怜亚
function c9879052.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879052,0))
	e11:SetCategory(CATEGORY_DRAW)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,9879052)
	e11:SetTarget(c9879052.sptg1)
	e11:SetOperation(c9879052.spop1)
	c:RegisterEffect(e11)
end
function c9879052.filter(c)
	return c:IsFaceup() and c:IsCanHaveCounter(0x7e2) and c:IsType(TYPE_MONSTER)
end
function c9879052.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9879052.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9879052.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9879052.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x7e2)
end
function c9879052.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	 if tc:AddCounter(0x7e2,1)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9879052,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)  
	 end
	end
end