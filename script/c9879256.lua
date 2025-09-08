--魔石圣兽 大罪蛛
function c9879256.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),aux.NonTuner(Card.IsRace,RACE_ROCK),1,1)
	c:EnableReviveLimit()

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879256,0))
	e11:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON) 
	e11:SetType(EFFECT_TYPE_QUICK_O) 
	e11:SetCode(EVENT_FREE_CHAIN) 
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetRange(LOCATION_MZONE) 
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,9879256)
	e11:SetTarget(c9879256.sptg1)
	e11:SetOperation(c9879256.spop1)
	c:RegisterEffect(e11)


	 local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e13:SetType(EFFECT_TYPE_IGNITION)  
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_GRAVE) 
	e13:SetCountLimit(1,9879256) 
	e13:SetTarget(c9879256.dttg) 
	e13:SetOperation(c9879256.dtop) 
	c:RegisterEffect(e13) 
	
end

function c9879256.filter1(c,e,tp)
	return c:IsSetCard(0x27e3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879256.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCanAddCounter(0x107e,1)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x107e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x107e,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x107e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9879256.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c9879256.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:AddCounter(0x107e,1) then
	 if  g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9879256,1))  then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
end


function c9879256.desfil(c) 
	return c:IsFaceup() and c:GetCounter(0x107e)>0 
end 
function c9879256.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879256.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)end 
	local g=Duel.SelectTarget(tp,c9879256.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9879256.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	 Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 