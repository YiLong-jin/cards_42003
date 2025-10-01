--最凶最恶的双子 依神女苑
c40802010.RR_ZXESZ=true
function c40802010.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	
	 local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(40802010,3))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e4:SetType(EFFECT_TYPE_QUICK_F) 
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c40802010.condition)
	e4:SetTarget(c40802010.rmtg)
	e4:SetOperation(c40802010.rmop)
	c:RegisterEffect(e4)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40802010,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,40802010)
	e2:SetTarget(c40802010.sptg) 
	e2:SetOperation(c40802010.spop)  
	c:RegisterEffect(e2) 

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(40802010,1))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetCondition(c40802010.xthcon)
	e11:SetTarget(c40802010.xthtg)
	e11:SetOperation(c40802010.xthop)
	c:RegisterEffect(e11)

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(40802010,0))
	e13:SetCategory(CATEGORY_DESTROY)
	e13:SetType(EFFECT_TYPE_QUICK_O) 
	e13:SetCode(EVENT_FREE_CHAIN) 
	e13:SetRange(LOCATION_MZONE)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCountLimit(1,10802010)
	e13:SetTarget(c40802010.thtg)
	e13:SetOperation(c40802010.thop)
	c:RegisterEffect(e13)
	
end
function c40802010.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and not re:GetHandler():IsType(TYPE_PENDULUM)
end
function c40802010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true  end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40802010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	c:RegisterFlagEffect(40802010,RESET_EVENT+RESETS_STANDARD,0,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)   
   if e:GetHandler():GetFlagEffect(40802010)>=5 then
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
   end
end


function c40802010.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(40802000) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end 
function c40802010.spfil1(c,e,tp) 
	return c:IsCode(40802000) and c:IsFaceup()
end 
function c40802010.setfilter(c)  
	return  c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c.RR_ZXESZ
end  
function c40802010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40802010.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA) 
end 
function c40802010.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c40802010.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	   if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c40802010.spfil1,tp,LOCATION_MZONE,0,1,nil) then
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40802010.setfilter),tp,LOCATION_DECK,0,1,1,nil)
		local tc=g1:GetFirst()  
		if tc then  
			Duel.SSet(tp,tc)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end  
	end 
  end
end


function c40802010.xthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA) or e:GetHandler():IsPreviousLocation(LOCATION_PZONE)
end
function c40802010.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40802010.xthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end

function c40802010.spfil2(c,e,tp) 
	return c:IsType(TYPE_PENDULUM) and not c:IsCode(40802010)
end 
function c40802010.spfil3(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(40802000) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end 
function c40802010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end  
	if chk==0 then return Duel.IsExistingTarget(c40802010.spfil2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c40802010.spfil2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE) 
end
function c40802010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		  Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		 end
	if tc:IsCode(40802000) and Duel.GetMatchingGroup(c40802010.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	 local g=Duel.GetMatchingGroup(c40802010.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 then 
			local sg=g:Select(tp,1,1,nil) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
  end
end