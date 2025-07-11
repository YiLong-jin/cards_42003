--幸福时刻 首里
local m=9877797
local cm=_G["c"..m]
function c9877797.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e11=Effect.CreateEffect(c) 
	e11:SetCategory(CATEGORY_TODECK)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,1877797)
	e11:SetCondition(c9877797.eqcon)
	e11:SetTarget(c9877797.tdtg) 
	e11:SetOperation(c9877797.tdop) 
	c:RegisterEffect(e11) 

	
end
function cm.tgfilter(c)
	return ((c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE))  or c:IsSetCard(0x27eb) ) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end   


function c9877797.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end
function c9877797.tgfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x27eb) and c:IsAbleToDeck()
end
function c9877797.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877797.tgfilter1,tp,LOCATION_REMOVED,0,3,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED) 
end 
function c9877797.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877797.tgfilter1,tp,LOCATION_REMOVED,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,3,3,nil) 
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 