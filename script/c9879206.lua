--鲑鱼子一宵
function c9879206.initial_effect(c)
	aux.AddCodeList(c,9879202)
	aux.AddXyzProcedure(c,c9879206.mfilter,4,3)
	c:EnableReviveLimit() 

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c9879206.atkfilter)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879206,0))
	e11:SetCategory(CATEGORY_POSITION)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetCountLimit(1,9879206)
	e11:SetCondition(c9879206.poscon)
	e11:SetTarget(c9879206.postg)
	e11:SetOperation(c9879206.posop)
	c:RegisterEffect(e11)

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879206,0))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,1879206)
	e12:SetCost(c9879206.negcost)
	e12:SetTarget(c9879206.sptg) 
	e12:SetOperation(c9879206.spop)  
	c:RegisterEffect(e12)
end
function c9879206.atkfilter(e,c)
	return c:IsAttackPos()
end
function c9879206.mfilter(c)
	return aux.IsCodeListed(c,9879202)
end 

function c9879206.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9879206.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c9879206.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
			sc=sg:GetNext()
		end
	end
end


function c9879206.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and aux.IsCodeListed(c,9879202)
end 
function c9879206.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879206.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND) 
end 
function c9879206.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879206.spfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 