--红魔之夜-蕾米莉亚
function c8777637.initial_effect(c)
	aux.AddCodeList(c,8777633)
	
	aux.EnableChangeCode(c,8777633,LOCATION_MZONE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8777637,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,8777637)
	e1:SetTarget(c8777637.tgtg)
	e1:SetOperation(c8777637.tgop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1777637) 
	e3:SetTarget(c8777637.desptg) 
	e3:SetOperation(c8777637.despop) 
	c:RegisterEffect(e3) 
	
end
function c8777637.tgfilter(c)
	return  (c:IsSetCard(0x1ea1) or(aux.IsCodeListed(c,8777633) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function c8777637.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777637.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8777637.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8777637.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end   


function c8777637.desfil(c,e,tp) 
	return Duel.GetMZoneCount(tp,c)>0 and c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(4)
end 
function c8777637.desptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c8777637.desfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	local g=Duel.SelectTarget(tp,c8777637.desfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end  
function c8777637.despop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)	
	end 
end 