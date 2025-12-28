--幻守之妖梦
function c8777609.initial_effect(c)
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
	e2:SetCondition(c8777609.sprcon)
	e2:SetOperation(c8777609.sprop)
	c:RegisterEffect(e2)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetRange(LOCATION_MZONE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetValue(-1500)
	c:RegisterEffect(e11)


	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(8777609,0))
	e12:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION) 
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,8777609)
	e12:SetCost(c8777609.spcost)
	e12:SetTarget(c8777609.thtg)
	e12:SetOperation(c8777609.thop)
	c:RegisterEffect(e12)
end
function c8777609.tgrfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c8777609.mnfilter(c,g)
	return g:IsExists(c8777609.mnfilter2,1,c,c)
end
function c8777609.mnfilter2(c,mc)
	return c:GetAttack()+mc:GetAttack()==3000
end
function c8777609.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c8777609.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c8777609.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c8777609.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c8777609.fselect,2,2,tp,c)
end
function c8777609.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c8777609.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c8777609.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end


function c8777609.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_ZOMBIE)
end 
function c8777609.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c8777609.ctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c8777609.ctfil,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c8777609.thfilter(c)
	return c:IsSetCard(0x1eaa) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c8777609.rettfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsSummonable(true,nil)
end
function c8777609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777609.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function c8777609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8777609.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c8777609.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(8777609,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c8777609.rettfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end