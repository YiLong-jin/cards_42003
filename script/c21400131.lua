--亡灵海岸之战-海妖猎杀
function c21400131.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xb210) and c:IsLevelBelow(4) end)
	e2:SetValue(1)
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(21400122,21400126) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400131,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21400131)
	e2:SetCondition(c21400131.spcon)
	e2:SetTarget(c21400131.sptg)
	e2:SetOperation(c21400131.spop)
	c:RegisterEffect(e2)
	if not c21400131.global_check then
		c21400131.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c21400131.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c21400131.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
		if tc:IsCode(21400123,21400124,21400125) then  
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),21400131+tc:GetCode(),RESET_PHASE+PHASE_END,0,1) 
		end 
		tc=eg:GetNext()
	end
end
function c21400131.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,21400131+21400123)~=0   
	   and Duel.GetFlagEffect(tp,21400131+21400124)~=0  
	   and Duel.GetFlagEffect(tp,21400131+21400125)~=0  
end 
function c21400131.spckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xb210)
end 
function c21400131.spfilter(c,e,tp) 
	local b1=c:IsSetCard(0xb210)
	local b2=Duel.IsExistingMatchingCard(c21400131.spckfil,tp,LOCATION_MZONE,0,2,nil) and c:IsRace(RACE_ZOMBIE)
	return (b1 or b2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400131.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21400131.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21400131.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end




