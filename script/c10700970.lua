--机骸伪神 冥王星系统
function c10700970.initial_effect(c)
	aux.AddCodeList(c,10700965)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x27cd),c10700970.ffilter,true) 
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10700970.spcon)
	e0:SetOperation(c10700970.spop)
	e0:SetValue(0x17cd)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c10700970.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)   
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700970,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10700970)
	e2:SetCost(c10700970.eqcost)
	e2:SetTarget(c10700970.eqtg2)
	e2:SetOperation(c10700970.eqop2)
	c:RegisterEffect(e2) 
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700970,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,10700970)
	e3:SetTarget(c10700970.thtg)
	e3:SetOperation(c10700970.thop)
	c:RegisterEffect(e3)
end
function c10700970.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_MACHINE)
end
function c10700970.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c10700970.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10700970.spfilter1(c,tp)
	return c:IsSetCard(0x27cd) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10700970.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c10700970.spfilter2(c)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsFaceup()
end
function c10700970.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c10700970.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10700970.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c10700970.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+0x17cd and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg==2 then
		for tc in aux.Next(pg) do 
			if tc:IsLocation(LOCATION_MZONE) and Duel.Equip(tp,tc,c)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(c10700970.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end 
end
function c10700970.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10700970.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c10700970.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if fe then loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700970.costfilter,tp,loc,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700970.costfilter,tp,loc,0,2,2,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700970.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c10700970.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local loc=LOCATION_MZONE+LOCATION_GRAVE 
		if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700965) then
		   loc=loc+LOCATION_DECK+LOCATION_EXTRA 
		end
		return Duel.IsExistingMatchingCard(c10700970.eqfilter,tp,loc,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c10700970.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_MZONE+LOCATION_GRAVE 
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700965) then
		loc=loc+LOCATION_DECK+LOCATION_EXTRA 
	end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700970.eqfilter),tp,loc,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c10700970.eqlimit2)
		tc:RegisterEffect(e1)
	end
end
function c10700970.eqlimit2(e,c)
	return e:GetOwner()==c
end
function c10700970.thfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x7cd) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10700970.thfilter2(c)
	return c:IsAbleToHand() and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY 
end
function c10700970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local b1=Duel.IsExistingMatchingCard(c10700970.thfilter1,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c10700970.thfilter2,tp,LOCATION_DECK,0,1,nil)
		  and e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700965)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700970.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10700970.thfilter1,tp,LOCATION_DECK,0,nil)
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700965) then
		local eg=Duel.GetMatchingGroup(c10700970.thfilter2,tp,LOCATION_DECK,0,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end