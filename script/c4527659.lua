--冬之女王 摩根
function c4527659.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c4527659.mfilter,c4527659.xyzcheck,2,2)  
	--sp 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,4439659) 
	e1:SetCost(c4527659.spcost)
	e1:SetTarget(c4527659.sptg) 
	e1:SetOperation(c4527659.spop) 
	c:RegisterEffect(e1)  
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4527659,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON) 
	e3:SetCountLimit(1,1439659) 
	e3:SetCondition(c4527659.dscon) 
	e3:SetTarget(c4527659.dstg)
	e3:SetOperation(c4527659.dsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
end
function c4527659.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0xd77)
end
function c4527659.xyzcheck(g)
	return true 
end
function c4527659.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c4527659.spfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRankBelow(7) and c:IsSetCard(0xd77) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c4527659.xovfil,tp,LOCATION_GRAVE,0,1,c)  
end 
function c4527659.xovfil(c) 
	return c:IsType(TYPE_SPELL) and c:IsCanOverlay()  
end 
function c4527659.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4527659.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c4527659.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c4527659.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)   
	if g:GetCount()>0 then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c4527659.xovfil,tp,LOCATION_GRAVE,0,1,sc) then 
	local og=Duel.SelectMatchingCard(tp,c4527659.xovfil,tp,LOCATION_GRAVE,0,1,1,sc)
	Duel.Overlay(sc,og)
	end  
	end 
end  
function c4527659.dscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0 and eg:GetCount()==1 
end
function c4527659.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,4405659) and Duel.IsPlayerCanSpecialSummonMonster(1-tp,4527660,nil,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
end
function c4527659.dsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT) 
	local atk=eg:GetFirst():GetAttack() 
	local def=eg:GetFirst():GetDefense() 
	if Duel.IsPlayerCanSpecialSummonMonster(1-tp,4527660,nil,TYPES_TOKEN_MONSTER,atk,def,1,RACE_FAIRY,ATTRIBUTE_DARK) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then 
	local token=Duel.CreateToken(tp,4527660) 
	Duel.SpecialSummon(token,0,1-tp,1-tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(atk) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(def) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1) 
	end 
end






