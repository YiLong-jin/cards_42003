--猎龙鹰武装mk2-梅莉
function c9877635.initial_effect(c)
	c:SetSPSummonOnce(9877635)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9877635.matfilter,2,2)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c9877635.atkval)
	c:RegisterEffect(e1)


	local e11=Effect.CreateEffect(c)  
	e11:SetDescription(aux.Stringid(9877635,1))  
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_PAY_LPCOST)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCountLimit(1)   
	e11:SetTarget(c9877635.settg)  
	e11:SetOperation(c9877635.setop)  
	c:RegisterEffect(e11)  
	
end
c9877635.SetCard_AY_ML=true 
function c9877635.matfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end
function c9877635.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_TRAP)*200
end


function c9877635.setfilter(c)  
	return c:IsSetCard(0x17ec) and c:GetType()==TYPE_TRAP and c:IsSSetable() 
end  
function c9877635.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c9877635.setfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function c9877635.setop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9877635.setfilter),tp,LOCATION_DECK,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.SSet(tp,tc)~=0 then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
	end  
end  