--幻星集的宝剑 终章
function c65846662.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65846662.spcon)
	e0:SetTarget(c65846662.sptg)
	e0:SetValue(0x3eb)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(c65846662.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846662,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65846662)
	e2:SetCost(c65846662.tgcost)
	e2:SetTarget(c65846662.tgtg)
	e2:SetOperation(c65846662.tgop)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65846662,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65846662)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c65846662.tgcost)
	e3:SetTarget(c65846662.tgtg)
	e3:SetOperation(c65846662.tgop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c65846662.eftg1)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c65846662.eftg2)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)	
end
function c65846662.cfilter(c,tp)
	return  (c:IsSetCard(0x3eb) or c:IsType(TYPE_EQUIP)) and c:IsAbleToGraveAsCost()
end
function c65846662.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup()
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,99,nil)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(sg:GetCount())
end
function c65846662.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	if ct<5 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,e:GetHandler())
		if chk==0 then return #g>0 end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	end
end
function c65846662.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<5 then	
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()==0 then return end
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		if g:GetCount()==0 then return end
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c65846662.matfilter(c)
	return c:GetEquipCount()>1
end
function c65846662.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c65846662.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c65846662.spfilter1(c,tp)
	return c:GetEquipCount()>1  and Duel.IsExistingMatchingCard(c65846662.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c65846662.spfilter2(c)
	return c:IsSetCard(0x3eb) and c:IsFaceup()
end
function c65846662.spfilter3(c)
	return (c:IsSetCard(0x3eb) or c:GetEquipCount()>1) and c:IsFaceup()
end
function c65846662.spconfl(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(function(c) return c:GetEquipCount()>1 and c:IsType(0x1) end,1,nil) and g:IsExists(function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3eb) end,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c65846662.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65846662.spfilter3,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,c65846662.spconfl,true,2,2,tp,c)
	if sg then
		local pg=e:GetLabelObject()
		pg:Clear()
		pg:Merge(sg)
		return true
	else return false end
end
function c65846662.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=e:GetLabelObject():GetLabelObject()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+0x3eb and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and #pg==2 then
		for tc in aux.Next(pg) do 
			if tc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and Duel.Equip(tp,tc,c)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(c65846662.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end 
end
function c65846662.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65846662.eftg1(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and not c:IsOriginalCodeRule(65846650) and c:GetEquipGroup():IsExists(function(c) return not c:IsOriginalCodeRule(65846650) or c:IsOriginalCodeRule(65846650) and c:IsDisabled() end,1,nil) 
end
function c65846662.eftg2(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler()) and (c:GetEquipGroup():IsExists(function(c) return c:IsOriginalCodeRule(65846650) and not c:IsDisabled() end,1,nil) or c:IsOriginalCodeRule(65846650) and not c:IsDisabled())
end