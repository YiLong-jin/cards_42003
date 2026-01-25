--由比鹤乃 突破
function c9878050.initial_effect(c)
	aux.AddCodeList(c,9877883,9877877)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9878050.ffilter,2,true)

	aux.EnableChangeCode(c,9877877,LOCATION_MZONE+LOCATION_GRAVE)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9878050,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9878050)
	e3:SetCondition(c9878050.descon)
	e3:SetTarget(c9878050.destg)
	e3:SetOperation(c9878050.desop)
	c:RegisterEffect(e3)
	

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1878050)
	e2:SetTarget(c9878050.thtg)
	e2:SetOperation(c9878050.thop)
	c:RegisterEffect(e2)
end
function c9878050.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877877)
end 


function c9878050.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end 
function c9878050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
end
function c9878050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg==0 then return end
	Duel.HintSelection(dg)
	if  Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(1) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1) 
	end
end


function c9878050.thfilter(c)
	return  c:IsAbleToGrave() and c:IsFaceup() and (aux.IsCodeListed(c,9877883) or aux.IsCodeListed(c,9877877))
end
function c9878050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878050.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c9878050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9878050.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
		end
	end
end