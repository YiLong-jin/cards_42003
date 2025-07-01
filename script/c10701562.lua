--元素英雄 接触新宇侠
function c10701562.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,89943723,aux.FilterBoolFunction(Card.IsSetCard,0x9),1,true,true) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_MZONE,0,aux.tdcfop(c))  
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10701562.splimit)
	c:RegisterEffect(e0)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c10701562.sumop)
	c:RegisterEffect(e1)
	--return
	aux.EnableNeosReturn(c,c10701562.retop,c10701562.set_category)
end
c10701562.material_setcode=0x8
function c10701562.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c10701562.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10701562)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(10701562,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c10701562.sumtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,10701562,RESET_PHASE+PHASE_END,0,1)
end
function c10701562.sumtg(e,c)
	return c:IsSetCard(0x9,0x1f,0x8)
end
function c10701562.spfilter(c,e,tp)
	return c:IsSetCard(0x1f,0x9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701562.set_category(e,tp,eg,ep,ev,re,r,rp)
	e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	local g=Duel.GetMatchingGroup(c10701562.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10701562.gcheck(g)
	if #g==1 then return true end
	return aux.gfcheck(g,Card.IsSetCard,0x1f,0x9)
end
function c10701562.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(c10701562.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>0 and #g>0 then
		  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local sg=g:SelectSubGroup(tp,c10701562.gcheck,false,1,math.min(2,ft))
		  if sg then
			 Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		  end
		end
	end
end