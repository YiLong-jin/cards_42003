--魔界的门卫 萨拉
local s,id,o=GetID()
Duel.LoadScript("c99960010.lua")
function s.initial_effect(c)
		--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(99960030,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCost(shenqi_Savior.cost)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
		--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99960030,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99960030)
	e2:SetCost(shenqi_Savior.cost)
	e2:SetCondition(shenqi_Savior.con)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
s.Savior_mojie=true






function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
end

function s.thfilter(c)
	return c:IsCode(99960020) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end