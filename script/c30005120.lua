--白祸 赫提斯
local cm,m,ot=GetID()  
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Effect 2
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_GRAVE_SPSUMMON)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.tetg)
	e12:SetOperation(cm.teop)
	c:RegisterEffect(e12)  
end
--Effect 1
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local mg=g:Filter(Card.IsTuner,nil,c)
	local tc=mg:GetFirst()
	if not tc then
		e:GetLabelObject():SetLabel(0)
		return
	end
	if #mg>1 then
		local tg=g-(g:Filter(Card.IsNotTuner,nil,c))
		if #tg>0 then
			tc=tg:GetFirst()
		end
	end
	local lv=tc:GetSynchroLevel(c)
	local lv2=lv>>16
	lv=lv&0xffff
	if lv2>0 and not g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),#g,#g,c) then
		lv=lv2
	end
	if tc:IsHasEffect(89818984) and not g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) then
		lv=2
	end
	e:GetLabelObject():SetLabel(lv)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.spfilter(c,e,tp,ct,code)
	return c:IsLevel(ct) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not e:GetHandler():GetMaterial():IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,ct)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
	end
end
--Effect 2
function cm.tefilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and (c:IsAbleToExtra() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.tefilter,tp,LOCATION_GRAVE,0,3,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tefilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,3,0,0)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0  then
		local mg=g:RandomSelect(1-tp,1)
		local tc=mg:GetFirst()
		Duel.HintSelection(mg)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				g:Sub(mg)
			end
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)			 
		end
	end
end
