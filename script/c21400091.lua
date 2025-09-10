--纳垢神尊大不净者
function c21400091.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,function(c) return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) end,3,127,true)
	aux.EnablePendulumAttribute(c,false)
	--th 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400091) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetTarget(c21400091.thtg)
	e1:SetOperation(c21400091.thop)
	c:RegisterEffect(e1)
	--destroy all
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetCondition(c21400091.descon)
	e2:SetTarget(c21400091.destg)
	e2:SetOperation(c21400091.desop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c21400091.pencon)
	e3:SetTarget(c21400091.pentg)
	e3:SetOperation(c21400091.penop)
	c:RegisterEffect(e3)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c21400091.acop)
	c:RegisterEffect(e1)  
	--dam 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADD_COUNTER)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c21400091.damcon)
	e1:SetOperation(c21400091.damop)
	--c:RegisterEffect(e1)   
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)  
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,11400091)
	e2:SetCondition(c21400091.spcon)
	e2:SetCost(c21400091.spcost)
	e2:SetTarget(c21400091.sptg)
	e2:SetOperation(c21400091.spop)
	c:RegisterEffect(e2)  
	if not c21400091.global_check then
		c21400091.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21400091.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c21400091.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsCode(21400098) then 
		Duel.RegisterFlagEffect(rp,21400091,RESET_PHASE+PHASE_END,0,1) 
	end
end
function c21400091.thfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c21400091.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetMaterialCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c21400091.thfilter,tp,LOCATION_DECK,0,x,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,x,tp,LOCATION_DECK)
end
function c21400091.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=e:GetHandler():GetMaterialCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400091.thfilter,tp,LOCATION_DECK,0,x,x,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
	end
end
function c21400091.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21400091)~=0  
end 
function c21400091.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c21400091.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21400091.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c21400091.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c21400091.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c21400091.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		e:GetHandler():AddCounter(0x1077,1)
	end
end
function c21400091.damcon(e,tp,eg,ep,ev,re,r,rp) 
	if e:GetLabel()==nil then 
		return e:GetHandler():GetCounter(0x1077)>0   
	else 
		return e:GetHandler():GetCounter(0x1077)>e:GetLabel()
	end 
end 
function c21400091.damop(e,tp,eg,ep,ev,re,r,rp) 
	e:SetLabel(e:GetHandler():GetCounter(0x1077))
	Duel.Hint(HINT_CARD,0,21400091) 
	Duel.Damage(1-tp,500,REASON_EFFECT) 
end 
function c21400091.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp 
end
function c21400091.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1077,7,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1077,7,REASON_COST) 
end
function c21400091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400091.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
