--进化虫·孔耐蜥
function c10701186.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10701186+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10701186.spcon)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10701187)
	e2:SetTarget(c10701186.thtg)
	e2:SetOperation(c10701186.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)   
end
function c10701186.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE+RACE_DINOSAUR+RACE_DRAGON)
end
function c10701186.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701186.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10701186.thfilter(c)
	return (((aux.IsSetNameMonsterListed(c,0x304e) or aux.IsSetNameMonsterListed(c,0x604e)) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(5338223,8632967,14154221,34026662,88760522,78933589,24362891,74100225,93504463,64815084)) and c:IsAbleToHand()
end
function c10701186.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701186.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701186.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701186.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end