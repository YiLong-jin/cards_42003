--万圣夜想曲 不给糖就捣蛋
function c10701730.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x7c9),aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),true)

	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c10701730.matcheck)
	c:RegisterEffect(e0) 
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701730,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10701730)
	e1:SetCost(c10701730.spcost)
	e1:SetTarget(c10701730.sptg)
	e1:SetOperation(c10701730.spop)
	c:RegisterEffect(e1)  
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701730,2))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e0)
	e2:SetCountLimit(1,10701731)
	e2:SetCondition(c10701730.drcon)
	e2:SetTarget(c10701730.drtg)
	e2:SetOperation(c10701730.drop)
	c:RegisterEffect(e2) 
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701730,5))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10701732)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c10701730.cpcon)
	e3:SetTarget(c10701730.cptg)
	e3:SetOperation(c10701730.cpop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700815,6))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c10701730.pencon)
	e4:SetTarget(c10701730.pentg)
	e4:SetOperation(c10701730.penop)
	c:RegisterEffect(e4)
end
function c10701730.matcheck(e,c)
	local g=c:GetMaterial()
	local res=true
	local tc=g:GetFirst()
	while tc do
		res=res and ((tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup()) or tc:IsPublic())
		tc=g:GetNext()
	end
	if res then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c10701730.costfilter(c)
	return not c:IsPublic()
end
function c10701730.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701730.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10701730.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10701730,4))
end
function c10701730.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701730.setfilter(c)
	return c:IsSetCard(0x7c9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10701730.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10701730.setfilter,tp,LOCATION_DECK,0,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700815,1))then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=Duel.SelectMatchingCard(tp,c10701730.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end
function c10701730.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabelObject():GetLabel()==1
end
function c10701730.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10701730.handfilter(c)
	return not c:IsPublic()
end
function c10701730.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c10701730.handfilter,tp,0,LOCATION_HAND,1,nil) and Duel.IsChainDisablable(0)
		and Duel.SelectYesNo(1-tp,aux.Stringid(10701730,3)) then
		local g=Duel.GetMatchingGroup(c10701730.handfilter,tp,0,LOCATION_HAND,nil)
		local tc=g:GetFirst()
		while tc do
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_PUBLIC)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10701730,4))
		   tc=g:GetNext()
		end
		Duel.NegateEffect(0)
		return
	end
	if Duel.Draw(tp,2,REASON_EFFECT)>0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c10701730.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c10701730.filter(c)
	local typ=c:GetType()
	return c:IsFaceupEx() and c:IsSetCard(0x7c9) and (typ==TYPE_SPELL or typ==TYPE_TRAP)
		and c:CheckActivateEffect(false,true,false)
end
function c10701730.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c10701730.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c10701730.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	local te,ceg,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c10701730.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not (te and te:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10701730.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c10701730.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c10701730.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end