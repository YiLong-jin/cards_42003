--神谕容器 魂梦小叶子
local m=99982180
local cm=_G["c"..m]
function cm.initial_effect(c)


		c:EnableReviveLimit()  
		aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,99982030),c99982180.FusFilter2,2,true)
	
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99982180)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c99982180.cost)
	e1:SetTarget(c99982180.target)
	e1:SetOperation(c99982180.operation)
	c:RegisterEffect(e1)
	
	
	
		--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99982180,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.todtg)
	e3:SetOperation(cm.todop)
	c:RegisterEffect(e3)
	
end

function cm.filter1(c)
	return c:IsSetCard(0x66d) and c:IsAbleToDeck()
end
function cm.todtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.todop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g>0 then
		local ct=#g
		if #g>=5 then ct=5 end
		local sg=g:FilterSelect(tp,aux.NecroValleyFilter(cm.filter1),1,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				local og=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if og>0 then
			Duel.BreakEffect() 
		Duel.SendtoGrave(c,REASON_EFFECT)
		end
end
end















function cm.FusFilter2(c)
	return c:IsSetCard(0x66d)
end










function c99982180.spfilter(c,tc,e,tp)
	return c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end

function c99982180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99982180.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,c,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c99982180.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c99982180.filter(c)
	return c:IsSetCard(0x366d) and c:IsAbleToGraveAsCost()	and c:CheckActivateEffect(false,true,false)~=nil
end
function c99982180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c99982180.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99982180.filter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c99982180.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end



