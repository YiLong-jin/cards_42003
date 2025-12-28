--憩之妖梦
function c8777605.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8777605,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,8777605)
	e1:SetCondition(c8777605.spcon)
	e1:SetTarget(c8777605.sptg)
	e1:SetOperation(c8777605.spop)
	c:RegisterEffect(e1) 
end

function c8777605.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x1eaa)
end 
function c8777605.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c8777605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c8777605.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c8777605.tgfil1,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(8777605,0)) then
		local xg=g:Select(tp,1,1,nil) 
			Duel.SendtoHand(xg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,xg)
		end
	end
end 