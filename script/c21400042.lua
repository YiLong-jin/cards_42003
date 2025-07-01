--色孽馋心兽
function c21400042.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21400042)
	e1:SetCondition(c21400042.hspcon)
	e1:SetTarget(c21400042.hsptg)
	e1:SetOperation(c21400042.hspop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400042)
	e2:SetCondition(c21400042.con)
	e2:SetTarget(c21400042.tg)
	e2:SetOperation(c21400042.op)
	c:RegisterEffect(e2) 
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCode(EFFECT_SYNCHRO_LEVEL)
	e3:SetValue(c21400042.slevel)
	c:RegisterEffect(e3)
	if not c21400042.global_check then
		c21400042.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c21400042.checkop)
		Duel.RegisterEffect(ge1,0)  
	end
end
function c21400042.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler() 
	if tc:IsSetCard(0x5210) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,21400042,RESET_PHASE+PHASE_END,0,1) 
	end
end
function c21400042.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21400042)~=0 
end
function c21400042.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400042.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21400042.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c21400042.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x5210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400042.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400042.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c21400042.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21400042.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c21400042.slevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler()) 
	if c:IsSetCard(0x5210) then 
		return (2<<16)+lv 
	else 
		return lv
	end 
end

