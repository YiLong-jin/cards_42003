--The salvation of the Savior
function c99970150.initial_effect(c)
	
		aux.AddLinkProcedure(c,c99970150.mfilter,1,1)
	c:EnableReviveLimit()
	
	  --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970150,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,99970150)
	e2:SetCondition(c99970150.condition)
	e2:SetTarget(c99970150.thtg)
	e2:SetOperation(c99970150.thop)
	c:RegisterEffect(e2)
	
	
	
	
	
	
		--fusion substitute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e1:SetCondition(c99970150.subcon)
	c:RegisterEffect(e1)
		--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetCost(c99970150.spcost)
	e3:SetOperation(c99970150.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(99970150,ACTIVITY_SPSUMMON,c99970150.limcoun) 
end
function c99970150.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(99970150,tp,ACTIVITY_SPSUMMON)==0
end
function c99970150.spop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c99970150.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c99970150.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (c:IsRace(RACE_FIEND) and not (c:IsSetCard(0x676) or c:IsSetCard(0x671)))
end
function c99970150.limcoun(c)
	return (not c:IsRace(RACE_FIEND)) or (c:IsSetCard(0x676) or c:IsSetCard(0x671))
end












function c99970150.mfilter(c)
	return (c:IsAttack(1500) and c:IsDefense(1500) and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_WARRIOR))) or (c:IsDefense(1800) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT))
end









function c99970150.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function c99970150.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99970150.thfilter(c)
	return c:IsSetCard(0x1661) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970150.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970150.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970150.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

