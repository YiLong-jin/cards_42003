--电子鱼人-探索者
function c10701317.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701317,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10701317)
	e1:SetCondition(c10701317.tgcon)
	e1:SetTarget(c10701317.tgtg)
	e1:SetOperation(c10701317.tgop)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701317,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10701318)
	e2:SetCondition(c10701317.spcon)
	e2:SetCost(c10701317.cost)
	e2:SetTarget(c10701317.sptg)
	e2:SetOperation(c10701317.spop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c10701317.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
end
function c10701317.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c10701317.tgfilter(c)
	return c:IsRace(RACE_FISH) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10701317.filter2(c)
	return c:IsSetCard(0x96)
end
function c10701317.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10701317.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>2 and g:IsExists(c10701317.filter2,1,nil) 
	   and g:GetClassCount(Card.GetLevel)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK)
end
function c10701317.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701317.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 and g:IsExists(c10701317.filter2,1,nil) and g:GetClassCount(Card.GetLevel)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=g:FilterSelect(tp,c10701317.filter2,1,1,nil)
		g:RemoveCard(sg1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=g:SelectSubGroup(tp,aux.dlvcheck,false,2,2)
		sg1:Merge(sg2)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
function c10701317.valcheck(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsRace,nil,RACE_FISH)==#g then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c10701317.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c10701317.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10701317.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701317.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10701317.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingTarget(c10701317.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10701317.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10701317.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end