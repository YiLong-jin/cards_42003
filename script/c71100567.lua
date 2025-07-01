--V城默示录~死者劫火
function c71100567.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,71100567+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71100567.actg)
	e1:SetOperation(c71100567.acop)
	c:RegisterEffect(e1)   
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(c71100567.damtg)
	e2:SetOperation(c71100567.damop)
	c:RegisterEffect(e2)
end
function c71100567.actg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71100567.acop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE)
	local x=Duel.Destroy(dg,REASON_EFFECT) 
	if x>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(71100567,3)) then 
		Duel.BreakEffect() 
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,x,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end  
end
function c71100567.rmfil(c) 
	return c:IsAbleToRemove() and c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION) and (c:IsLevel(2) or c:IsRank(2)) and c:IsFaceup() 
end 
function c71100567.actg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c71100567.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c71100567.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(c71100567.rmfil,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local x=Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	if x>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(71100567,4)) then 
		Duel.BreakEffect() 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,e:GetHandler())
		Duel.Destroy(dg,REASON_EFFECT)
	end  
end
function c71100567.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1500)
end
function c71100567.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c71100567.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=c71100567.actg1(e,tp,eg,ep,ev,re,r,rp,0) 
	local b2=c71100567.actg2(e,tp,eg,ep,ev,re,r,rp,0) 
	if chk==0 then return b1 or b2 end 
	local xtable={}   
	if b1 then table.insert(xtable,aux.Stringid(71100567,1)) end 
	if b2 then table.insert(xtable,aux.Stringid(71100567,2)) end  
	local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
	e:SetCategory(0) 
	e:SetLabel(0) 
	if xtable[op]==aux.Stringid(71100567,1) then  
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
		c71100567.actg1(e,tp,eg,ep,ev,re,r,rp,1) 
		e:SetLabel(1)
	end 
	if xtable[op]==aux.Stringid(71100567,2) then  
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE) 
		c71100567.actg2(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetLabel(2)
	end  
end 
function c71100567.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=e:GetLabel() 
	if x==0 then return end 
	if x==1 then 
		c71100567.acop1(e,tp,eg,ep,ev,re,r,rp)
	end  
	if x==2 then 
		c71100567.acop2(e,tp,eg,ep,ev,re,r,rp)
	end   
end 
