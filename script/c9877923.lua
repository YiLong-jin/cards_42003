--彩羽·黑江 友谊
function c9877923.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{9877873,9877918},c9877923.fusfilter2,1,true,true)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877923,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877886)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9877923.destg)
	e3:SetOperation(c9877923.desop)
	c:RegisterEffect(e3)

	local e14=Effect.CreateEffect(c) 
	e14:SetDescription(aux.Stringid(9877923,1))
	e14:SetCategory(CATEGORY_TOHAND) 
	e14:SetType(EFFECT_TYPE_QUICK_O) 
	e14:SetCode(EVENT_FREE_CHAIN) 
	e14:SetRange(LOCATION_MZONE)
	e14:SetHintTiming(0,TIMING_END_PHASE)
	e14:SetCountLimit(1,9877886)
	e14:SetTarget(c9877923.tgtg) 
	e14:SetOperation(c9877923.tgop) 
	c:RegisterEffect(e14)
end
function c9877923.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end

function c9877923.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and c:IsRace(RACE_SPELLCASTER)
end
function c9877923.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9877923.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9877923,2)) then
	  local g=Duel.GetMatchingGroup(c9877923.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
		if g:GetCount()>0  then 
			local sg=g:Select(tp,1,1,nil) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end
	end 
end


function c9877923.tgfil(c) 
	return c:IsAbleToHand() and (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877918)) and c:IsFaceup()
end 
function c9877923.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877923.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end 
function c9877923.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877923.tgfil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
	   Duel.SendtoHand(sg,nil,REASON_EFFECT)  
	   Duel.ConfirmCards(1-tp,sg)
	end 
end 