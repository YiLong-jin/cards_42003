--亡灵海岸旗舰-贝丝女王号
function c21400124.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c21400124.mfilter1,c21400124.mfilter2,nil,c21400124.mfilter3,1,99)
	c:EnableReviveLimit()  
	--to hand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400124) 
	e1:SetTarget(c21400124.thtg)
	e1:SetOperation(c21400124.thop)
	c:RegisterEffect(e1)  
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400124)
	e2:SetCondition(c21400124.discon) 
	e2:SetTarget(c21400124.distg)
	e2:SetOperation(c21400124.disop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,31400124)
	e3:SetCondition(c21400124.spcon)
	e3:SetTarget(c21400124.sptg)
	e3:SetOperation(c21400124.spop)
	c:RegisterEffect(e3)
end
function c21400124.mfilter1(c)
	return c:IsSetCard(0xb210)
end
function c21400124.mfilter2(c,syncard)
	return c:IsCode(21400118) 
end
function c21400124.mfilter3(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c21400124.thfilter(c)
	return c:IsCode(21400135) and c:IsAbleToHand()
end
function c21400124.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21400124.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400124.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c21400124.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end 
function c21400124.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c21400124.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local dc=Duel.TossDice(tp,1) 
	if dc==1 or dc==2 then 
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end 
	if dc==3 or dc==4 then 
		Duel.NegateEffect(ev)
	end 
	if dc==5 or dc==6 then 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end
function c21400124.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetReasonPlayer()==1-tp 
end 
function c21400124.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(21400120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400124.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400124.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c21400124.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21400124.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end


