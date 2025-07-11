--奏乐之偶像 芙蕾德莉卡
function c9879054.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c9879054.synfilter1),1)
	c:EnableReviveLimit()

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(c9879054.atk)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1)  
	

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9879054)
	e2:SetTarget(c9879054.sptg)
	e2:SetOperation(c9879054.spop)
	c:RegisterEffect(e2)
	
end
function c9879054.synfilter1(c)
	return c:IsCanHaveCounter(0x7e2)
end

function c9879054.atk(e,c)
	return e:GetHandler():GetCounter(0x7e2)*1000
end


function c9879054.spfilter(c,e,tp)
	return c:IsCanHaveCounter(0x7e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879054.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9879054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879054.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end