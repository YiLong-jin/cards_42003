--恐虐暴行·屠
function c21400037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c21400037.atkcon)
	e1:SetTarget(c21400037.atktg)
	e1:SetOperation(c21400037.atkop)
	c:RegisterEffect(e1) 
end
function c21400037.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then return end
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x6210) and rc:IsControler(tp)
end 
function c21400037.atkfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x6210) 
end  
function c21400037.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21400037.atkfil(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c21400037.atkfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c21400037.atkfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21400037.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
	end 
end  







