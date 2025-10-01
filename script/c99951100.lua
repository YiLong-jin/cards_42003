--自由职业者金初源
function c99951100.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,99951100)
	e1:SetTarget(c99951100.tetg)
	e1:SetOperation(c99951100.teop)
	c:RegisterEffect(e1)   

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,99951100)
	e2:SetCondition(c99951100.spcon1)
	e2:SetTarget(c99951100.target)
	e2:SetOperation(c99951100.operation)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,99951101)
	e3:SetTarget(c99951100.thtg)
	e3:SetOperation(c99951100.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,99951101)
	e5:SetTarget(c99951100.xdtg)
	e5:SetOperation(c99951100.xdop)
	c:RegisterEffect(e5) 


end
--e1
function c99951100.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x672)
end
function c99951100.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99951100.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c99951100.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99951100,1))
	local g=Duel.SelectMatchingCard(tp,c99951100.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
--e2
function c99951100.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c99951100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end
function c99951100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.GetMatchingGroupCount(c99951100.penfilter,tp,LOCATION_EXTRA,0,nil,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(99951100,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c99951100.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
end
function c99951100.penfilter(c)
	return c:IsFaceup(TYPE_PENDULUM) and c:IsSetCard(0x671) and not c:IsForbidden()
end
--e3
function c99951100.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x672) and c:IsType(TYPE_PENDULUM) and not c:IsCode(99951100) and c:IsAbleToHand()
end
function c99951100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99951100.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c99951100.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99951100.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e4
function c99951100.xdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then 
		local c=e:GetHandler()
		
		-- 检查是否可以特殊召唤自身
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			return false
		end
		
		-- 对于灵摆卡，需要检查是从哪里特殊召唤
		if c:IsLocation(LOCATION_EXTRA) then
			-- 从额外卡组特殊召唤灵摆怪兽需要特殊的位置检查
			return Duel.GetLocationCountFromEx(tp,tp,nil,c) > 0
		else
			-- 从其他地方特殊召唤
			return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
		end
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)   
end 

function c99951100.xdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 特殊召唤自身
	local sptg = false
	
	if c:IsLocation(LOCATION_EXTRA) then
		-- 从额外卡组特殊召唤灵摆怪兽
		if Duel.GetLocationCountFromEx(tp,tp,nil,c) > 0 then
			sptg = Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		-- 从其他地方特殊召唤
		if Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
			sptg = Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	
	-- 那之后，特殊召唤制裁者怪兽
	if sptg and Duel.IsExistingMatchingCard(c99951100.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) 
		and Duel.SelectYesNo(tp,aux.Stringid(99951100,2)) then
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c99951100.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount() > 0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c99951100.spfilter(c,e,tp)
	if not (c:IsSetCard(0x672) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then 
		return false 
	end
	
	-- 检查位置条件
	if c:IsLocation(LOCATION_GRAVE) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
	elseif c:IsLocation(LOCATION_EXTRA) then
		return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c) > 0
	end
	
	return false
end
