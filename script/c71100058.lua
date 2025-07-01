--公司目标逮捕中！
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(this.condition)
	e1:SetCost(this.cost)
	e1:SetTarget(this.tg)
	e1:SetOperation(this.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,this.counterfilter)
end
function this.counterfilter(c)
	return (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)) or not c:IsPreviousLocation(LOCATION_EXTRA)
end
function this.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x7d0,0x7d1)
end
function this.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(this.cfilter1,tp,LOCATION_MZONE,0,nil)==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function this.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(this.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function this.splimit(e,c)
	return not (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsLocation(LOCATION_EXTRA)
end
function this.spfilter(c,e,tp)
	return c:IsSetCard(0x7d0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function this.tgfilter(c)
	return c:IsSetCard(0x7d1) and c:IsAbleToGrave()
end
function this.tgf(c,e,tp)
	local dg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	local spg=dg:Filter(this.spfilter,nil,e,tp)
	local gg=dg:Filter(this.tgfilter,nil)
	local f1= c:IsAbleToGrave() and Duel.GetMZoneCount(tp)>1 and spg:GetClassCount(Card.GetCode)>=2
	local f2= c:IsAbleToRemove() and gg:GetClassCount(Card.GetCode)>=2
	return c:IsOnField() and c:IsControler(tp) and (f1 or f2)
end
function this.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return this.tgf(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(this.tgf,tp,LOCATION_ONFIELD,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,this.tgf,tp,LOCATION_ONFIELD,0,1,1,c,e,tp)
end
function this.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local spg=dg:Filter(this.spfilter,nil,e,tp)
	local gg=dg:Filter(this.tgfilter,nil)
	local f1= tc:IsAbleToGrave() and Duel.GetMZoneCount(tp)>1 and spg:GetClassCount(Card.GetCode)>=2
	local f2= tc:IsAbleToRemove() and gg:GetClassCount(Card.GetCode)>=2
	local op=aux.SelectFromOptions(tp,
		{f1,aux.Stringid(id,2)},
		{f2,aux.Stringid(id,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=spg:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and tc:IsRelateToEffect(e) then 
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=gg:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then 
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
