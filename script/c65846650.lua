--幻星集的宝剑 扉页
function c65846650.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3eb),c65846650.matfilter,true) 	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65846650.spcon)
	e0:SetTarget(c65846650.sptg)
	e0:SetValue(0x3eb)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CAN_FORBIDDEN+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(c65846650.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65846650)
	e2:SetTarget(c65846650.eqtg)
	e2:SetOperation(c65846650.eqcop)
	c:RegisterEffect(e2)
end
function c65846650.matfilter(c)
	return c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x3eb)
end
function c65846650.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c65846650.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c65846650.spfilter1(c,tp)
	return c65846650.matfilter(c) and Duel.IsExistingMatchingCard(c65846650.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c65846650.spfilter2(c)
	return c:IsSetCard(0x3eb) and c:IsFaceup()
end
function c65846650.spfilter3(c)
	return (c:IsSetCard(0x3eb) or c65846650.matfilter(c)) and c:IsFaceup()
end
function c65846650.spconfl(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(c65846650.matfilter,1,nil) and g:IsExists(c65846650.spfilter2,1,nil)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c65846650.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65846650.spfilter3,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,c65846650.spconfl,true,2,2,tp,c)
	if sg then
		local pg=e:GetLabelObject()
		pg:Clear()
		pg:Merge(sg)
		return true
	else return false end
end
function c65846650.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c65846650.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c65846650.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c65846650.eqop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetValue(c65846650.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end 
end
function c65846650.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65846650.eqfilter(c,ec,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3eb) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() and (c:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE) and c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c65846650.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65846650.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65846650.eqcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65846651,1))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846650.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c,tp)
	if g:GetCount()>0 and Duel.Equip(tp,g:GetFirst(),c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c65846650.eqlimit)
		g:GetFirst():RegisterEffect(e1)
	end
end
