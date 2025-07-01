--死灵法师 再临的爱
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(this.rmtg)
	e2:SetOperation(this.rmop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(17589298,0))
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,id+ofs)
	e4:SetCondition(this.retcon)
	e4:SetTarget(this.rettg)
	e4:SetOperation(this.retop)
	c:RegisterEffect(e4)
end
function this.filter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (not (c:IsRace(RACE_FIEND) or c:IsRace(RACE_ZOMBIE))) and c:IsAbleToRemove()
end
function this.spf(c,e,tp)
	return not c:IsCode(id) and c:IsSetCard(0x7d1,0x7d8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return this.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(this.spf,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,this.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if c:IsLocation(LOCATION_HAND) then 
		g:AddCard(c)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function this.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local rg=Group.CreateGroup()
	if tc and tc:IsRelateToEffect(e) then rg:AddCard(tc) end
	if c:IsRelateToEffect(e) then rg:AddCard(c) end
	if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,this.spf,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then 
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function this.retcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst()==e:GetHandler() 
end
function this.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function this.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,c)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e5:SetTargetRange(1,0)
		e5:SetTarget(this.splimit)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
end
function this.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
