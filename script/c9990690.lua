--血肉飞升 克隆·皇帝
function c9990690.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c9990690.fusfilter1,c9990690.fusfilter1,c9990690.fusfilter2)

	aux.EnablePendulumAttribute(c,false)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990690,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9990690) 
	e1:SetTarget(c9990690.target)
	e1:SetOperation(c9990690.activate)
	c:RegisterEffect(e1)
--feisheng
--	local e4=Effect.CreateEffect(c)
--	e4:SetDescription(aux.Stringid(9990690,2))
--	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
--	e4:SetType(EFFECT_TYPE_IGNITION)
--	e4:SetRange(LOCATION_MZONE)
---	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e4:SetCountLimit(1,9990691)
--	e4:SetTarget(c9990690.targetss)
 --   e4:SetOperation(c9990690.operationss)
 --   c:RegisterEffect(e4)  
	--
  --  local e2=Effect.CreateEffect(c)
  --  e2:SetDescription(aux.Stringid(9990690,3))
  --  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  --  e2:SetType(EFFECT_TYPE_IGNITION)
   -- e2:SetRange(LOCATION_MZONE)
 --   e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  --  e2:SetCountLimit(1,9990691)
  --  e2:SetTarget(c9990690.target2)
  --  e2:SetOperation(c9990690.operation2)
  --  c:RegisterEffect(e2)

--  local e2=Effect.CreateEffect(c)
--  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
--  e2:SetCode(EVENT_BE_BATTLE_TARGET)
--  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
--  e2:SetCondition(c9990690.con1)
--  e2:SetOperation(c9990690.op)
--  e2:SetCountLimit(1,9990691) 
--  c:RegisterEffect(e2)
--  local e4=e2:Clone()
--  e4:SetCode(EVENT_BECOME_TARGET)
--  e4:SetCondition(c9990690.con2)
--  e4:SetTarget(c9990690.tg2)
--  c:RegisterEffect(e4)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c9990690.cecon)
	e3:SetOperation(c9990690.ceop)
	c:RegisterEffect(e3)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9990690,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,9990692) 
	e5:SetTarget(c9990690.target1)
	e5:SetOperation(c9990690.activate1)
	c:RegisterEffect(e5)


end

function c9990690.filter1ss(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9990690.filter2ss,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9990690.filter2ss(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x671) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
--
function c9990690.filter3ss(c,e,tp)
	local rk=c:GetRank()
	return rk>2 and c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9990690.filter4ss,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9990690.filter4ss(c,e,tp,mc,rk)
	return c:IsRankBelow(rk-2) and c:IsSetCard(0x671) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990690.targetss(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990690.filter1ss(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990690.filter1ss,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990690.filter1ss,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990690.operationss(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990690.filter2ss,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
--
function c9990690.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990690.filter3ss(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990690.filter3ss,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990690.filter3ss,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990690.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990690.filter2ss,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()-2)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end


function c9990690.fusfilter1(c)
	return c:IsSetCard(0x671)
end
function c9990690.fusfilter2(c)
	return c:IsCode(9990260) or c:IsCode(9990270)
end


function c9990690.filter1s(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x671)
		and Duel.IsExistingMatchingCard(c9990690.filter2s,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9990690.filter2s(c,e,tp,mc)
	return c:IsRank(mc:GetRank()+1,mc:GetRank()+2) and c:IsSetCard(0x671) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990690.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9990690.filter1s(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9990690.filter1s,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9990690.filter1s,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9990690.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990690.filter2s,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end


function c9990690.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c9990690.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g==0 then return end
	for tc in aux.Next(g) do 
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end


--function c9990690.con1(e,tp,eg,ep,ev,re,r,rp)
--  local b=Duel.GetAttackTarget()
--  return c9990690.confil(b,e,tp)
--end
--function c9990690.confil(c,e,tp)
 --   local rk=c:GetRank()
 --   return c:IsSetCard(0x671) and c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsControler(tp) and Duel.IsExistingMatchingCard(c9990690.filter2ss,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
--  and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) 
--end
--function c9990690.filter2ss(c,e,tp,mc,rk)
--  return c:GetRank()>rk and mc:IsCanBeXyzMaterial(c)
--  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0x671) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
--end
--function c9990690.con2(e,tp,eg,ep,ev,re,r,rp)
--  return eg:IsExists(c9990690.confil,1,nil,e,tp) and rp~=tp
--end
--function c9990690.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return true end
--  local g=eg:FilterSelect(tp,c9990690.confil,1,1,nil,e,tp)
--  Duel.SetTargetCard(g)
--end
--function c9990690.op(e,tp,eg,ep,ev,re,r,rp)
--  local tc=Duel.GetFirstTarget()
--  if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
--  if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--  local g=Duel.SelectMatchingCard(tp,c9990690.filter2ss,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
--  local sc=g:GetFirst()
--  if sc then
--  local mg=tc:GetOverlayGroup()
--  if mg:GetCount()~=0 then
--	Duel.Overlay(sc,mg)
 -- end
--  sc:SetMaterial(Group.FromCards(tc))
--  Duel.Overlay(sc,Group.FromCards(tc))
--  if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
--	sc:CompleteProcedure()
--	local e6=Effect.CreateEffect(e:GetHandler())
--	e6:SetType(EFFECT_TYPE_SINGLE)
--	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
--	e6:SetRange(LOCATION_MZONE)
--	e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
--	e6:SetValue(1)
--	sc:RegisterEffect(e6)
--	local e7=e6:Clone()
--	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
--	sc:RegisterEffect(e7)
--  end
--  end
--end


function c9990690.filter1(c,e,tp)
	return c:IsSetCard(0x671) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9990690.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2)
end
function c9990690.filter2(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
	return c:IsRank(rk) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9990690.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9990690.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingTarget(c9990690.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9990690.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)
end
function c9990690.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9990690.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
