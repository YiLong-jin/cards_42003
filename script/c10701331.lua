--科技属 武装珠蟹
function c10701331.initial_effect(c)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701047,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,10701331)
	e4:SetCondition(c10701331.thcon)
	e4:SetTarget(c10701331.thtg)
	e4:SetOperation(c10701331.thop)
	c:RegisterEffect(e4)  
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701047,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,10701332)
	e2:SetTarget(c10701331.sctg)
	e2:SetOperation(c10701331.scop)
	c:RegisterEffect(e2) 
end
function c10701331.synfilter(c,g)
	return c:IsSynchroSummonable(nil,g,g:GetCount()-1,g:GetCount()-1)
end
function c10701331.cfilter(c,e)
	return c==e:GetHandler()
end
function c10701331.fselect(g,e,tp)
	return g:IsExists(c10701331.cfilter,1,nil,e) and Duel.IsExistingMatchingCard(c10701331.synfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c10701331.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsLevelBelow,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,3)
	if chk==0 then return c:GetFlagEffect(10701047)==0 and g:CheckSubGroup(c10701331.fselect,2,#g,e,tp) end
	c:RegisterFlagEffect(10701047,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701331.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsLevelBelow,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,3)
	if #g<1 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectSubGroup(tp,c10701331.fselect,false,2,#g,e,tp)
	if #sg<1 then return end 
	local scg=Duel.GetMatchingGroup(c10701331.synfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if scg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=scg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,sg)
	end
end
function c10701331.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x27)
end
function c10701331.thfilter(c)
	return (c:IsCode(11264180,58258899,3868277,40253382,76641981,93138457,10701213) and c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x27)) and c:IsAbleToHand() and not c:IsType(TYPE_MONSTER)
end
function c10701331.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701331.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701331.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701331.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end