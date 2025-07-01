--機骸魔神 クイーンマジェスティ
function c10700890.initial_effect(c)
	aux.AddCodeList(c,10700895)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x27cd),c10700890.ffilter,true) 
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10700890.spcon)
	e0:SetOperation(c10700890.spop)
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
	e1:SetOperation(c10700890.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700890,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10700890.thcost)
	e2:SetTarget(c10700890.thtg)
	e2:SetOperation(c10700890.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700890,3))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,10700890)
	e3:SetTarget(c10700890.thtg2)
	e3:SetOperation(c10700890.thop2)
	c:RegisterEffect(e3)
end
function c10700890.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_MACHINE)
end
function c10700890.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c10700890.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10700890.spfilter1(c,tp)
	return c:IsSetCard(0x27cd) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10700890.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c10700890.spfilter2(c)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsFaceup()
end
function c10700890.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c10700890.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10700890.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c10700890.eqop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetValue(c10700890.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end 
end
function c10700890.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10700890.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c10700890.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if fe then loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700890.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700890.costfilter,tp,loc,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700890.thfilter(c)
	return c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c10700890.eqfilter(c,att,race,tp)
	return c:IsType(TYPE_UNION) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c10700890.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700890.thfilter,tp,LOCATION_DECK,0,1,nil) or (e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700895) and Duel.IsExistingMatchingCard(c10700890.eqfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700895) and Duel.IsExistingMatchingCard(c10700890.eqfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	end
end
function c10700890.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c10700890.thfilter,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(10700890,1)
		opval[off-1]=1
		off=off+1
	end
	if e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700895) and Duel.IsExistingMatchingCard(c10700890.eqfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		ops[off]=aux.Stringid(10700890,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10700890.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	elseif opval[op]==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	   local g=Duel.SelectMatchingCard(tp,c10700890.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	   local sc=g:GetFirst()
	   local res=sc:IsLocation(LOCATION_DECK)
	   if not Duel.Equip(tp,sc,c) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c10700890.eqlimit2)
		sc:RegisterEffect(e1)
	end
end
function c10700890.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
function c10700890.thfilter2(c)
	return c:IsSetCard(0x7cd) and c:IsAbleToHand()
end
function c10700890.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10700890.thfilter2(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToExtra()
		and Duel.IsExistingTarget(c10700890.thfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10700890.thfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c10700890.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end