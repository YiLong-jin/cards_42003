--幸运魔人的赌博城
function c90309075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90309075+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c90309075.activate)
	c:RegisterEffect(e1)
	--dice roll
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90309075,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c90309075.dicetg)
	e2:SetOperation(c90309075.diceop)
	c:RegisterEffect(e2)
end
c90309075.toss_dice=true
function c90309075.thfilter(c)
	return c:IsCode(90309064) and c:IsAbleToHand()
end
function c90309075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90309075.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(90309075,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c90309075.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c90309075.diceop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	for p=turnp,1-turnp,1-turnp-turnp do
		local dice=Duel.TossDice(p,1)
		if dice>=1 and dice<=6 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			local sc=g:GetFirst()
			while sc do
				local atk=sc:GetAttack()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(dice<5 and EFFECT_UPDATE_ATTACK or EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(({-500,-1000,-1500,-2000,math.ceil(atk/2),atk*0})[dice])
				sc:RegisterEffect(e1)
				sc=g:GetNext()
			end
		end
	end
end
