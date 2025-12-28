--时符「Mysterious Jack」
function c8777635.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(8777635,1)) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetCountLimit(1,8777635)   
	e1:SetTarget(c8777635.actg2) 
	e1:SetOperation(c8777635.acop2) 
	c:RegisterEffect(e1)
	 if not c8777635.global_check then
		c8777635.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING) 
		ge1:SetCondition(c8777635.checkcon)
		ge1:SetOperation(c8777635.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8777635,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,8777635)
	e2:SetCost(c8777635.thcost1)
	e2:SetTarget(c8777635.thtg1)
	e2:SetOperation(c8777635.thop1)
	c:RegisterEffect(e2)
	
end

function c8777635.checkcon(e,tp,eg,ep,ev,re,r,rp) 
	local tc=re:GetHandler()
	return tc:IsCode(8777635)
end 
function c8777635.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,8777635,0,0,0)
end
function c8777635.ckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x1ea2)   
end 
function c8777635.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1ea2)
end
function c8777635.actg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777635.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c8777635.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=Duel.GetFlagEffect(tp,8777635)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
			local dg=g:Select(tp,1,1,nil) 
		  if Duel.Destroy(dg,REASON_EFFECT)~=0 then
			local g1=Duel.GetMatchingGroup(c8777635.atkfilter,tp,LOCATION_MZONE,0,nil)
			local tc=g1:GetFirst()
			while tc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(8777635,1))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetValue(x*200)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			tc=g1:GetNext()
		  end
		end
	end 
end 


function c8777635.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c8777635.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c8777635.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end