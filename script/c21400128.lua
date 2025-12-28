--亡灵海岸的效忠仪式
function c21400128.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21400128)
	e1:SetTarget(c21400128.target)
	e1:SetOperation(c21400128.activate)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,11400128)
	e2:SetTarget(c21400128.lvtg)
	e2:SetOperation(c21400128.lvop)
	c:RegisterEffect(e2)
end
function c21400128.filter(c,tp)
	return c:IsSetCard(0xb210) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
end
function c21400128.spfil(c,e,tp)
	return c:IsSetCard(0xb210) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400128.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400128.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE)
end
function c21400128.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21400128.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c21400128.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(21400128,0)) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c21400128.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c21400128.lvfilter(c)
	return c:IsSetCard(0x1b210) and c:IsFaceup() and c:GetLevel()>0
end
function c21400128.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21400128.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400128.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c21400128.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21400128.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sel=0
		local lvl=1
		if tc:IsLevel(1) then
			sel=Duel.SelectOption(tp,aux.Stringid(21400128,2))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(21400128,2),aux.Stringid(21400128,3))
		end
		if sel==1 then
			lvl=-1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

