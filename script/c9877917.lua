--谣言纱奈
local cm,m=GetID()

cm.Uwasa=true
function c9877917.initial_effect(c)
	aux.AddCodeList(c,9877913)
	aux.AddLinkProcedure(c,c9877917.lfcheck,2,99)
	c:EnableReviveLimit()

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9877917.efilter)
	c:RegisterEffect(e3)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsRace),RACE_SPELLCASTER))
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877917,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9877917)
	e2:SetCondition(c9877917.descon)
	e2:SetTarget(c9877917.destg)
	e2:SetOperation(c9877917.desop)
	c:RegisterEffect(e2)
	
end
function c9877917.lfcheck(c)
	return aux.IsCodeListed(c,9877913)
end
function c9877917.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end

function c9877917.setfilter(c)  
	return  c:GetType()==TYPE_TRAP and c:IsSSetable() 
end  
function c9877917.descon(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function c9877917.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9877917.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if (tc:GetType()==TYPE_TRAP or tc:GetType()==TYPE_SPELL) and Duel.IsExistingMatchingCard(c9877917.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877917,2))  then
		  local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9877917.setfilter),tp,LOCATION_DECK,0,1,1,nil)
			local bc=g1:GetFirst()  
				if bc then  
					Duel.SSet(tp,bc)
				end  
		end 
	end
end
