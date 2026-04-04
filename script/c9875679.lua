--协证曲的归栖
function c9875679.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,9875679+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c9875679.actg)  
	e1:SetOperation(c9875679.acop) 
	c:RegisterEffect(e1) 
	--Recover
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RECOVER) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)  
	e2:SetCountLimit(1,1875679) 
	e2:SetTarget(c9875679.rectg) 
	e2:SetOperation(c9875679.recop) 
	c:RegisterEffect(e2) 
end 
function c9875679.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2ea7) 
end 
function c9875679.plfil(c) 
	return c:IsSetCard(0x2ea7) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()  
end 
function c9875679.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(c9875679.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9875679.plfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9875679.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(c9875679.spfil,tp,LOCATION_HAND,0,nil,e,tp) 
	local g2=Duel.GetMatchingGroup(c9875679.plfil,tp,LOCATION_DECK,0,nil) 
	if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g1:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
			local tc=g2:Select(tp,1,1,nil):GetFirst() 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
		end 
	end  
end 
function c9875679.rectg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0x2ea7) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return x>0 end 
	Duel.SetTargetPlayer(tp)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,x*250) 
end 
function c9875679.recop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsSetCard(0x2ea7) end,tp,LOCATION_MZONE,0,nil) 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if x>0 then 
		Duel.Recover(p,x*250,REASON_EFFECT) 
	end 
end 






