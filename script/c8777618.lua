--幻习之妖梦
function c8777618.initial_effect(c)
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
	e2:SetCondition(c8777618.sprcon)
	e2:SetOperation(c8777618.sprop)
	c:RegisterEffect(e2)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)


	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(8777618,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_IGNITION) 
	e14:SetRange(LOCATION_MZONE) 
	e14:SetCountLimit(1,8777618)
	e14:SetTarget(c8777618.tgtg) 
	e14:SetOperation(c8777618.tgop) 
	c:RegisterEffect(e14) 
end
function c8777618.tgrfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
end
function c8777618.mnfilter(c)
	return c:GetAttack()
end
function c8777618.mnfilter(c,g)
	return g:IsExists(c8777618.mnfilter2,1,c,c)
end
function c8777618.mnfilter2(c,mc)
	return c:GetAttack()+mc:GetAttack()==3000
end
function c8777618.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c8777618.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c8777618.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c8777618.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c8777618.fselect,2,2,tp,c)
end
function c8777618.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c8777618.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c8777618.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end



function c8777618.tgfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0x1eaa) or (c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER))) and c:IsFaceup()
end 
function c8777618.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8777618.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c8777618.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c8777618.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		 Duel.SendtoHand(sg,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,sg)
	end 
end 