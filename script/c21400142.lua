--巴托尼亚-战斗朝圣者
function c21400142.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400142,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,21400142)
	e1:SetTarget(c21400142.thtg)
	e1:SetOperation(c21400142.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetCondition(c21400142.atkcon)
	e2:SetValue(c21400142.atkval)
	c:RegisterEffect(e2)   
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,21400143)
	e3:SetCondition(c21400142.spcon)
	e3:SetTarget(c21400142.sptg)
	e3:SetOperation(c21400142.spop)
	c:RegisterEffect(e3)
end
function c21400142.thfilter1(c,tp)
	return c:IsSetCard(0x5211) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c21400142.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c21400142.thfilter2(c)
	return c:IsCode(21400172) and c:IsAbleToHand()
end
function c21400142.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400142.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c21400142.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,c21400142.thfilter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	local tc2=Duel.SelectMatchingCard(tp,c21400142.thfilter2,tp,LOCATION_DECK,0,1,1,tc1):GetFirst() 
	local g=Group.FromCards(tc1,tc2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21400142.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and bc:IsRace(RACE_FIEND)
end
function c21400142.atkval(e,c)
	return e:GetHandler():GetAttack()*2
end
function c21400142.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_FUSION+REASON_MATERIAL==REASON_FUSION+REASON_MATERIAL and not c:IsReason(REASON_RETURN)
end 
function c21400142.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c21400142.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
