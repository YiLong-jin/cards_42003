--小圆前辈·小彩羽 伙伴
function c9877944.initial_effect(c)
	aux.AddCodeList(c,9877934,9877873)
	--fusion material
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,9877934,LOCATION_MZONE)
	aux.EnableChangeCode(c,9877873,LOCATION_GRAVE)
	aux.AddFusionProcCodeFun(c,{9877873,9877934},c9877944.fusfilter2,1,true,true)  
	--code  
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)
	--to hand sp 
	local e12=Effect.CreateEffect(c) 
	e12:SetDescription(aux.Stringid(9877944,0))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_QUICK_O) 
	e12:SetCode(EVENT_FREE_CHAIN) 
	e12:SetRange(LOCATION_MZONE)   
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e12:SetCountLimit(1,9877944)
	e12:SetTarget(c9877944.thstg) 
	e12:SetOperation(c9877944.thsop) 
	c:RegisterEffect(e12) 
	--dice 
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9877944,1))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES+CATEGORY_DICE)
	e11:SetType(EFFECT_TYPE_IGNITION) 
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,1877944) 
	e11:SetTarget(c9877944.dctg)
	e11:SetOperation(c9877944.dcop)
	c:RegisterEffect(e11)
end
c9877944.toss_dice=true 
function c9877944.fusfilter2(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c9877944.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	if g:GetFirst():IsCode(9877873) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0)
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)   
end 
function c9877944.thsop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local x=e:GetLabel()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		--cannot target
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(aux.tgoval) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(aux.imval1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		if x==1 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)	and Duel.SelectYesNo(tp,aux.Stringid(9877944,3)) then 
		  Duel.BreakEffect()
		  local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
		  Duel.Destroy(dg,REASON_EFFECT)
		end
	end 
end 
function c9877944.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c9877944.dcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>=4 and dc<=6 then
		local sg=Duel.SelectMatchingCard(tp,function(c) return aux.IsCodeListed(c,9877873) end,tp,LOCATION_DECK,0,1,1,nil)  
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	elseif dc>=1 and dc<=3 then
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil) 
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT) 
		end  
	end  
end


