--人偶怪兽 珂珑公主
function c10701750.initial_effect(c)
	aux.AddCodeList(c,75574498)
	--code
	aux.EnableChangeCode(c,75574498,LOCATION_MZONE+LOCATION_GRAVE)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c10701750.XyzCondition)
	e0:SetTarget(c10701750.XyzTarget)
	e0:SetOperation(c10701750.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)  
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(c10701750.lvtg)
	e1:SetValue(c10701750.lvval)
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701750,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10701750)
	e2:SetCondition(c10701750.spcon)
	e2:SetTarget(c10701750.sptg)
	e2:SetOperation(c10701750.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c10701750.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701750,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10701751)
	e4:SetCost(c10701750.thcost)
	e4:SetTarget(c10701750.thtg)
	e4:SetOperation(c10701750.thop)
	c:RegisterEffect(e4)
end
--Xyz Summon(normal)
function c10701750.Xyzfilter2(c,sc)
	return c:IsSetCard(0x15a) and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c10701750.Xyzfilter(c,sc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c10701750.XyzCondition(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if og then return Duel.CheckXyzMaterial(c,aux.TRUE,4,2,99,og)
	else
		local mg=Duel.GetMatchingGroup(c10701750.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		local og=Duel.GetMatchingGroup(c10701750.Xyzfilter2,tp,LOCATION_HAND,0,nil,c)
		og:Merge(mg)
		return Duel.CheckXyzMaterial(c,aux.TRUE,4,2,99,og)
	end
	
end
function c10701750.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	local g=Group.CreateGroup()
	if og then 
		g=Duel.SelectXyzMaterial(tp,c,aux.TRUE,4,2,99,og)
	else
		local mg=Duel.GetMatchingGroup(c10701750.Xyzfilter,tp,LOCATION_MZONE,0,nil,c)
		local og=Duel.GetMatchingGroup(c10701750.Xyzfilter2,tp,LOCATION_HAND,0,nil,c)
		og:Merge(mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=og:Select(tp,2,99,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c10701750.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og and not min then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		e:SetLabel(0)
		local mg=e:GetLabelObject()
		if mg:Filter(Card.IsLocation,nil,LOCATION_HAND):GetCount()~=0 then 
			e:SetLabel(1)
		end
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		if e:GetLabel()==1 then Duel.ShuffleHand(tp) end
		mg:DeleteGroup()
	end
end
function c10701750.lvtg(e,c)
	return c:IsSetCard(0x15a)
end
function c10701750.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 4
	else return lv end
end
function c10701750.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c10701750.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c10701750.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10701750.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount() 
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701750.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10701750.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c:GetOverlayCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local max_ct=math.min(ct,ft)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701750.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max_ct)
		if sg and #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c10701750.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10701750.thfilter(c)
	return (aux.IsCodeListed(c,75574498) or c:IsCode(44190146,67331360)) and c:IsAbleToHand()
end
function c10701750.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701750.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701750.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701750.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end