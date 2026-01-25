--淘气仙星·奈莉菲尔瑞
function c10701601.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c10701601.lcheck)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701601,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10701601)
	--e1:SetCost(c10701601.setcost)
	e1:SetTarget(c10701601.settg)
	e1:SetOperation(c10701601.setop)
	c:RegisterEffect(e1)   
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c10701601.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10701601.damcon)
	e3:SetOperation(c10701601.damop)
	c:RegisterEffect(e3) 
	--spsummon
	local e5=Effect.CreateEffect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	e5:SetDescription(aux.Stringid(10701601,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,10701602)
	e5:SetLabelObject(e0)
	e5:SetTarget(c10701601.sptg)
	e5:SetOperation(c10701601.spop)
	c:RegisterEffect(e5)
end
function c10701601.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xfb)
end
function c10701601.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10701601.setfilter(c)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10701601.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701601.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10701601.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701601.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		if Duel.SSet(tp,g)~=0 then
		local dam=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*200
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c10701601.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) then
		e:GetHandler():RegisterFlagEffect(10701601,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
end
function c10701601.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(10701601)~=0 
end
function c10701601.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10701601)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function c10701601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local se=e:GetLabelObject():GetLabelObject()
	if chk==0 then return (se==nil or c:GetReasonEffect()~=se) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701601.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
