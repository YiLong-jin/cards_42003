--机骸魔神 地壳撼动者
function c10701126.initial_effect(c)
	aux.AddCodeList(c,10701123)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x27cd),c10701126.ffilter,true) 
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c10701126.spcon)
	e0:SetOperation(c10701126.spop)
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
	e1:SetOperation(c10701126.eqop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701126,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c10701126.condition)
	e2:SetCost(c10701126.cost)
	e2:SetTarget(c10701126.rmtg)
	e2:SetOperation(c10701126.rmop)
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701126,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c10701126.condition2)
	e3:SetCost(c10701126.cost)
	e3:SetTarget(c10701126.rmtg)
	e3:SetOperation(c10701126.rmop)
	c:RegisterEffect(e3) 
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4) 
end
function c10701126.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) or c:IsRace(RACE_MACHINE)
end
function c10701126.spcon(e,c,mc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and Duel.IsExistingMatchingCard(c10701126.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10701126.spfilter1(c,tp)
	return c:IsSetCard(0x27cd) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10701126.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c10701126.spfilter2(c)
	return (c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsFaceup()
end
function c10701126.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c10701126.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10701126.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local pg=e:GetLabelObject()
	pg:Clear()
	pg:Merge(g1)
	pg:Merge(g2)
end
function c10701126.eqop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetValue(c10701126.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		pg:Clear()
	end
end
function c10701126.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10701126.costfilter(c)
	return ((c:IsSetCard(0x7cd) and c:IsLocation(LOCATION_DECK)) or c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c10701126.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10701123)
end
function c10701126.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,10701123)
end
function c10701126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,10700950)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if fe then loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c10701126.costfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701126.costfilter,tp,loc,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,10700950)
		fe:UseCountLimit(tp)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c10701126.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10701126.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end