--梦幻般的独奏·纳穆
function c9879061.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c9879061.synfilter1),1)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(c9879061.atk)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)  

	
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879061,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9879061)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=3 end)
	e3:SetTarget(c9879061.destg)
	e3:SetOperation(c9879061.desop)
	c:RegisterEffect(e3)
end
function c9879061.synfilter1(c)
	return c:IsCanHaveCounter(0x7e2)
end

function c9879061.atk(e,c)
	return e:GetHandler():GetCounter(0x7e2)*1000
end


function c9879061.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9879061.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
