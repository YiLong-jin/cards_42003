--鹤乃·梅露 这就是最强
function c9878920.initial_effect(c)
	aux.AddCodeList(c,9877882,9877877)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,{9877882,9877877},c9878920.fusfilter2,1,true,true)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit) 
	e0:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9878920,3))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9878920)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9878920.mtcon)
	e1:SetOperation(c9878920.mtop)
	c:RegisterEffect(e1)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9878920,2))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,1878920)
	e11:SetTarget(c9878920.target)
	e11:SetOperation(c9878920.operation)
	c:RegisterEffect(e11)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9878920,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,2878920)
	e3:SetCondition(c9878920.thcon)
	e3:SetTarget(c9878920.thtg)
	e3:SetOperation(c9878920.thop)
	c:RegisterEffect(e3)

	
end
function c9878920.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c9878920.fusfilter1(c)
	return aux.IsCodeListed(c,9877877)
end
function c9878920.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c9878920.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(c9878920.fusfilter1,nil)
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	elseif ct==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c9878920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
end
function c9878920.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9878920,0),aux.Stringid(9878920,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9878920,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9878920,1))+1
	end
	local p=op==0 and tp or 1-tp
	Duel.SortDecktop(tp,p,5)
end


function c9878920.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c9878920.thfilter(c)
	return ( aux.IsCodeListed(c,9877883) or aux.IsCodeListed(c,9877877) ) and c:IsAbleToHand()
end
function c9878920.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878920.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9878920.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878920.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
