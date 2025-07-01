--キガイマシン・アテナ・フォール
function c10700910.initial_effect(c)
	aux.AddCodeList(c,10700915)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x27cd),c10700910.ffilter,true) 
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10700910.spcon)
	e0:SetOperation(c10700910.spop)
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
	e1:SetOperation(c10700910.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700910,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10700910.discon)
	e2:SetCost(c10700910.discost)
	e2:SetTarget(c10700910.distg)
	e2:SetOperation(c10700910.disop)
	c:RegisterEffect(e2)  
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700910,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10700910.rmcon)
	e5:SetTarget(c10700910.rmtg)
	e5:SetOperation(c10700910.rmop)
	c:RegisterEffect(e5) 
end
function c10700910.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_MACHINE)
end
function c10700910.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c10700910.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10700910.spfilter1(c,tp)
	return c:IsSetCard(0x27cd) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10700910.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c10700910.spfilter2(c)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsFaceup()
end
function c10700910.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c10700910.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10700910.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c10700910.eqop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetValue(c10700910.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end
end
function c10700910.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10700910.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10700910.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c10700910.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if fe then loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10700910.costfilter,tp,loc,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700910.costfilter,tp,loc,0,2,2,nil)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700910.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10700910.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c10700910.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_QUICKPLAY)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10700915)
end
function c10700910.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,nil)
end
function c10700910.rmop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if cg:GetCount()>0 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		local opt=0
		if g1:GetCount()>0 and g2:GetCount()>0 then
			opt=Duel.SelectOption(tp,aux.Stringid(10700910,3),aux.Stringid(10700910,4))
		elseif g1:GetCount()>0 then
			opt=0
		elseif g2:GetCount()>0 then
			opt=1
		else
			return
		end
		local sg=nil
		if opt==0 then
			sg=g1:RandomSelect(tp,1)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			sg=g2:Select(tp,1,1,nil)
		end
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end