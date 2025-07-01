--孽驱君主 玛门
function c10700676.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,10700666)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10700676.slcon)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2) 
	--destroy and set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10700676.target)
	e3:SetOperation(c10700676.operation)
	c:RegisterEffect(e3)  
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700676,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,10700676+1)
	e4:SetTarget(c10700676.thtg)
	e4:SetOperation(c10700676.thop)
	c:RegisterEffect(e4)  
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700676,1))
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,10700676)
	e5:SetCondition(c10700676.tecon)
	e5:SetTarget(c10700676.tetg)
	e5:SetOperation(c10700676.teop)
	c:RegisterEffect(e5) 
end
function c10700676.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:GetOriginalLeftScale()==6
end
function c10700676.slcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700676.scfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c10700676.desfilter(c)
	return c:IsFaceup()
end
function c10700676.filter(c)
	return c:IsSetCard(0x7cb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10700676.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c10700676.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c10700676.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10700676.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10700676.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10700676.filter,tp,LOCATION_DECK,0,1,1,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10700676.thfilter(c)
	return c:IsSetCard(0x7cb) and c:IsAbleToHand()
end
function c10700676.thfilter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c10700676.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c10700676.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c10700676.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700676.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10700676.thfilter,tp,LOCATION_DECK,0,1,nil)
	if e:GetHandler():IsSummonLocation(LOCATION_EXTRA) then
		local eg=Duel.GetMatchingGroup(c10700676.thfilter1,tp,LOCATION_DECK,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c10700676.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA+LOCATION_HAND)
end
function c10700676.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)  and c:IsAbleToExtra()
end
function c10700676.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700676.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700676.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700676,3))
	local g=Duel.SelectMatchingCard(tp,c10700676.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end