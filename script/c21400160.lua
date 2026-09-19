--巴托尼亚的绿骑士
function c21400160.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,function(c) return c:IsFusionSetCard(0x5211) and c:GetOriginalType()&TYPE_MONSTER~=0 end,function(c) return (c:IsFusionSetCard(0x5211) and c:IsRace(RACE_SPELLCASTER)) or (c:IsRace(RACE_PLANT)) and c:GetOriginalType()&TYPE_MONSTER~=0 end,false)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21400160.ContactFusionCondition(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetTarget(c21400160.ContactFusionTarget(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetOperation(c21400160.ContactFusionOperation(Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL))
	c:RegisterEffect(e0) 
	--des
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,21400160)
	e1:SetTarget(c21400160.destg) 
	e1:SetOperation(c21400160.desop) 
	c:RegisterEffect(e1)  
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21400161)
	e2:SetCondition(c21400160.discon)
	e2:SetTarget(c21400160.distg)
	e2:SetOperation(c21400160.disop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetCountLimit(1,21400162)
	e3:SetTarget(c21400160.thtg) 
	e3:SetOperation(c21400160.thop) 
	c:RegisterEffect(e3) 
	Duel.AddCustomActivityCounter(21400160,ACTIVITY_CHAIN,c21400160.chainfilter)
end
function c21400160.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(21400172) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400160.crmfil(c) 
	return c:IsAbleToRemove() and c:IsCode(21400172) 
end 
function c21400160.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200) and Duel.GetCustomActivityCount(21400160,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(21400160,1-tp,ACTIVITY_CHAIN)>0 and Duel.IsExistingMatchingCard(c21400160.crmfil,tp,LOCATION_GRAVE,0,1,nil)
			end
end
function c21400160.ContactFusionTarget(filter,self_location,opponent_location) 
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local tc=Duel.SelectMatchingCard(tp,c21400160.crmfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
					Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
					return true
				else return false end
			end
end
function c21400160.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION)
				g:DeleteGroup()
			end
end
function c21400160.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsOnField() end 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c21400160.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end 
function c21400160.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp 
end
function c21400160.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21400160.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c21400160.thfil(c)  
	return c:IsAbleToHand() and c:IsSetCard(0x5211) 
end 
function c21400160.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400160.thfil,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
end
function c21400160.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Duel.SelectMatchingCard(tp,c21400160.thfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end 
end 


