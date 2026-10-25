--向往光明的骑士救世主们
function c9879473.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c) return c:IsRace(RACE_WARRIOR) or c:IsSetCard(0x1661) end,3,3)
	--cannot be link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0) 
	--tgh  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879473,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9879473)
	e1:SetTarget(c9879473.thtg)
	e1:SetOperation(c9879473.thop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9879473.eqcon)
	e2:SetTarget(c9879473.eqtg)
	e2:SetOperation(c9879473.eqop)
	c:RegisterEffect(e2)
end
function c9879473.tgfil(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function c9879473.thfilter(c)
	return (c:IsSetCard(0x1661,0x669) or (c:IsRace(RACE_WARRIOR) and c:IsAttack(500))) and c:IsAbleToHand()
end
function c9879473.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879473.tgfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c9879473.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879473.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c9879473.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			local g=Duel.SelectMatchingCard(tp,c9879473.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c9879473.eckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetPreviousEquipTarget()~=nil  
end 
function c9879473.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9879473.eckfil,1,nil)  
end 
function c9879473.eqfilter(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(ec)
end 
function c9879473.eqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c9879473.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler())  end 
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9879473.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if not c:IsRelateToEffect(e) then return end 
	local tc=Duel.SelectMatchingCard(tp,c9879473.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c):GetFirst()
	if tc then 
		Duel.Equip(tp,tc,c) 
	end
end






