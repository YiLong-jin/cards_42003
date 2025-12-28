--幻击之妖梦
function c8777604.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c8777604.sprcon)
	e2:SetOperation(c8777604.sprop)
	c:RegisterEffect(e2)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetValue(-1500)
	c:RegisterEffect(e11)

	local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e13:SetType(EFFECT_TYPE_IGNITION) 
	e13:SetRange(LOCATION_MZONE)  
	e13:SetCountLimit(1,8777604) 
	e13:SetCost(c8777604.spcost)
	e13:SetTarget(c8777604.sptg) 
	e13:SetOperation(c8777604.spop) 
	c:RegisterEffect(e13) 
	
end
function c8777604.tgrfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c8777604.mnfilter(c,g)
	return g:IsExists(c8777604.mnfilter2,1,c,c)
end
function c8777604.mnfilter2(c,mc)
	return c:GetAttack()+mc:GetAttack()==3000
end
function c8777604.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c8777604.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c8777604.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c8777604.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c8777604.fselect,2,2,tp,c)
end
function c8777604.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c8777604.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c8777604.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end

function c8777604.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end 
function c8777604.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777604.ctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c8777604.ctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c8777604.spfil(c,e,tp) 
	return c:IsSetCard(0x1eaa) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)   
end 
function c8777604.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777604.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)   
end 
function c8777604.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777604.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 