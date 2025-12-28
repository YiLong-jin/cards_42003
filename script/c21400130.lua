--亡灵海岸之秘-卢瑟·哈肯的宝藏
function c21400130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--xx
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)  
	e1:SetCountLimit(1,21400130) 
	e1:SetTarget(c21400130.ditg)
	e1:SetOperation(c21400130.diop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_REMOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,11400130) 
	e2:SetTarget(c21400130.thtg)
	e2:SetOperation(c21400130.thop)
	c:RegisterEffect(e2)
end
function c21400130.ditg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c21400130.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xb210)   
end 
function c21400130.plfil(c) 
	return not c:IsForbidden() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb210) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end 
function c21400130.diop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local dc=Duel.TossDice(tp,1) 
	if dc==1 or dc==2 then 
		Duel.Draw(tp,1,REASON_EFFECT) 
	end 
	if dc==3 or dc==4 then 
		local sg=Duel.SelectMatchingCard(tp,c21400130.thfil,tp,LOCATION_DECK,0,1,1,nil) 
		if sg:GetCount()>0 then 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)  
		end 
	end 
	if dc==5 or dc==6 then 
		local sc=Duel.SelectMatchingCard(tp,c21400130.plfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		if sc then 
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			sc:RegisterEffect(e1) 
		end 
	end 
	if c:IsRelateToEffect(e) then 
		Duel.Destroy(c,REASON_EFFECT) 
	end 
end 
function c21400130.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xb210) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c21400130.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end
end


