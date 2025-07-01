--原始特拉大脑 西格玛
function c9990710.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c9990710.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	aux.EnablePendulumAttribute(c,false)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(9990710,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,9990710)
	e0:SetCondition(c9990710.spcon)
	e0:SetOperation(c9990710.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
--	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990710,4))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9990711)
	e1:SetTarget(c9990710.tg5)
	e1:SetOperation(c9990710.op5)
	c:RegisterEffect(e1)

--  local e2=Effect.CreateEffect(c)
--  e2:SetDescription(aux.Stringid(9990710,2))
--  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
--  e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
 --   e2:SetType(EFFECT_TYPE_IGNITION)
--  e2:SetRange(LOCATION_PZONE)
--  e2:SetCountLimit(1,9990711)
--  e2:SetTarget(c9990710.comtg)
--  e2:SetOperation(c9990710.comop)
 --   c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9990710,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9990713)
	e3:SetCost(c9990710.thcost)
	e3:SetTarget(c9990710.thtg)
	e3:SetOperation(c9990710.thop)
--	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9990710,5))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,9990714)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c9990710.lvcost)
	e4:SetOperation(c9990710.lvop)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9990710,6))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,9990715)
	e5:SetTarget(c9990710.pentg)
	e5:SetOperation(c9990710.penop)
	c:RegisterEffect(e5)


end
function c9990710.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x671)


end
function c9990710.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_XYZ) and c:IsRankAbove(5) and c:IsAbleToExtraAsCost()
end
function c9990710.mzfilter(g,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c9990710.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c9990710.filter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-1 and mg:GetCount()>0
end
function c9990710.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c9990710.filter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	g=mg:SelectSubGroup(tp,c9990710.mzfilter,false,1,1,tp)
	Duel.SendtoDeck(g,nil,0,REASON_COST)


end
function c9990710.tgf5(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c9990710.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9990710.tgf5,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function c9990710.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9990710.tgf5,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


function c9990710.comtfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToHand()
		and c:IsSetCard(0x671) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c9990710.comtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9990710.comtfilter(chkc,tp) end
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(c9990710.comtfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9990710.comtfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9990710.comop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	   end
end


function c9990710.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9990710.thfilter(c)
	return c:IsSetCard(0x671) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9990710.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990710.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9990710.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1009025,3))
	local g=Duel.SelectMatchingCard(tp,c9990710.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end


function c9990710.costfilter(c,lv)
	return not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsSetCard(0x671) and c:IsAbleToGraveAsCost()
end
function c9990710.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c9990710.costfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9990710.costfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c9990710.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end


function c9990710.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c9990710.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and Duel.SelectYesNo(tp,aux.Stringid(9990710,7)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end