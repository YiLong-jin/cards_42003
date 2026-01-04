--八千代·美东 初始
function c9878032.initial_effect(c)
	aux.AddCodeList(c,9878030,9877883)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{9878030,9877883},c9878032.fusfilter2,1,true,true)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9878032,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9878032)
	e3:SetTarget(c9878032.destg)
	e3:SetOperation(c9878032.desop)
	c:RegisterEffect(e3)
	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9878032,1))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_QUICK_O) 
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetHintTiming(0,TIMING_END_PHASE)
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,1878030)
	e12:SetTarget(c9878032.sptg) 
	e12:SetOperation(c9878032.spop)  
	c:RegisterEffect(e12) 
end
function c9878032.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end


function c9878032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9878032.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg==0 then return end
	Duel.HintSelection(dg)
	if  Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
	end
end



function c9878032.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,9878030) or aux.IsCodeListed(c,9877883))  
end 
function c9878032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878032.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND) 
end 
function c9878032.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9878032.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 