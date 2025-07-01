--翼龙·疑义之龙
function c21071202.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21071202,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c21071202.condition)
	e1:SetTarget(c21071202.target)
	e1:SetOperation(c21071202.activate)
	c:RegisterEffect(e1)
end

function c21071202.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and rp==1-tp 
end
function c21071202.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c21071202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21071202)==0 end
	Duel.RegisterFlagEffect(tp,21071202,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,eg,1,0,0)
	
end
function c21071202.activate(e,tp,eg,ep,ev,re,r,rp)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c21071202.filter,1-tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	
	end
end