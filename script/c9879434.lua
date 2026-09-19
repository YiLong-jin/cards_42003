--黎明圣地·宝石魔雀
function c9879434.initial_effect(c)
	aux.AddCodeList(c,9879431)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879434,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9879434)
	e1:SetCondition(c9879434.spcon)
	e1:SetTarget(c9879434.sptg)
	e1:SetOperation(c9879434.spop)
	c:RegisterEffect(e1)  
	
	
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_RECOVER)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_TO_GRAVE)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,9879434+9879434)
	e12:SetCondition(c9879434.reccon) 
	e12:SetTarget(c9879434.rectg)
	e12:SetOperation(c9879434.recop)
	c:RegisterEffect(e12)	
end

function c9879434.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1eac) or c:IsCode(9879431))   
end
function c9879434.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9879434.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9879434.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879434.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c9879434.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end 
function c9879434.rectg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c9879434.recop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end