--色欲之罪暴君凯撒
function c65842061.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c65842061.mfilter,c65842061.xyzcheck,3,3,c65842061.ovfilter,aux.Stringid(65842061,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65842061,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65842061.spcon)
	e2:SetCost(c65842061.spcost)
	e2:SetTarget(c65842061.sptg)
	e2:SetOperation(c65842061.spop)
	c:RegisterEffect(e2)
end
function c65842061.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function c65842061.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c65842061.ovfilter(c)
	return c:IsFaceup() and c:GetOverlayCount()>3
end
function c65842061.cfilter2(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c65842061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65842061.cfilter2,1,nil,tp)
end
function c65842061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c65842061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,1-tp,LOCATION_EXTRA,0,1,nil) end
end
function c65842061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,1-tp,LOCATION_EXTRA,0,nil)==0 then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleExtra(1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,1056,1063,1073,1076)
	Duel.ConfirmExtratop(1-tp,1)
	local tc=Duel.GetExtraTopGroup(1-tp,1):GetFirst()
	if op==0 then tpe=TYPE_FUSION
	elseif op==1 then tpe=TYPE_SYNCHRO
	elseif op==2 then tpe=TYPE_XYZ 
	else tpe=TYPE_LINK end
	if tc:GetType()&tpe&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)>0 then
		local b1=tc:IsAbleToRemove()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(65842061,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(65842061,2)
			opval[off-1]=2
			off=off+1
		end
		ops[off]=aux.Stringid(65842061,3)
		opval[off-1]=3
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			Duel.ShuffleExtra(1-tp)
		elseif opval[op]==2 then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
			Duel.ShuffleExtra(1-tp)
		end
	else
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-tc:GetBaseAttack())
	end
end
