--艾尔登之兽
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,24)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.limit)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2563463,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.negcon)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.limit(e,se,sp,st)
	return se:GetHandler()==e:GetHandler()
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()<1 then return false end
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not c:IsRelateToEffect(e)) or c:GetOverlayCount()<1 then return false end
	local res=Duel.RockPaperScissors(false)
	if res==tp then 
		if Duel.NegateActivation(ev) then 
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	elseif res==1-tp then 
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		e4:SetLabelObject(re)
		c:RegisterEffect(e4)  
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-1000)
	else 
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
function s.efilter(e,re)
	return re==e:GetLabelObject()
end
