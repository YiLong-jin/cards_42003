--黑骑士小队-闪灭
function c9877642.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,c9877642.lcheck)
	c:EnableReviveLimit()  

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9877642.tg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877642,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877642)
	e3:SetCost(c9877642.cost1)
	e3:SetCondition(c9877642.spcon1)
	e3:SetTarget(c9877642.destg)
	e3:SetOperation(c9877642.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877642.spcon2)
	c:RegisterEffect(e4)

	
end
function c9877642.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877642.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877642.tg(e,c)  
	return c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end

function c9877642.lcheck(g,lc)
	return g:IsExists(c9877642.mzfilter,1,nil)
end
function c9877642.mzfilter(c)
	return c:IsLinkSetCard(0x17ec)
end


function c9877642.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877642.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877642.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877642.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end
function c9877642.desop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877642.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.CheckLPCost(tp,2000) and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9877642,0)) then
			  Duel.PayLPCost(tp,2000)
			  local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
			  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
		end
	end 
end
