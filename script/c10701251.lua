--奈芙提斯之继承者
function c10701251.initial_effect(c)
	aux.AddCodeList(c,23459650)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701251,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,10701251)
	e1:SetTarget(c10701251.rttg)
	e1:SetOperation(c10701251.rtop)
	c:RegisterEffect(e1)  
	--public
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701251,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10701252)
	e2:SetCondition(c10701251.pbcon)
	e2:SetOperation(c10701251.pbop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e3)  
end
function c10701251.filter(c,e,tp,mat)
	if not c:IsType(TYPE_RITUAL) or not c:IsSetCard(0x11f)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mat=mat:Filter(c.mat_filter,nil)
	end
	return mat:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c10701251.matfilter(c,e)
	return c:IsLevelAbove(1) and c:IsDestructable(e)
end
function c10701251.cfilter(c,e)
	return (c:IsFaceup() or c:IsPublic()) and c:IsType(TYPE_MONSTER) and c:IsDestructable(e)
end
function c10701251.rfilter2(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x11f) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c10701251.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c10701251.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		local mg2=Duel.GetMatchingGroup(c10701251.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil,e)
		return (#mg1>0 and Duel.IsExistingMatchingCard(c10701251.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1))
			or (mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c10701251.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,nil,nil,LOCATION_HAND+LOCATION_MZONE)
end
function c10701251.rtop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c10701251.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c10701251.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil,e)
	local g1=Duel.GetMatchingGroup(c10701251.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,mg1)
	local g2=nil
	local g=g1
	if mg2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g2=Duel.GetMatchingGroup(c10701251.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		g=g1+g2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		if tc.mat_filter then
			mg1=mg1:Filter(tc.mat_filter,nil)
		else
			mg1:RemoveCard(tc)
		end
		if g1:IsContains(tc) and (not g2 or (g2:IsContains(tc) and not Duel.SelectYesNo(tp,aux.Stringid(10701251,3)))) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		  local mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		  tc:SetMaterial(mat)
		  Duel.Destroy(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) 
		else
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		  local mat=mg2:Select(tp,1,1,nil)
		  tc:SetMaterial(mat)
		  Duel.Destroy(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) 
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c10701251.pbcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x11f)
end
function c10701251.handfilter(c)
	return not c:IsPublic()
end
function c10701251.pbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701251.handfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c10701251.pbop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c10701251.handfilter,tp,0,LOCATION_HAND,1,nil) then
	   local g=Duel.GetMatchingGroup(c10701251.handfilter,tp,0,LOCATION_HAND,nil)
	   if g:GetCount()==0 then return end
	   local sg=g:RandomSelect(1-tp,1)
	   local tc=sg:GetFirst()
	   if tc then
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_PUBLIC)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(10701251,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(10701251,4))
	   end
		   local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_FIELD)
		   e2:SetCode(EFFECT_CANNOT_TRIGGER)
		   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e2:SetTargetRange(0,1)
		   e2:SetTarget(c10701251.aclimit)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		   Duel.RegisterEffect(e2,tp)
		   local e4=Effect.CreateEffect(e:GetHandler())
		   e4:SetType(EFFECT_TYPE_FIELD)
		   e4:SetCode(EFFECT_CANNOT_MSET)
		   e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e4:SetTargetRange(0,1)
		   e4:SetTarget(c10701251.sumlimit)
		   e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		   Duel.RegisterEffect(e4,tp)
		   local e5=e4:Clone()
		   e5:SetCode(EFFECT_CANNOT_SSET)
		   Duel.RegisterEffect(e5,tp)
		   local e6=e4:Clone()
		   e6:SetCode(EFFECT_CANNOT_TURN_SET)
		   Duel.RegisterEffect(e6,tp)
		   local e7=e4:Clone()
		   e7:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
		   e7:SetTarget(c10701251.sumlimit2)
		   Duel.RegisterEffect(e7,tp)
		   local e8=Effect.CreateEffect(e:GetHandler())
		   e8:SetType(EFFECT_TYPE_FIELD)
		   e8:SetCode(EFFECT_CANNOT_SUMMON)
		   e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		   e8:SetTargetRange(0,1)
		   e8:SetTarget(c10701251.sumlimit)
		   e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		   Duel.RegisterEffect(e8,tp)
		   local e9=e8:Clone()
		   e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		   Duel.RegisterEffect(e9,tp)
	end
end
function c10701251.aclimit(e,re,tp)
	return re:GetHandler():GetFlagEffect(10701251)>0 and re:GetHandler():IsPublic()
end
function c10701251.sumlimit(e,c)
	return c:GetFlagEffect(10701251)>0 and c:IsPublic()
end
function c10701251.sumlimit2(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0 and c:GetFlagEffect(10701251)>0 and c:IsPublic()
end