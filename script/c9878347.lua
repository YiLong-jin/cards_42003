--银月鬼杀式神-返魂蝶
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9877864,9877870)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
		return se:IsHasType(EFFECT_TYPE_ACTIONS)end)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetCondition(cm.ckcon)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
	--atk 
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(-1500)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end

function cm.ckfil(c)
	return c:IsFaceup() and c:IsCode(9877864,9878346)
end

function cm.ckcon(e)
	return not Duel.IsExistingMatchingCard(cm.ckfil,e:GetHandlerPlayer(),0x04,0,1,nil)
end
function cm.desfil(c) 
	return c:IsFaceup() and c:IsDisabled()  
end 
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	local g=Duel.SelectTarget(tp,cm.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if Duel.GetFirstTarget() then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON|e:GetCategory())
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetFirstTarget(),1,0,0)
	end
end

function cm.exckfilter(c)
	return c:IsFaceup() and c:IsCode(9877870)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
	local ck=false
	if not Duel.IsPlayerCanDraw(tp,1) or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==1 then
		if Duel.Recover(tp,1000,REASON_EFFECT) then ck=true end
	else
		if Duel.Draw(tp,1,REASON_EFFECT) then ck=true end
	end
	if ck and Duel.IsExistingMatchingCard(cm.exckfilter,tp,0x08,0,1,nil) and Duel.GetMZoneCount(tp)>0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToChain() then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
   end
end