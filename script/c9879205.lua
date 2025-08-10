--鲑鱼子二宵
function c9879205.initial_effect(c)
	aux.AddCodeList(c,9879202)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),c9879205.ntfilter,1,1)
	c:EnableReviveLimit() 
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879205,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9879205)
	e1:SetCondition(c9879205.thcon)
	e1:SetTarget(c9879205.thtg)
	e1:SetOperation(c9879205.thop)
	c:RegisterEffect(e1)
	
	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9879205,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_QUICK_O) 
	e14:SetCode(EVENT_FREE_CHAIN) 
	e14:SetRange(LOCATION_MZONE)
	e14:SetHintTiming(0,TIMING_END_PHASE)
	e14:SetCountLimit(1,1879205)
	e14:SetTarget(c9879205.tgtg) 
	e14:SetOperation(c9879205.tgop) 
	c:RegisterEffect(e14) 
end
function c9879205.ntfilter(c)
	return not c:IsType(TYPE_TUNER) and aux.IsCodeListed(c,9879202)
end


function c9879205.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9879205.thfilter(c)
	return aux.IsCodeListed(c,9879202) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand()
end
function c9879205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879205.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879205.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879205.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9879205.tgfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,9879202) and c:IsFaceup()
end 
function c9879205.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879205.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c9879205.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879205.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	local g1=Duel.GetMatchingGroup(c9879205.f,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and g1:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	  if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)~=0 and Duel.SelectYesNo(tp,aux.Stringid(9879205,2)) then 
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(c,nseq)
	   end
	end 
end 