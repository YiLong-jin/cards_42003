--见泷原魔法少女 弑神者·美国织莉子·终末
function c99940170.initial_effect(c)
	c:EnableReviveLimit()


	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c99940170.sprcon)
	e0:SetOperation(c99940170.sprop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)

	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c99940170.sslimit)
	c:RegisterEffect(e2)

	--battle
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(c99940170.damcon)
	e9:SetOperation(c99940170.disop)
	c:RegisterEffect(e9)
	--battle
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c99940170.damcon2)
	e10:SetOperation(c99940170.disop2)
	c:RegisterEffect(e10)



	--negate
--  local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(99940170,0))
--  e3:SetCategory(CATEGORY_NEGATE)
--  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
--  e3:SetType(EFFECT_TYPE_QUICK_O)
--  e3:SetRange(LOCATION_MZONE)
--  e3:SetCountLimit(1)
--  e3:SetCode(EVENT_CHAINING)
--  e3:SetCondition(c99940170.negcon)
--  e3:SetTarget(c99940170.negtg)
--  e3:SetOperation(c99940170.negop)
--  c:RegisterEffect(e3)
--  local e4=Effect.CreateEffect(c)
--  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
--  e4:SetRange(LOCATION_MZONE)
--  e4:SetTargetRange(LOCATION_MZONE,0)
--  e4:SetTarget(c99940170.eftg)
--  e4:SetLabelObject(e3)
--  c:RegisterEffect(e4)
--  local e5=Effect.CreateEffect(c)
--  e5:SetType(EFFECT_TYPE_FIELD)
--  e5:SetCode(EFFECT_ADD_TYPE)
--  e5:SetRange(LOCATION_MZONE)
--  e5:SetTargetRange(LOCATION_MZONE,0)
--  e5:SetTarget(c99940170.eftg)
--  e5:SetValue(TYPE_EFFECT)
--  c:RegisterEffect(e5)



	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99940170,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c99940170.spcost)
	e6:SetTarget(c99940170.tg)
	e6:SetOperation(c99940170.op)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c99940170.eftg)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_ADD_TYPE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c99940170.eftg)
	e8:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e8)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(99940170,2))
	e11:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c99940170.target)
	e11:SetOperation(c99940170.activate)
	c:RegisterEffect(e11)


--	local e12=Effect.CreateEffect(c)
--	e12:SetDescription(aux.Stringid(99940170,3))
--	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
 --   e12:SetType(EFFECT_TYPE_QUICK_O)
--	e12:SetRange(LOCATION_SZONE)
--	e12:SetCode(EVENT_FREE_CHAIN)
--	e12:SetCountLimit(1)
--	e12:SetTarget(c99940170.fsptg)
--	e12:SetOperation(c99940170.fspop)
--	c:RegisterEffect(e12)


end
function c99940170.filter111(c,e)
	return not c:IsImmuneToEffect(e)
end
function c99940170.filter222(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsRace(RACE_FIEND)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)

end
function c99940170.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		aux.FCheckAdditional=nil
		local res=Duel.IsExistingMatchingCard(c99940170.filter222,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99940170.filter222,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99940170.fspop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c99940170.filter111,nil,e)
	aux.FCheckAdditional=nil
	local sg1=Duel.GetMatchingGroup(c99940170.filter222,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99940170.filter222,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end






function c99940170.filter0(c)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c99940170.filter1(c,e)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c99940170.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x676) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99940170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c99940170.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c99940170.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99940170.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c99940170.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99940170.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c99940170.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99940170.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end





function c99940170.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c99940170.filter10(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x676) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940170.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99940170.filter10,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99940170.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99940170.filter10,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end





function c99940170.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_GRAVE and Duel.IsChainNegatable(ev)
end
function c99940170.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99940170.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end


function c99940170.eftg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsType(TYPE_FUSION) and c:IsRace(RACE_SPELLCASTER)


end
function c99940170.sprfilter1(c,tp)
	return c:IsCode(99900470) and Duel.IsExistingMatchingCard(c99940170.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp) and c:IsAbleToGraveAsCost()
end
function c99940170.sprfilter2(c,tp)
	return c:IsLevelAbove(7) and c:IsType(TYPE_FUSION) and c:IsSetCard(0x676) and c:IsAbleToGraveAsCost()
end
function c99940170.filter111(c)
	return c:IsCode(99900250) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c99940170.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c99940170.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp) and not Duel.IsExistingMatchingCard(c99940170.filter111, tp, LOCATION_MZONE, 0, 1, nil)
end
function c99940170.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c99940170.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.SelectMatchingCard(tp,c99940170.sprfilter2,tp,LOCATION_MZONE,0,1,1,tc,tp)
	g:AddCard(tc)
	Duel.SendtoGrave(g,REASON_COST)
end


function c99940170.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(99900250)


end
function c99940170.filter(c)
	return c:IsFaceup() and c:IsCode(99900190) or c:IsCode(99900200) or c:IsCode(99900360) or c:IsCode(99940180)
end
function c99940170.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99940170.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil) 
end
function c99940170.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
end
function c99940170.damcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c99940170.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c99940170.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(99940170,RESET_EVENT+0x1fc0000,0,1)
end