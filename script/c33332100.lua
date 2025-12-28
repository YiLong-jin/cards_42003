--澄炎之狂徒 慈华
local this,id,ofs=GetID()
function c33332100.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(c33332100.mfilter),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33332100,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33332100)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c33332100.rmtg)
	e1:SetOperation(c33332100.rmop)
	c:RegisterEffect(e1)
	--ReturnToField
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	
	e6:SetCountLimit(1,id+1000000)
	e6:SetCondition(this.pencon)
	e6:SetTarget(this.pentg)
	e6:SetOperation(this.penop)
	c:RegisterEffect(e6)

	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE) 
	e3:SetTarget(c33332100.psptg) 
	e3:SetOperation(c33332100.pspop) 
	c:RegisterEffect(e3) 
end
function c33332100.mfilter(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE)  
end
--remove
function c33332100.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332100.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33332100.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33332100.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c33332100.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local dam=tc:GetLevel()
		Duel.Damage(1-tp,dam*300,REASON_EFFECT)
	end
end
--return
function this.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function this.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function this.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,1,nil)
	if Duel.Destroy(tg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--extra spsummon
function c33332100.sctfil(c) 
	if c:IsLocation(LOCATION_EXTRA) then 
	return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(1) and c:IsFaceup() 
	else return c:IsAbleToGrave() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(1) end 
end 
function c33332100.sctgck(g,tp) 
	return g:CheckWithSumGreater(Card.GetLevel,9) and Duel.GetMZoneCount(tp,g)>0 
end 
function c33332100.pspcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if chk==0 then return  end 
	local sg=g:SelectSubGroup(tp,c33332100.sctgck,false,1,99,tp) 
	Duel.SendtoGrave(sg,REASON_COST) 
end 
function c33332100.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(c33332100.sctgck,1,99,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33332100.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332100.sctfil,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil) 
	if g:CheckSubGroup(c33332100.sctgck,1,99,tp) then 
		local sg=g:SelectSubGroup(tp,c33332100.sctgck,false,1,99,tp) 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
end 










