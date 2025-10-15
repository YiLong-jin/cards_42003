--最凶最恶的双子 依神紫苑

c40802000.RR_ZXESZ=true
function c40802000.initial_effect(c)
	aux.EnablePendulumAttribute(c)
		
	  local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(40802000,3))
	e4:SetCategory(CATEGORY_DAMAGE) 
	e4:SetType(EFFECT_TYPE_QUICK_F) 
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c40802000.condition)
	e4:SetTarget(c40802000.rmtg)
	e4:SetOperation(c40802000.rmop)
	c:RegisterEffect(e4)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40802000,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,40802000)
	e2:SetTarget(c40802000.sptg) 
	e2:SetOperation(c40802000.spop)  
	c:RegisterEffect(e2) 
	
	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(40802000,5))
	e12:SetCategory(CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_QUICK_O) 
	e12:SetCode(EVENT_FREE_CHAIN) 
	e12:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e12:SetHintTiming(0,TIMING_END_PHASE)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1,10802000)
	e12:SetTarget(c40802000.sttg)
	e12:SetOperation(c40802000.stop)
	c:RegisterEffect(e12)
	
	 local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(40802000,6))
	e11:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_QUICK_O) 
	e11:SetCode(EVENT_FREE_CHAIN) 
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,20802000)
	e11:SetTarget(c40802000.damtg)
	e11:SetOperation(c40802000.damop)
	c:RegisterEffect(e11)
	
end
function c40802000.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and not re:GetHandler():IsType(TYPE_PENDULUM)
end
function c40802000.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true  end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c40802000.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	c:RegisterFlagEffect(40802000,RESET_EVENT+RESETS_STANDARD,0,1)
	if  Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
		local op=Duel.SelectOption(tp,aux.Stringid(40802000,0),aux.Stringid(40802000,1))+1   
		if op==1 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		else 
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Damage(p,d,REASON_EFFECT)  
		end
  else
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)   
   end
		if e:GetHandler():GetFlagEffect(40802000)>=5 then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
end

function c40802000.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(40802010) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end 
function c40802000.spfil1(c,e,tp) 
	return c:IsCode(40802010) and c:IsFaceup()
end 
function c40802000.setfilter(c)  
	return  c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c.RR_ZXESZ
end  
function c40802000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA) 
end 
function c40802000.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	   if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c40802000.spfil1,tp,LOCATION_MZONE,0,1,nil) then
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40802000.setfilter),tp,LOCATION_DECK,0,1,1,nil)
		local tc=g1:GetFirst()  
		if tc then  
			Duel.SSet(tp,tc)
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end  
	end 
  end
end



function c40802000.stfilter(c)
	return c.RR_ZXESZ and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c40802000.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40802000.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40802000.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c40802000.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c40802000.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end


function c40802000.damfilter(c)
	return c:IsFaceup()
end
function c40802000.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40802000.damfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40802000.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40802000.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,ep,math.floor(g:GetFirst():GetAttack()/2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_PZONE)
end
function c40802000.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local cp=tc:GetOwner()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and cp==tp then
	 if Duel.Damage(tp,math.floor(tc:GetBaseAttack()/2),REASON_EFFECT)~=0  and  tc:IsCode(40802000) and Duel.GetMatchingGroup(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_PZONE,0,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	 local g=Duel.GetMatchingGroup(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_PZONE,0,nil,e,tp)
		if g:GetCount()>0 then 
			local sg=g:Select(tp,1,1,nil) 
		   if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	  end  
	end
   if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and cp~=tp then
	  if Duel.Damage(1-tp,math.floor(tc:GetBaseAttack()/2),REASON_EFFECT)~=0  and  tc:IsCode(40802000) and Duel.GetMatchingGroup(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_PZONE,0,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	 local g=Duel.GetMatchingGroup(c40802000.spfil,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_PZONE,0,nil,e,tp)
		if g:GetCount()>0 then 
			local sg=g:Select(tp,1,1,nil) 
		   if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	  end
  end 
end