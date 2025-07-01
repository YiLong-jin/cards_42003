--交响曲·巴萨女王
function c69969203.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x69b),2,true)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c69969203.descon)
	e1:SetTarget(c69969203.target)
	e1:SetOperation(c69969203.activate)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,69969203)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c69969203.spcon)
	e2:SetTarget(c69969203.sptg)
	e2:SetOperation(c69969203.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c69969203.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c69969203.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsLevelAbove(1)
end
function c69969203.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c69969203.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69969203.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969203.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c69969203.filter2,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c69969203.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969203.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c69969203.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
			end
			local mg=Duel.GetMatchingGroup(c69969203.filter,tp,LOCATION_MZONE,0,nil)
			local exg=Duel.GetMatchingGroup(c69969203.xyzfilter2,tp,LOCATION_EXTRA,0,nil,mg)
			local og=Duel.GetOperatedGroup()
			if og:GetCount()>0 and exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(69969203,2)) then
			Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=exg:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=mg:SelectSubGroup(tp,c69969203.gselect,false,1,mg:GetCount(),tg:GetFirst())
		Duel.XyzSummon(tp,tg:GetFirst(),sg,#sg,#sg)
	end
end
end 
function c69969203.filter(c)
	return c:IsCanOverlay() and c:IsFaceup()
end
function c69969203.xyzfilter2(c,mg)
	return c:IsType(TYPE_XYZ) and mg:CheckSubGroup(c69969203.gselect,1,#mg,c)
end
function c69969203.gselect(sg,c)
	return sg:IsExists(Card.IsSetCard,1,nil,0x69b) and c:IsXyzSummonable(sg,#sg,#sg)
end
--2
function c69969203.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c69969203.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969203.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c69969203.effcon(e)
	return e:GetHandler():GetEquipTarget()
end
--3