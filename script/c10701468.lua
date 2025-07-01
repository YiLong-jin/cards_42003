--次生代化石恶魔 骷髅恶魔
function c10701468.initial_effect(c)
	aux.AddCodeList(c,59419719)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c10701468.mfilter,1,1)  
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10701468.regcon)
	e1:SetOperation(c10701468.regop)
	c:RegisterEffect(e1)  
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701468,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10701468)
	e2:SetCost(c10701468.cost)
	e2:SetTarget(c10701468.target)
	e2:SetOperation(c10701468.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701468,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10701469)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10701468.thtg)
	e3:SetOperation(c10701468.thop)
	c:RegisterEffect(e3)
end
function c10701468.mfilter(c)
	return aux.IsCodeListed(c,59419719)
end
function c10701468.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10701468.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c10701468.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10701468.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(10701468) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c10701468.costfilter(c)
	return c:IsCode(59419719) and c:IsAbleToGraveAsCost()
end
function c10701468.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701468.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701468.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10701468.tgefilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x149) and c:IsAbleToGrave()
end
function c10701468.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)
	   return mc>0 and Duel.IsExistingMatchingCard(c10701468.tgefilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c10701468.tgfilter(c,race,att)
	return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsAttribute(att) and c:IsAbleToGrave()
end
function c10701468.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701468.tgefilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local race=Duel.AnnounceRace(tp,1,RACE_ALL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,cg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=cg:FilterSelect(1-tp,c10701468.tgfilter,1,1,nil,race,att)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c10701468.thfilter(c)
	return c:IsCode(12292422) and c:IsAbleToHand()
end
function c10701468.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701468.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701468.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701468.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
