--君临之龙吼 2025/06/01 01:30:11 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--SearchCard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(this.sumcost)
	e2:SetTarget(this.sumtg)
	e2:SetOperation(this.sumop)
	c:RegisterEffect(e2)
end
function this.filter(c)
	return c:IsSetCard(0x37a3) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,this.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(this.thlimit)
			e1:SetLabel(tc:GetAttribute())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function this.thlimit(e,c,tp,re)
	return c:IsAttribute(e:GetLabel()) and re and re:GetHandler():IsCode(id)
end
function this.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function this.sumfilter(c)
	return c:IsSetCard(0x37a3) and c:IsSummonable(true,nil)
end
function this.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local opp=Duel.IsExistingMatchingCard(aux.NOT(Card.IsType),tp,0,LOCATION_ONFIELD,1,nil,TYPE_TOKEN)
		return Duel.IsExistingMatchingCard(this.sumfilter,tp,LOCATION_HAND,0,1,nil)
			or (opp and Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function this.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(aux.NOT(Card.IsType),tp,0,LOCATION_ONFIELD,1,nil,TYPE_TOKEN) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		g=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		g=Duel.SelectMatchingCard(tp,this.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	end
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
