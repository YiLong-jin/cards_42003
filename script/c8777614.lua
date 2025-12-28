--幻剑之妖梦
function c8777614.initial_effect(c)
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
	e2:SetCondition(c8777614.sprcon)
	e2:SetOperation(c8777614.sprop)
	c:RegisterEffect(e2)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetValue(-1500)
	c:RegisterEffect(e11)



	local e13=Effect.CreateEffect(c) 
	e13:SetType(EFFECT_TYPE_IGNITION) 
	e13:SetRange(LOCATION_MZONE)  
	e13:SetCountLimit(1,8777614) 
	e13:SetCost(c8777614.spcost)
	e13:SetOperation(c8777614.spop) 
	c:RegisterEffect(e13) 
end

function c8777614.tgrfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c8777614.mnfilter(c,g)
	return g:IsExists(c8777614.mnfilter2,1,c,c)
end
function c8777614.mnfilter2(c,mc)
	return c:GetAttack()+mc:GetAttack()==3000
end
function c8777614.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c8777614.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c8777614.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c8777614.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c8777614.fselect,2,2,tp,c)
end
function c8777614.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c8777614.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c8777614.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end


function c8777614.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end 
function c8777614.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777614.ctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c8777614.ctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 

function c8777614.spop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end 