--亡灵海岸-卢瑟·哈肯
function c21400118.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)   
	e1:SetDescription(aux.Stringid(21400118,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400118)
	e1:SetCost(c21400118.cost)
	e1:SetTarget(c21400118.thtg)
	e1:SetOperation(c21400118.thop)
	c:RegisterEffect(e1)
	--spsummon spell
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(21400118,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,11400118)
	e2:SetCost(c21400118.cost) 
	e2:SetTarget(c21400118.spstg)
	e2:SetOperation(c21400118.spsop)
	c:RegisterEffect(e2)
	--esp
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(21400118,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,31400118)
	e3:SetCost(c21400118.espcost) 
	e3:SetTarget(c21400118.esptg)
	e3:SetOperation(c21400118.espop)
	c:RegisterEffect(e3)
	--xx
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)   
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,41400118) 
	e4:SetCondition(c21400118.dicon)
	e4:SetTarget(c21400118.ditg)
	e4:SetOperation(c21400118.diop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(21400118,ACTIVITY_SPSUMMON,c21400118.counterfilter)
end
function c21400118.counterfilter(c)
	return not (c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)))
end
function c21400118.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21400118,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21400118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end
function c21400118.thfilter(c)
	return c:IsCode(21400112) and c:IsAbleToHand()
end
function c21400118.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400118.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400118.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400118.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c21400118.sfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:GetType()&TYPE_CONTINUOUS+TYPE_SPELL==TYPE_CONTINUOUS+TYPE_SPELL and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400118.spstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c21400118.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c21400118.sfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21400118.sfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c21400118.spsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c21400118.ectfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost() 
end 
function c21400118.espcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c21400118.ectfil,tp,LOCATION_ONFIELD,0,1,nil) and c21400118.cost(e,tp,eg,ep,ev,re,r,rp,0) end  
	c21400118.cost(e,tp,eg,ep,ev,re,r,rp,1)
	local rg=Duel.SelectMatchingCard(tp,c21400118.ectfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	rg:AddCard(e:GetHandler()) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c21400118.espfil(c,e,tp)
	return c:IsCode(21400124) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0 
end
function c21400118.esptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c21400118.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21400118.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c21400118.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if tc then 
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP) 
		tc:CompleteProcedure()
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c21400118.dicon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()  
end 
function c21400118.ditg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c21400118.diop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local dc=Duel.TossDice(tp,1) 
	if dc==1 or dc==2 then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end 
	end 
	if dc==3 or dc==4 then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(function(e,te) 
			return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)
			e1:SetOwnerPlayer(tp)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end 
	end 
	if dc==5 or dc==6 then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(6)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 



