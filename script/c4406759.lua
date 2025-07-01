--救世主 梣
function c4406759.initial_effect(c)  
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c4406759.lcheck)
	c:EnableReviveLimit()   
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4406759.regcon)
	e1:SetOperation(c4406759.regop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,4406759)
	e1:SetCondition(c4406759.spcon)
	e1:SetTarget(c4406759.sptg)
	e1:SetOperation(c4406759.spop)
	c:RegisterEffect(e1)  
	--xyz lv 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,1406759)
	e2:SetTarget(c4406759.xyztg) 
	e2:SetOperation(c4406759.xyzop) 
	c:RegisterEffect(e2)  
end 
function c4406759.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd77) 
end
function c4406759.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4406759.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c4406759.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c4406759.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(4406759) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end
function c4406759.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c4406759.spfilter(c,e,tp)
	return c:IsSetCard(0xd77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c4406759.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4406759.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4406759.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4406759.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end 
function c4406759.xyzctfil(c)  
	return c:IsSetCard(0xd77) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()  
end 
function c4406759.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4406759.xyzctfil,tp,LOCATION_DECK,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c4406759.xyzctfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()  
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabel(tc:GetLevel())
end 
function c4406759.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c4406759.xyzlv)
	e1:SetLabel(e:GetLabel())
	c:RegisterEffect(e1) 
	c:SetHint(CHINT_NUMBER,e:GetLabel()) 
	end 
end 
function c4406759.xyzlv(e,c,rc) 
	return c:GetLevel()+0x10000*e:GetLabel()
end












