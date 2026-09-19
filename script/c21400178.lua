--巴托尼亚-女神授封
function c21400178.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,21400178)
	e1:SetTarget(c21400178.actg) 
	e1:SetOperation(c21400178.acop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21400179)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c21400178.thtg) 
	e2:SetOperation(c21400178.thop) 
	c:RegisterEffect(e2)
end
function c21400178.spfil(c,e,tp,rc,lv) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:IsSetCard(0x5211) and c:IsRace(rc) and not c:IsLevel(lv) and c:IsLevelBelow(7) and c:IsType(TYPE_FUSION)   
end 
function c21400178.tgfil(c,e,tp) 
	return c:IsFaceup() and c:IsSetCard(0x5211) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c21400178.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace(),c:GetLevel())   
end 
function c21400178.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c21400178.tgfil(chkc,e,tp) end 
	if chk==0 then return Duel.IsExistingTarget(c21400178.tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c21400178.tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c21400178.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then 
		local sc=Duel.SelectMatchingCard(tp,c21400178.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRace(),tc:GetLevel()):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure()
	end 
end 
function c21400178.thfil(c) 
	return c:IsFaceup() and c:IsCode(21400172) and c:IsAbleToHand() 
end 
function c21400178.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c21400178.thfil,tp,LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c21400178.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,c21400178.thfil,tp,LOCATION_REMOVED,0,1,1,nil) 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end 
end 







