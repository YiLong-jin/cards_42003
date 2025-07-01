--净源审判 源力抽取
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.setcon)
	e3:SetCost(cm.setcost)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x47df,0x7de)
end
function cm.ac_chk(ev,tp,chk,e)
	local a_chk=chk-1
	local dg=Group.CreateGroup()
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp==tp then
			a_chk=a_chk-1
		else 
			a_chk=a_chk+1  
			local tc=te:GetHandler()
			if chk==0 then 
				if tc:IsDestructable(e) then dg:AddCard(tc) end
				if Duel.IsChainNegatable(i) then ng:AddCard(tc) end
			elseif chk<0 then
				Duel.NegateActivation(i)
			elseif chk>0 and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then 
				dg:AddCard(tc)
			end
		end
	end
	if #dg>0 and chk>0 then Duel.Destroy(dg,REASON_EFFECT) end
	return ng,dg,a_chk
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	local ng,dg,a_chk=cm.ac_chk(ev,tp,0,e)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and chain~=0 and (#ng>0 and a_chk<0) or (#dg>0 and a_chk>0) end
	if a_chk>0 then 
		Duel.SetTargetCard(dg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	elseif a_chk<0 then 
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local _,_,a_chk=cm.ac_chk(ev,tp,0,e)
	cm.ac_chk(ev,tp,a_chk,e)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.setfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x47df) and c:IsAbleToGraveAsCost()
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) or not c:IsSSetable() then return end
	Duel.SSet(tp,c)
end
