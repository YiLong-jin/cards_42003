--破魂枪手 邪眼教皇埃比鲁
function c88888006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,c88888006.ovfilter,aux.Stringid(88888006,0),7,c88888006.xyzop)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c88888006.imecon)
	e1:SetValue(c88888006.efilter)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c88888006.sptg)
	e2:SetOperation(c88888006.spop)
	c:RegisterEffect(e2)
	--mat
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c88888006.macon)
	e3:SetTarget(c88888006.matg)
	e3:SetOperation(c88888006.maop)
	c:RegisterEffect(e3)
end
function c88888006.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(6) and c:IsSetCard(0x8980)
end
function c88888006.mafilter(c)
	return c:GetOriginalType(TYPE_LINK)
end
function c88888006.xyzop(e,tp,chk,mc)
	local og=mc:GetOverlayGroup()
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) and og:IsExists(Card.IsType,1,nil,TYPE_LINK) end
	local sc=og:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_LINK):GetFirst()
	Duel.SendtoGrave(sc,REASON_COST)
end
function c88888006.imecon(e)
	return e:GetHandler():GetOverlayCount()>=7
end
function c88888006.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c88888006.spfilter(c,e,tp)
	return c:IsSetCard(0x8980) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function c88888006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return g:IsExists(c88888006.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c88888006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:FilterSelect(tp,c88888006.spfilter,1,1,nil,e,tp):GetFirst()
		local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		local toplayer=aux.SelectFromOptions(tp,
			{s1,aux.Stringid(88888006,2),tp},
			{s2,aux.Stringid(88888006,3),1-tp})
		if toplayer~=nil then
			Duel.SpecialSummon(tc,0,tp,toplayer,false,false,POS_FACEUP)
		end
	end
end
function c88888006.macon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c88888006.mafilter(c)
	return not c:IsPublic()
end
function c88888006.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mc=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if chk==0 then return mc>0 or g and g:IsExists(c88888006.mafilter,1,nil) and c:IsType(TYPE_XYZ) end
end
function c88888006.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		local sg=g:Select(1-tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.HintSelection(sg)
		local og=sc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,sc)
	end
end