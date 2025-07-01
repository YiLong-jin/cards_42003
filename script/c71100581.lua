--死灵舞者 人偶木乃伊
function c71100581.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x7d8),2,2)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e1:SetTarget(function(e,c) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsAttackPos() end)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e2:SetTarget(function(e,c) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsAttackPos() end) 
	e2:SetValue(0)
	c:RegisterEffect(e2) 
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71100581,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,71100581)
	e3:SetTarget(c71100581.mvtg)
	e3:SetOperation(c71100581.mvop)
	c:RegisterEffect(e3)
	--to grave 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71100581,2)) 
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,71100581)
	e4:SetCondition(c71100581.tgcon)
	e4:SetTarget(c71100581.tgtg)
	e4:SetOperation(c71100581.tgop)
	c:RegisterEffect(e4)
end 
function c71100581.mvfil(c)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0 
end 
function c71100581.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c71100581.mvfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71100581.mvfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c71100581.mvop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	local p=tc:GetControler()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(p,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)  
	local s=0 
	local nseq=0 
	if p==tp then 
		s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0) 
		nseq=math.log(s,2)
	else 
		s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0) 
		nseq=math.log(bit.rshift(s,16),2)
	end  
	Duel.MoveSequence(tc,nseq)
end
function c71100581.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_CONTINUOUS) and re:IsActiveType(TYPE_TRAP)   
end 
function c71100581.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
	local sg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c71100581.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(e:GetHandler()) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end 
end 

