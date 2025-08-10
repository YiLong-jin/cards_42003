--RHYTHM YI
function c65846953.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846953,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846953+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846953.target)
	e1:SetOperation(c65846953.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846953,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65846953.tgtg)
	e2:SetOperation(c65846953.tgop)
	c:RegisterEffect(e2)
end
function c65846953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65846953,0,TYPES_NORMAL_TRAP_MONSTER,800,800,4,RACE_PSYCHO,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65846953.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65846953,0,TYPES_NORMAL_TRAP_MONSTER,800,800,4,RACE_PSYCHO,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_SPELL)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c65846953.tgfilter(c)
	return c:IsSetCard(0x23e0) and c:IsType(0x1) and c:IsAbleToGrave()
end
function c65846953.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846953.tgfilter,tp,LOCATION_DECK,0,1,nil)  and Duel.GetFlagEffect(tp,65846953)==0 end
	Duel.RegisterFlagEffect(tp,65846953,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65846953.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65846953.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end