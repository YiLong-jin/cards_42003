--秘源杀手 希贝尔
function c71100302.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100302,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,71100302)
	e1:SetTarget(c71100302.dstg)
	e1:SetOperation(c71100302.dsop)
	c:RegisterEffect(e1)  
	--pos 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100302,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e2:SetCondition(c71100302.poscon) 
	e2:SetOperation(c71100302.posop) 
	c:RegisterEffect(e2) 
end
function c71100302.ckfil(c) 
	return c:IsSetCard(0x37de) and c:IsType(TYPE_MONSTER) 
end 
function c71100302.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100302.ckfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c71100302.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 
function c71100302.poscon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if not a then return false end
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end  
	if not a then return false end
	local sc=a:GetBattleTarget()
	return a:IsSetCard(0x7de) and sc and sc:IsCanChangePosition() and not sc:IsDefensePos() and c:GetFlagEffect(71100302)==0 
end 
function c71100302.posop(e,tp,eg,ep,ev,re,r,rp) 
	if not Duel.GetAttackTarget() then return end
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a:IsControler(1-tp) then a=Duel.GetAttackTarget() end	
	local sc=a:GetBattleTarget()	
	if c:GetFlagEffect(71100302)==0 and Duel.SelectYesNo(tp,aux.Stringid(71100302,2)) then 
	Duel.ChangePosition(sc,POS_FACEUP_DEFENSE) 
	c:RegisterFlagEffect(71100302,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end 
end 





