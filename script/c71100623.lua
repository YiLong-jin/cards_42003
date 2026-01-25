--跨越虚伪的乐土 2026/01/19 00:38:46 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71100235,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,true,true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.thcon)
	e1:SetTarget(this.thtg)
	e1:SetOperation(this.thop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+ofs)
	e2:SetCondition(this.negcon)
	e2:SetTarget(this.negtg)
	e2:SetOperation(this.negop)
	c:RegisterEffect(e2)
end
function this.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function this.thfilter(c)
	return c:IsSetCard(0x7d2) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function this.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function this.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,this.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function this.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function this.neg_tg_f(c,code)
	return c:IsAbleToGrave() and c:IsSetCard(code)
end
function this.neg_rm_f(c)
	if c:IsSetCard(0x27a2) and c:IsSetCard(0x7d8) then return false end
	local code=0x27a2
	if c:IsSetCard(0x27a2) then code=0x7d8 end
	return c:IsAbleToRemove() and c:IsSetCard(0x27a2,0x7d8) and Duel.IsExistingMatchingCard(this.neg_tg_f,c:GetControler(),LOCATION_DECK,0,1,nil,code)
end
function this.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(this.neg_rm_f,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function this.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.neg_rm_f),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
				local rc=g:GetFirst()
				local code=0x27a2
				if rc:IsSetCard(0x27a2) then code=0x7d8 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(tp,this.neg_tg_f,tp,LOCATION_DECK,0,1,1,nil,code)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
