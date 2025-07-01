--形而上的机壳理论
function c71100557.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71100557+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(c71100557.target)
	e1:SetOperation(c71100557.activate) 
	c:RegisterEffect(e1)
end 
function c71100557.pscheck(e,tp,exc)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,exc,TYPE_PENDULUM)
	if #g==0 then return false end
	local pcon=aux.PendCondition
	return pcon(e,lpz,g)
end 
function c71100557.ckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0xaa) 
end 
function c71100557.espfil(c,e,tp) 
	return c:IsSetCard(0xaa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end 
function c71100557.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(c71100557.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,2,nil) and c71100557.pscheck(e,tp,nil)  
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local b3=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,3,nil) and dg:GetCount()>0 
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local b4=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,4,nil) and rg:GetCount()>0 
	if chk==0 then return b1 or b2 or b3 or b4 end 
	e:SetCategory(0) 
	local Category=0 
	if b1 then 
		Category=Category+CATEGORY_SPECIAL_SUMMON 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end 
	if b2 then 
		Category=Category+CATEGORY_SPECIAL_SUMMON  
	end 
	if b3 then 
		Category=Category+CATEGORY_DESTROY 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	end 
	if b4 then 
		Category=Category+CATEGORY_REMOVE
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0) 
	end 
	e:SetCategory(Category)
end
function c71100557.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(c71100557.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,2,nil) and c71100557.pscheck(e,tp,nil)  
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local b3=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,3,nil) and dg:GetCount()>0 
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local b4=Duel.IsExistingMatchingCard(c71100557.ckfil,tp,LOCATION_PZONE,0,4,nil) and rg:GetCount()>0 
	if b1 then 
		local sc=Duel.SelectMatchingCard(tp,c71100557.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end 
	if b2 then 
		local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		if lpz==nil then return end
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,TYPE_PENDULUM)
		if #g==0 then return end 
		local sg=Group.CreateGroup()
		local pop=aux.PendOperation
		pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
		Duel.RaiseEvent(sg,EVENT_SPSUMMON_SUCCESS_G_P,e,REASON_EFFECT,tp,tp,0)
		Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP) 
	end 
	if b3 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
	if b4 then 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end 
end




