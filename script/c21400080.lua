--血神啊，请注视我！
function c21400080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,21400080+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21400080.cost)
	e1:SetTarget(c21400080.target)
	e1:SetOperation(c21400080.activate)
	c:RegisterEffect(e1)
end 
function c21400080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c21400080.spfilter(c,e,tp)
	return c:IsSetCard(0x6210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400080.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400080.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	local b2=Duel.IsExistingTarget(c21400080.atkfil,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 end 
	local op=0  
	local xtable={} 
	if b1 then table.insert(xtable,aux.Stringid(21400080,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(21400080,2)) end 
	local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
	if op==1 then 
		e:SetCategory(CATEGORY_SPECIAL_SUMMON) 
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end 
	if op==2 then  
		e:SetCategory(0) 
		e:SetProperty(EFFECT_FLAG_CARD_TARGET) 
		local g=Duel.SelectTarget(tp,c21400080.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
	end 
	e:SetLabel(op) 
end
function c21400080.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if x==1 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c21400080.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end 
	end 
	if x==2 then 
		local tc=Duel.GetFirstTarget() 
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(tc:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end 
	end 
end



