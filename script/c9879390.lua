--魔石神兽 奥利哈刚暴龙
function c9879390.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),aux.NonTuner(c9879390.sfilter),1,1)
	c:EnableReviveLimit()
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c9879390.target)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9879390)
	e1:SetTarget(c9879390.actg) 
	e1:SetOperation(c9879390.acop) 
	c:RegisterEffect(e1) 
	
	 local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e13:SetType(EFFECT_TYPE_IGNITION)  
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_GRAVE) 
	e13:SetCountLimit(1,1879261) 
	e13:SetTarget(c9879390.dttg) 
	e13:SetOperation(c9879390.dtop) 
	c:RegisterEffect(e13) 
	
end
function c9879390.sfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and  c:IsRace(RACE_ROCK) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c9879390.target(e,c)
	return c:GetCounter(0x107e)~=0
end

function c9879390.ctfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x27e3) and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c9879390.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and c:IsAbleToDeck()
end  
function c9879390.spfil(c,e,tp,sc)
	return c:IsSetCard(0x27e3) and c:IsLevelBelow(8) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0   
end 
function c9879390.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c9879390.ctfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c9879390.ctfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end 
function c9879390.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c9879390.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,tc)
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and g:GetCount()>0 then 
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	if sc then
	Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)  
		local fid=e:GetHandler():GetFieldID()
		sc:RegisterFlagEffect(9879390,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(c9879390.thcon)
		e1:SetOperation(c9879390.thop)
		Duel.RegisterEffect(e1,tp)
	end
	sc:CompleteProcedure()
  end 
end 
function c9879390.thcon(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if sc:GetFlagEffectLabel(9878847)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c9879390.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end



function c9879390.desfil(c) 
	return c:IsFaceup() and c:GetCounter(0x107e)>0 
end 
function c9879390.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879390.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)end 
	local g=Duel.SelectTarget(tp,c9879390.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9879390.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 