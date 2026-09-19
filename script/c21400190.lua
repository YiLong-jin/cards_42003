--巴托尼亚-湖神仙女庇护
function c21400190.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400190,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(function(e) 
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),21400190)>0 end)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,21400190)
	e1:SetTarget(c21400190.target)
	e1:SetOperation(c21400190.activate)
	c:RegisterEffect(e1) 
	--to deck 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c21400190.tdtg)
	e2:SetOperation(c21400190.tdop)
	c:RegisterEffect(e2) 
	if not c21400190.global_check then
		c21400190.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c21400190.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c21400190.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsSetCard(0x5211) then 
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),21400190,RESET_PHASE+PHASE_END,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c21400190.acfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x5211)  
end 
function c21400190.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21400190.acfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400190.acfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21400190.acfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21400190.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c21400190.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1) 
	end
end
function c21400190.efilter(e,re)
	return e:GetOwner()~=re:GetOwner()
end
function c21400190.tckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x5211) and c:IsType(TYPE_MONSTER)  
end 
function c21400190.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21400190.tckfil,1,nil,tp)  
end
function c21400190.tdfil(c) 
	return c:IsSetCard(0x5211) and c:IsAbleToDeck()  
end 
function c21400190.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c21400190.tdfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function c21400190.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c21400190.tdfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) then 
		local g=Duel.SelectMatchingCard(tp,c21400190.tdfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
		g:AddCard(c) 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 



