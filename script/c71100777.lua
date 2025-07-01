--崩界王 古拉顿
local cm,m,o=GetID()
function cm.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x37a2),2,99,false)
	aux.AddContactFusionProcedure(c,cm.cfilter,LOCATION_ONFIELD,0,cm.sprop(c),false)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.con5)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end

function cm.cfilter(c,fc)
	return c:IsAbleToGraveAsCost()
end
function cm.sprop(c)
   return  function(g)
	 Duel.SendtoGrave(g,REASON_COST)
end
end
function cm.checkgroup(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() and c:IsSetCard(0x37a2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=2
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local sg=Duel.GetMatchingGroup(cm.checkgroup,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if #sg<1 or ct<1 then return end 
	 if ct>ft then 
	local ct= ft 
	 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=sg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		for tc in aux.Next(g) do  
		if Duel.Equip(tp,tc,c) then 
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
			end
		end 
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end

--e4
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g, fid = e:GetHandler():GetEquipGroup(), e:GetHandler():GetFieldID()
	for ec in aux.Next(g) do
		if ec:GetFlagEffect(fid) == 0 and ec:IsSetCard(0x37a2) then 
			ec:RegisterFlagEffect(fid,0,0,1)
		end
	end
end
--e5
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local g, fid, chk = e:GetHandler():GetEquipGroup(), e:GetHandler():GetFieldID(), false
	if #eg == 0 then return false end
	for ec in aux.Next(eg) do
		if not g:IsContains(ec) and ec:GetFlagEffect(fid)>0 then 
			ec:ResetFlagEffect(fid)
			chk = true 
		end
	end
	return chk
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
