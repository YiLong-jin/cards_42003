--爱之书信
function c65842068.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65842068.target)
	e1:SetOperation(c65842068.activate)
	c:RegisterEffect(e1)
end
c65842068.SetCard_ZJ_CZ=true
function c65842068.filter(c)
	return not c:IsCode(65842068) and (c:GetBaseAttack()==0 and c:IsRace(RACE_FAIRY) or c.SetCard_ZJ_CZ) and c:IsAbleToHand()
end
function c65842068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65842068.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65842068.CanEquipFilter(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function c65842068.eqfilter(c,tp)
	return c.SetCard_ZJ_CZ and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c65842068.CanEquipFilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c65842068.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65842068.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsBattlePhase()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c65842068.eqfilter),tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(65842068,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local eqg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65842068.eqfilter),tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
			local eqc=eqg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local mg=Duel.SelectMatchingCard(tp,c65842068.CanEquipFilter,tp,LOCATION_MZONE,0,1,1,nil,eqc)
			Duel.Equip(tp,eqc,mg:GetFirst())
		end
	end
end