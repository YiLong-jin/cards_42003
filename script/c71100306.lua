--秘源异兽 阿比斯蠕虫
function c71100306.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100306,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,71100306)
	e1:SetCondition(c71100306.spcon)
	e1:SetTarget(c71100306.sptg)
	e1:SetOperation(c71100306.spop)
	c:RegisterEffect(e1)	
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11100306)
	e2:SetCondition(c71100306.thcon)
	e2:SetTarget(c71100306.thtg)
	e2:SetOperation(c71100306.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_DESTROYED)  
	c:RegisterEffect(e3)
end
function c71100306.spcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and rc:IsSetCard(0x7de) 
end
function c71100306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c71100306.reptg)
	e1:SetValue(c71100306.repval) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	--c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_REMOVED))
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	--to ha 
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e5)
	--sp 
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e6)
end
function c71100306.repfilter(c,tp)
	return c:IsControler(1-tp) and c:GetDestination()==LOCATION_REMOVED and not c:IsReason(REASON_REDIRECT) 
end
function c71100306.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c71100306.repfilter,1,nil,tp) end
	local g=eg:Filter(c71100306.repfilter,nil,tp)
	Duel.Remove(g,POS_FACEDOWN,REASON_REDIRECT+REASON_EFFECT)
	return true
end
function c71100306.repval(e,c)
	return false
end
function c71100306.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReasonPlayer()==1-tp 
end
function c71100306.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c71100306.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100306.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c71100306.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100306.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




