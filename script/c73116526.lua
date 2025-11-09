--「银炼」
local s,id,o=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.excost)
	e2:SetTarget(s.extg)
	e2:SetOperation(s.exop)
	c:RegisterEffect(e2)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


function s.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.exfilter(c)
	return c:IsSetCard(0x7ae) and c:IsAbleToRemove()
end

function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

function s.setfilter(c)
	return c:IsSetCard(0x7ae) and c:IsSSetable()
end

function s.yearfilter(c)
	return c:IsFaceup() and c:IsCode(73116500)
end

function s.exop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(s.yearfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local exg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_REMOVED,0,nil)
			if #exg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local sg=exg:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.SSet(tp,sg)
				end
			end
		end
	end
end


--[[function c73116526.initial_effect(c)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)


-----------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,73116526)
	e1:SetTarget(c73116526.target1)
	e1:SetOperation(c73116526.activate1)
	c:RegisterEffect(e1)
	
	
	
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,73116526)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c73116526.target)
	e2:SetOperation(c73116526.activate)
	c:RegisterEffect(e2)
	
	
	
	
	
	
	
	
	
-----------------------------------------------------------------------------------------------------------------------
end
-----------------------------------------------------------------------------------------------------------------------





function c73116526.sfilter(c,e,tp)
	return c:IsAbleToRemove() and c:IsSetCard(0x7ae)
end

function c73116526.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116526.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c73116526.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and  Duel.IsExistingMatchingCard(c73116526.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(73116526,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c73116526.sefilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
	end
end
function c73116526.cfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCode(73116500)
end

function c73116526.sefilter(c)
	return c:IsSetCard(0x7ae) and c:IsSSetable()
end












-----------------------------------------------------------------------------------------------------------------------
function c73116526.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c73116526.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------]]