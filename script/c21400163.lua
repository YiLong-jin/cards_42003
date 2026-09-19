--巴托尼亚-圣女贞德
function c21400163.initial_effect(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,function(c) return c:IsFusionSetCard(0x5211) and c:IsLevelAbove(5) and c:GetOriginalType()&TYPE_MONSTER~=0 end,1,127,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21400163.ContactFusionCondition(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetTarget(c21400163.ContactFusionTarget(Card.IsAbleToGrave,LOCATION_ONFIELD,0))
	e0:SetOperation(c21400163.ContactFusionOperation(Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL))
	c:RegisterEffect(e0) 
	--indes 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0x5211) and c~=e:GetHandler() end) 
	e1:SetValue(1)  
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21400163)
	e2:SetCondition(c21400163.atkcon)
	e2:SetTarget(c21400163.atktg)
	e2:SetOperation(c21400163.atkop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetCountLimit(1,21400164)
	e3:SetTarget(c21400163.thtg) 
	e3:SetOperation(c21400163.thop) 
	c:RegisterEffect(e3) 
	Duel.AddCustomActivityCounter(21400163,ACTIVITY_CHAIN,c21400163.chainfilter)
end
function c21400163.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(21400172) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400163.crmfil(c) 
	return c:IsAbleToRemove() and c:IsCode(21400172) 
end 
function c21400163.ContactFusionCondition(filter,self_location,opponent_location)
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				return c:CheckFusionMaterial(mg,nil,tp|0x200) and Duel.GetCustomActivityCount(21400163,tp,ACTIVITY_CHAIN)+Duel.GetCustomActivityCount(21400163,1-tp,ACTIVITY_CHAIN)>0 and Duel.IsExistingMatchingCard(c21400163.crmfil,tp,LOCATION_GRAVE,0,1,nil)
			end
end
function c21400163.ContactFusionTarget(filter,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c) 
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilter,tp,self_location,opponent_location,c,c,filter)
				local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|0x200)
				if #g>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					local tc=Duel.SelectMatchingCard(tp,c21400163.crmfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
					Duel.Remove(tc,POS_FACEUP,REASON_SPSUMMON)
					return true
				else return false end
			end
end
function c21400163.ContactFusionOperation(mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL+REASON_FUSION)
				g:DeleteGroup()
			end
end
function c21400163.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(tp) and at:IsSetCard(0x5211)
end
function c21400163.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x5211) end,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return g:GetCount()>0 end  
end
function c21400163.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsSetCard(0x5211) end,tp,LOCATION_MZONE,0,nil)  
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	tc=g:GetNext()
	end 
end 
function c21400163.thfil(c)  
	return c:IsAbleToHand() and c:IsCode(21400190) 
end 
function c21400163.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400163.thfil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end
function c21400163.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Duel.SelectMatchingCard(tp,c21400163.thfil,tp,LOCATION_DECK,0,1,1,nil) 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end 
end 






